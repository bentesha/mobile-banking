
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mkombozi_mobile/dialogs/pin_code_dialog.dart';
import 'package:mkombozi_mobile/helpers/formatters.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/networking/full_statement_request.dart';
import 'package:mkombozi_mobile/networking/mini_statement_request.dart';
import 'package:mkombozi_mobile/networking/statement_response.dart';
import 'package:mkombozi_mobile/pages/select_account.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/widgets/progress_view.dart';
import 'package:provider/provider.dart';

class AccountStatementPage extends StatefulWidget {
  AccountStatementPage(this.statementType, this.account, this.pin);

  static void navigateTo(BuildContext context, StatementType type, Account account) {
    // Prompt user for PIN when this page launches
    PinCodeDialog.show(context).then((pin) {
      if (pin == null) {
        return;
      }
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AccountStatementPage(type, account, pin)));
    });
  }

  final StatementType statementType;
  final Account account;
  final String pin;

  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<AccountStatementPage> {
  DateTimeRange dateRange;
  String _pin;
  Account _account;
  final responseListenable = ValueNotifier<StatementResponse>(null);

  @override
  initState() {
    _pin = widget.pin;
    _account = widget.account;
    super.initState();
  }

  _showDatePicker() async {
    final range = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now(),
        saveText: 'OK');
    if (range == null) {
      return;
    }
    setState(() {
      dateRange = range;
    });
  }

  _handleAccountChanged(Account account) {
    setState(() {
      _account = account;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.statementType == StatementType.full
              ? 'Full Statement'
              : 'Mini Statement'),
        ),
        body: SafeArea(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<StatementResponse>(
              valueListenable: responseListenable,
              builder: (content, response, _) {
                final openingBalance = response?.openingBalance ?? '-';
                final closingBalance = response?.closingBalance ?? '-';
                return _StatementHeader(
                  account: widget.account,
                  statementType: widget.statementType,
                  dateRange: dateRange,
                  openingBalance: openingBalance,
                  closingBalance: closingBalance,
                  onPickDate: _showDatePicker,
                  onAccountChanged: _handleAccountChanged,
                );
              }
            ),
            Ink(
                color: Colors.grey.shade50,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text('Transactions',
                    style: Theme.of(context).textTheme.subtitle2)),
            Divider(height: 1),
            Expanded(child: _buildTransactions())
          ],
        )));
  }

  Widget _buildTransactions() {
    final loginService = Provider.of<LoginService>(context, listen: false);
    final user = loginService.currentUser;
    final request = widget.statementType == StatementType.full
        ? FullStatementRequest(
            account: _account,
            user: user,
            pin: _pin,
            startDate: dateRange?.start,
            endDate: dateRange?.end)
        : MiniStatementRequest(account: _account, user: user, pin: _pin);

    if (widget.statementType == StatementType.full && dateRange == null) {
      return Center(
        child: Text('Select date range'),
      );
    }

    return FutureBuilder<StatementResponse>(
        future: request.send(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ProgressView();
          }

          final response = snapshot.data;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            responseListenable.value = response;
          });
          return response.code == 200
              ? _buildTransactionList(response.transactions)
              : _buildErrorWidget(response);
        });
  }

  Widget _buildTransactionList(List<TransactionItem> data) {
    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemBuilder: (context, index) {
        final item = data[index];
        return ListTile(
          title: Text(item.description,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(fontSize: 14, color: Colors.grey.shade600)),
          subtitle: Text(item.date),
          leading: item.isCredit
              ? Icon(Icons.compare_arrows, color: Colors.green)
              : Icon(Icons.compare_arrows, color: Colors.red),
          trailing: Text(item.amount,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: item.isCredit ? Colors.green : Colors.red)),
        );
      },
    );
  }

  Widget _buildErrorWidget(StatementResponse response) {
    return Center(
        child: Column(
      children: [
        Row(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.yellow.shade800),
            SizedBox(width: 16),
            Text('Ups! There was an error',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
          ],
        ),
        Text(response.description ?? response.message ?? '')
      ],
    ));
  }
}

class _StatementHeader extends StatelessWidget {
  _StatementHeader(
      {@required this.account,
      @required this.dateRange,
      @required this.statementType,
      @required this.onPickDate,
      @required this.onAccountChanged,
      @required this.openingBalance,
      @required this.closingBalance});

  final Account account;
  final DateTimeRange dateRange;
  final StatementType statementType;
  final VoidCallback onPickDate;
  final ValueChanged<Account> onAccountChanged;
  final String openingBalance;
  final String closingBalance;

  _formatDateRange() {
    final df = DateFormat('dd MMM yyyy');
    return dateRange == null
        ? 'Select date range'
        : '${df.format(dateRange.start)} - ${df.format(dateRange.end)}';
  }
  
  _selectAccount(BuildContext context) async {
    final account = await SelectAccountPage.navigateTo(context, this.account);
    if (account == null || this.account.id == account.id || onAccountChanged == null) {
      return;
    }
    onAccountChanged(account);
  }

  build(context) {
    final titleStyle = Theme.of(context).textTheme.caption;
    final balanceStyle = Theme.of(context).textTheme.subtitle1.copyWith(
        // fontWeight: FontWeight.bold,
        // color: Colors.green
        );

    return Material(
        type: MaterialType.card,
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: statementType == StatementType.full,
              child: Column(
                children: [
                  InkWell(
                    onTap: () { _selectAccount(context); },
                    child: ListTile(
                      leading: Icon(Icons.credit_card),
                      title: Text(Formatter.maskAccountNumber(account.accountNumber)),
                      trailing: Icon(Icons.chevron_right),
                    )
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.date_range),
                    title: Text('Date range',
                        style: Theme.of(context).textTheme.subtitle2),
                    subtitle: Text(_formatDateRange(),
                        style: Theme.of(context).textTheme.bodyText2),
                    trailing: IconButton(
                      onPressed: onPickDate,
                      icon: Icon(Icons.edit),
                    ),
                  ),
                  Divider(height: 1),
                  Row(
                    children: [
                      Expanded(
                          child: ListTile(
                        title: Text(
                          'Opening Balance',
                          style: titleStyle,
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Text(
                          openingBalance,
                          style: balanceStyle,
                          textAlign: TextAlign.center,
                        ),
                      )),
                      SizedBox(height: 48, child: VerticalDivider(width: 1)),
                      Expanded(
                          child: ListTile(
                        title: Text(
                          'Closing Balance',
                          style: titleStyle,
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Text(
                          closingBalance,
                          style: balanceStyle,
                          textAlign: TextAlign.center,
                        ),
                      ))
                    ],
                  )
                ],
              )),
          ],
        ));
  }
}

enum StatementType { full, mini }
