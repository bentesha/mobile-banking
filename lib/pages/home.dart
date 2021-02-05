
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/pages/account_statement.dart';
import 'package:mkombozi_mobile/services/account_service.dart';
import 'package:mkombozi_mobile/widgets/account_card.dart';
import 'package:mkombozi_mobile/pages/luku_token_list.dart';
import 'package:mkombozi_mobile/widgets/drawer_menu.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  static final String routeName = '/home';

  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff072d52), //or set color with: Color(0xFF0000FF)
    ));

    return Scaffold(
      drawer: DrawerMenu(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            ActionBar(),
            ServiceList()
          ],
        )
      ),
    );
  }
}

class ServiceList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ServiceTile(
          icon: Image.asset('assets/government-tz.png', height: 32, width: 32),
          name: 'GePG',
          description: 'Government Services',
        ),
        Divider(height: 1),
        ServiceTile(
          icon: SvgPicture.asset('assets/bulb.svg', color: Colors.blue.shade800, height: 32, width: 32),
          name: 'LUKU',
          description: 'Electricity Services',
        ),
        Divider(height: 1),
        ServiceTile(
          icon: SvgPicture.asset('assets/water-tap.svg', color: Colors.blue.shade800, height: 32, width: 32),
          name: 'DAWASCO',
          description: 'Water Payment Services',
        ),
        Divider(height: 1),
        ServiceTile(
          icon: SvgPicture.asset('assets/payment.svg', color: Colors.blue.shade800, height: 32, width: 32),
          name: 'PAYMENT',
          description: 'Payment Solution',
        ),
        Divider(height: 1)
      ],
    );
  }

}

class ServiceTile extends StatelessWidget {

  ServiceTile({this.icon, this.name, this.description });

  final Widget icon;
  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: Container(
            height: double.infinity,
            child: icon
        ),
        title: Text(name,
            style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade800,
                fontWeight: FontWeight.w500
            )
        ),
        subtitle: Text(description,
            style: TextStyle(
              fontSize: 12,

            )
        ),
      )
    );
  }
}

class Header extends StatelessWidget {

  build(context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xff0a3057),
                Color(0xff338ef9),
                Color(0xff0a3057),
              ]
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
              height: 56,
              child: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu),
                ),
                title: Text('MKOMBOZI Bank',
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                  )
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 32),
            child: Consumer<AccountService>(
              builder: (context, accountService, _) {
                return FutureBuilder<List<Account>>(
                  future: accountService.getAccounts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container();
                    }
                    return CarouselSlider(
                        options: CarouselOptions(
                          viewportFraction: 0.8,
                          enableInfiniteScroll: false,
                        ),
                        items: snapshot.data.map((account) => AccountCard(account: account)).toList()
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

}

class ActionBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: EdgeInsets.symmetric(vertical: 8),
      color: Color(0xff086086),
      child: BottomNavigationBar(
          elevation: 0,
          selectedItemColor: Color(0xffa3cc55),
          unselectedItemColor: Color(0xffa3cc55),
          backgroundColor: Colors.transparent,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          items: [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Icon(Icons.account_balance_wallet_outlined),
                ),
                label: 'PAY BILL'
            ),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Icon(Icons.person_outlined),
                ),
                label: 'PAY PERSON'
            ),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Icon(Icons.payment),
                ),
                label: 'CASH OUT'
            )
          ]
      ),
    );
  }

}