

import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/models/wallet_or_bank.dart';
import 'package:mkombozi_mobile/pages/bank_or_wallet_list.dart';
import 'package:mkombozi_mobile/theme/theme.dart';

class SelectWalletOrBankPage extends StatelessWidget {

  static Future<WalletOrBank> navigateTo(BuildContext context) {
    return Navigator.of(context).push<WalletOrBank>(MaterialPageRoute(
        builder: (context) => SelectWalletOrBankPage()
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Ink(
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        AppTheme.menuTextColor,
                        Theme.of(context).primaryColor,
                        AppTheme.menuTextColor,
                      ]
                  )
              ),
              child: Column(
                children: [
                  AppBar(
                    // title: Text('Select category')
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.login,
                                  size: 48,
                                  color: Colors.white
                              ),
                              SizedBox(width: 8),
                              Text('Send Money',
                                style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(height: 16 ),
                          Text('Select where you wish to send money to',
                              style: TextStyle(color: Colors.white)
                          )
                        ],
                      )
                  ),
                  Expanded(
                      child: Ink(
                        color: Colors.black.withOpacity(.2),
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          padding: EdgeInsets.all(16),
                          children: [
                            _GridTile(icon: Icons.account_balance, label: 'BANK', type: 'bank'),
                            _GridTile(icon: Icons.account_balance_wallet, label: 'WALLET', type: 'wallet'),
                          ],
                        ),
                      )
                  )
                ],
              )
          ),
        )
    );
  }

}

class _GridTile extends StatelessWidget {

  _GridTile({
    @required this.icon,
    @required this.label,
    @required this.type});

  final IconData icon;
  final String label;
  final String type;

  build(context) => InkWell(
      onTap: () async {
        final walletOrBank = await BankOrWalletListPage.navigateTo(context, type);
        if (walletOrBank != null) {
          Navigator.of(context).pop<WalletOrBank>(walletOrBank);
        }
      },
      child: Ink(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 48,
                color: Colors.white
            ),
            SizedBox(height: 16),
            Text(
                label,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                )
            )
          ],
        ),
      )
  );

}