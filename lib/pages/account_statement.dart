
import 'package:flutter/material.dart';

class AccountStatementPage extends StatefulWidget {

  static final routeName = '/account-statement';

  @override
  State<StatefulWidget> createState() {
    return _AccountStatementPageState();
  }

}

class _AccountStatementPageState extends State<AccountStatementPage> {

  final data = [
    _Transaction('Debiting Account 388383773: Ref No: IB 3993338833 for Batch :84773', '50.00', '27 Feb 2021', false),
    _Transaction('Debiting Charge', '1,500.00', '28 Feb 2021', false),
    _Transaction('Deposit: John Nkoma', '230,000.00', '01 March 2021', true),
    _Transaction('Cash Withdrawal', '60,000.00', '02 March 2021', false),
    _Transaction('Salary Advance', '230,000.00', '05 March 2021', true),
    _Transaction('Monthly Charges', '3,500.00', '07 March 2021', false),
    _Transaction('Wallet Transfer M-PESA 07673736226', '60,000.00', '07 March 2021', false),
    _Transaction('Wallet Transfer TigoPesa 0713809050', '52,500.00', '07 March 2021', false)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Statement'),
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.arrow_back)
        // ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatementHeader(),
            // Divider(height: 1),
            Ink(
              color: Colors.grey.shade50,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text('Transactions',
                style: Theme.of(context).textTheme.subtitle2
              )
            ),
            Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: data.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = data[index];
                  return ListTile(
                    title: Text(item.description,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 14, color: Colors.grey.shade600)
                    ),
                    subtitle: Text(item.date),
                    leading: item.isCredit ? Icon(Icons.compare_arrows, color: Colors.green) :
                    Icon(Icons.compare_arrows, color: Colors.red),
                    trailing: Text(item.amount,
                      style: TextStyle(fontWeight: FontWeight.w500, color: item.isCredit ? Colors.green : Colors.red)
                    ),
                  );
                },
              )
            )
          ],
        )
      )
    );
  }
}

class _StatementHeader extends StatelessWidget {

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
            ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('**** **** ****56 89')
            ),
            Divider(height: 1),
            ListTile(
              leading: Icon(Icons.date_range),
              title: Text('Date range',
                style: Theme.of(context).textTheme.subtitle2
              ),
              subtitle: Text('12 Feb 2021 - 28 Feb 2021',
                style: Theme.of(context).textTheme.bodyText2
              ),
              trailing: IconButton(
                onPressed: () {
                  showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now().subtract(Duration(days: 90)),
                      lastDate: DateTime.now().add(Duration(days: 90))
                  );
                },
                icon: Icon(Icons.edit),
              ),
            ),
            Divider(height: 1),
            Row(
              children: [
                Expanded(
                    child: ListTile(
                      title: Text('Opening Balance',
                        style: titleStyle,
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text('10,950,000.00',
                        style: balanceStyle,
                        textAlign: TextAlign.center,
                      ),
                    )
                ),
                SizedBox(
                    height: 48,
                    child: VerticalDivider(width: 1)
                ),
                Expanded(
                    child: ListTile(
                      title: Text('Closing Balance',
                        style: titleStyle,
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text('12,950,000.00',
                        style: balanceStyle,
                        textAlign: TextAlign.center,
                      ),
                    )
                )
              ],
            )
          ],
        )
    );
  }

}

class _Transaction {

  _Transaction(this.description, this.amount, this.date, this.isCredit);

  final String description;
  final String amount;
  final String date;
  final bool isCredit;

}