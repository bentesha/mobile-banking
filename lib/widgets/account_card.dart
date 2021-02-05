
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/dialogs/pin_dialog.dart';
import 'package:mkombozi_mobile/helpers/formatters.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/networking/balance_request.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:provider/provider.dart';

class AccountCard extends StatelessWidget {

  AccountCard({Key key, @required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 6,
        child: Container(
          // height: 176,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color(0xff009de4),
                    Color(0xff2170b5),
                    Color(0xff049bde),
                  ]
              ),
              image: DecorationImage(
                  image: AssetImage('assets/card_background.png'),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.08), BlendMode.dstATop)
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.star, color: Colors.yellow.shade700),
                    // Image.asset('assets/visa_white.png', height: 16)
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/chip.png', height: 32),
                    _AccountBalance(account: account)
                  ],
                ),
                SizedBox(height: 8),
                Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Account Number',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.end
                      ),
                      Text(Formatter.maskAccountNumber(account.accountNumber),
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white
                          )
                      )
                    ]
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Account Holder',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.end
                          ),
                          Text(account.name,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white
                              )
                          )
                        ]
                    ),
                    Image.asset('assets/visa_white.png', height: 10)
                  ],
                )
              ],
            )
        )
    );
  }
}

class _AccountBalance extends StatefulWidget {

  final Account account;

  _AccountBalance({@required this.account });

  createState() => _AccountBalanceState();

}

class _AccountBalanceState extends State<_AccountBalance> {

  var balance = 'Tap to view balance';
  var loading = false;

  _getBalance() async {
    final pin = await PinCodeDialog.show(context);
    if (pin == null) {
      return;
    }
    setState(() {
      loading = true;
    });
    final loginService = Provider.of<LoginService>(context, listen: false);
    final user = loginService.currentUser;
    final request = BalanceRequest(user, widget.account, pin);
    final response = await request.send();

    if (response.code == 200) {
      setState(() {
        balance = Formatter.formatCurrency(response.balance);
      });
    } else {
      MessageDialog.show(context, response.message);
    }
    setState(() {
      loading = false;
    });
  }

  build(context) => InkWell(
      onTap: _getBalance,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Account Balance',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.end
          ),
          loading ?
              SizedBox(
                width: 80,
                child: LinearProgressIndicator(value: null)
              ) :
              Text(balance,
                style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white
              )
          )
        ],
      )
  );

}