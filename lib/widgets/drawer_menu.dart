
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
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
          buildItem(Icons.attach_money, 'Salary Advance', ActionType.salaryAdvance),
          buildItem(Icons.comment_bank, 'Standing Order', ActionType.standingOrder),
          buildItem(Icons.credit_card, 'Request ATM Card', ActionType.requestAtmCard),
          buildItem(Icons.book_outlined, 'Request Cheque Book', ActionType.requestChequeBook),
          buildItem(Icons.perm_device_info, 'My Devices', ActionType.myDevices),
          buildItem(Icons.lock_outline_rounded, 'Change PIN', ActionType.changePin),
          buildItem(Icons.logout, 'Logout', ActionType.logout),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
        height: 176,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xff0a3057),
                  Color(0xff338ef9),
                  Color(0xff0a3057),
                ]
            ),
            image: DecorationImage(
                image: AssetImage('assets/menu_background.png'),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.08), BlendMode.dstATop)
            )
        ),
        child: Center(
            child: Consumer<LoginService>(
              builder: (context, loginService, _) {
                final user = loginService.currentUser;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/mkcb_logo.png'),
                      backgroundColor: Colors.white,
                      radius: 36,
                    ),
                    SizedBox(height: 16),
                    Text(user.name,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        )
                    ),
                    SizedBox(height: 8),
                    Text(user.mobile,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                        )
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
                leading: Icon(icon, color: Colors.blue.shade800),
                title: Text(name,
                    style: TextStyle(color: Colors.blue.shade800)
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
  myDevices,
  changePin,
  logout
}