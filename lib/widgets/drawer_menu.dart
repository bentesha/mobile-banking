
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/pages/account_statement.dart';
import 'package:mkombozi_mobile/pages/luku_token_list.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatelessWidget {

  DrawerMenu(): super();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          buildHeader(),
          // buildItem(Icons.home, 'Home'),
          buildItem(Icons.history_toggle_off, 'Mini Statement', AccountStatementPage.routeName),
          buildItem(Icons.history_sharp, 'Full Statement', AccountStatementPage.routeName),
          buildItem(Icons.lightbulb, 'My LUKU Tokens', LukuTokenListPage.routeName),
          buildItem(Icons.money, 'Loan Application'),
          buildItem(Icons.attach_money, 'Salary Advance'),
          buildItem(Icons.comment_bank, 'Standing Order'),
          buildItem(Icons.credit_card, 'Request ATM Card'),
          buildItem(Icons.book_outlined, 'Request Cheque Book'),
          buildItem(Icons.perm_device_info, 'My Devices'),
          buildItem(Icons.lock_outline_rounded, 'Change PIN'),
          buildItem(Icons.logout, 'Logout'),
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

  Widget buildItem(IconData icon, String name, [String routeName]) {
    return Builder(
      builder: (context) {
        return InkWell(
            onTap: () {
              if (routeName != null) {
                Navigator.pop(context);
                Navigator.pushNamed(context, routeName);
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