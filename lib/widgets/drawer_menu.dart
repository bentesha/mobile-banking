
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/theme/theme.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatelessWidget {
  
  DrawerMenu({@required this.onAction}): super();
  
  final ValueChanged<ActionType> onAction;
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          buildHeader(),
          buildItem(Icons.history_toggle_off, 'Mini Statement', ActionType.miniStatement),
          buildItem(Icons.history_sharp, 'Full Statement', ActionType.fullStatement),
          buildItem(Icons.lightbulb, 'My LUKU Tokens', ActionType.lukuTokens),
          buildItem(Icons.money, 'Loan Application', ActionType.loanApplication),
          buildItem(Icons.payments, 'Salary Advance', ActionType.salaryAdvance),
          buildItem(Icons.comment_bank, 'Standing Order', ActionType.standingOrder),
          buildItem(Icons.credit_card, 'Request ATM Card', ActionType.requestAtmCard),
          buildItem(Icons.book_outlined, 'Request Cheque Book', ActionType.requestChequeBook),
          buildItem(Icons.block, 'Stop Cheque', ActionType.stopCheque)
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xff0071a3),
                  AppTheme.primaryColor,
                  Color(0xff0071a3),
                ]
            ),
            image: DecorationImage(
                image: AssetImage('assets/menu_background.png'),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.08), BlendMode.dstATop)
            )
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 32),
          child: Consumer<LoginService>(
            builder: (context, loginService, _) {
              final user = loginService.currentUser;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 90),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      if (onAction != null) {
                        onAction(ActionType.profile);
                      }
                    },
                    child:
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(user.name[0].toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )
                            )
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  )
                                ),
                                Text('+' + user.mobile,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14
                                  )
                                )
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.white)
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          )
        )
    );
  }

  Widget buildItem(IconData icon, String name, ActionType type) {
    return Builder(
      builder: (context) {
        return InkWell(
            onTap: () {
              // Close drawer menu
              Navigator.of(context).pop();
              if (onAction != null) {
                onAction(type);
              }
            },
            child: ListTile(
                leading: Icon(icon, color: AppTheme.menuTextColor),
                title: Text(name,
                    style: TextStyle(color: AppTheme.menuTextColor)
                )
            )
        );
      }
    );
  }
}

enum ActionType {
  miniStatement,
  fullStatement,
  lukuTokens,
  loanApplication,
  salaryAdvance,
  standingOrder,
  requestAtmCard,
  requestChequeBook,
  profile,
  stopCheque
}