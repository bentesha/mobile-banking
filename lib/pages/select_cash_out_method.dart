
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mkombozi_mobile/theme/theme.dart';

class SelectWithdrawalMethodPage extends StatelessWidget {

  static Future<CashOutMethod> navigateTo(BuildContext context) {
    return Navigator.of(context).push<CashOutMethod>(MaterialPageRoute(
        builder: (context) => SelectWithdrawalMethodPage()
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
                              Icon(Icons.credit_card,
                                  size: 48,
                                  color: Colors.white
                              ),
                              SizedBox(width: 8),
                              Text('Cash Out',
                                style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(height: 16 ),
                          Text('Select cash out option',
                              style: TextStyle(color: Colors.white)
                          )
                        ],
                      )
                  ),
                  Expanded(
                      child: Ink(
                        color: Colors.black.withOpacity(0.2),
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          padding: EdgeInsets.all(16),
                          children: [
                            _GridTile(
                                icon: SvgPicture.asset('assets/atm.svg', color: Colors.white, height: 48, width: 48),
                                label: 'ATM',
                                method: CashOutMethod.atm
                            ),
                            _GridTile(
                                icon: Icon(Icons.support_agent, size: 48, color: Colors.white),
                                label: 'AGENT',
                                method: CashOutMethod.agent
                            )
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
    @required this.method});

  final Widget icon;
  final String label;
  final CashOutMethod method;

  build(context) => InkWell(
      onTap: () async {
        Navigator.of(context).pop<CashOutMethod>(method);
      },
      child: Ink(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
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

enum CashOutMethod {
  atm,
  agent
}