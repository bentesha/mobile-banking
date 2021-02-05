
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/services/account_service.dart';
import 'package:mkombozi_mobile/widgets/progress_view.dart';
import 'package:provider/provider.dart';

class SelectAccountPage extends StatelessWidget {

  SelectAccountPage({this.account});

  final Account account;

  static Future<Account> navigateTo(BuildContext context, Account account) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SelectAccountPage(account: account)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Account')
      ),
      body: SafeArea(
        child: Consumer<AccountService>(
          builder: (context, accountService, _) {
            return FutureBuilder<List<Account>>(
              initialData: [],
              future: accountService.getAccounts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ProgressView();
                }
                return buildList(context, snapshot.data);
              },
            );
          },
        )
      )
    );
  }

  Widget buildList(BuildContext context, List<Account> data) {
    return ListView(
      children: data.map((account) => InkWell(
        onTap: () { _handleItemSelected(context, account); },
        child: ListTile(
          title: Text(account.name),
          subtitle: Text(account.accountNumber),
          leading: Radio<Account>(
              groupValue: this.account,
              value: account,
              onChanged: (value) => _handleItemSelected(context, value)
          ),
          selected: account.id == this.account?.id,
        ),
      )).toList(),
    );
  }

  _handleItemSelected(BuildContext context, Account account) {
    Navigator.of(context).pop(account);
  }
}