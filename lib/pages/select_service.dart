

import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/models/service.dart';
import 'package:mkombozi_mobile/pages/service_list.dart';
import 'package:mkombozi_mobile/theme/theme.dart';

class SelectCategoryPage extends StatelessWidget {

  static Future<Service> navigateTo(BuildContext context) {
    return Navigator.of(context).push<Service>(MaterialPageRoute(
      builder: (context) => SelectCategoryPage()
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
                        Icon(Icons.account_balance_wallet_outlined,
                          size: 48,
                          color: Colors.white
                        ),
                        SizedBox(width: 8),
                        Text('Pay Bill',
                          style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(height: 16 ),
                    Text('Select category below',
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
                      _GridTile(icon: Icons.phone_android, label: 'AIRTIME', appCategoryId: '3'),
                      _GridTile(icon: Icons.tv, label: 'TV', appCategoryId: '1'),
                      _GridTile(icon: Icons.airplanemode_active_sharp, label: 'TRAVEL', appCategoryId: '2'),
                      _GridTile(icon: Icons.receipt_sharp, label: 'OTHER', appCategoryId: '4')
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
    @required this.appCategoryId});

  final IconData icon;
  final String label;
  final String appCategoryId;

  build(context) => InkWell(
    onTap: () async {
      final service = await ServiceListPage.navigateTo(context, appCategoryId);
      if (service != null) {
        Navigator.of(context).pop<Service>(service);
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