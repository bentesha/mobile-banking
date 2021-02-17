
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/pages/register_page.dart';
import 'package:mkombozi_mobile/theme/assets.dart';
import 'package:mkombozi_mobile/theme/primary_background_gradient.dart';
import 'package:mkombozi_mobile/theme/theme.dart';
import 'package:mkombozi_mobile/pages/login.dart';
import 'package:mkombozi_mobile/widgets/pill_button.dart';

class LandingPage extends StatelessWidget {

  static final routeName = '/start';

  @override
  build(context) => Scaffold(
    body: Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: PrimaryBackgroundGradient()
      ),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(Assets.appLogo,
              height: 150,
              width: 150,
              fit: BoxFit.contain,
              color: Colors.white
            )
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello! Welcome to',
                  style: TextStyle(
                    fontSize: 20,
                      color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(height: 8),
                Text('MKOMBOZI COMMERCIAL BANK',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                ),
                Text('Mobile Banking',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(height: 48),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text('If this is the first time to use this app on your device, click register.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        )
                      )
                    )
                  ],
                )
              ],
            )
          ),
          SizedBox(height: 48),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PillButton(
                caption: 'REGISTER',
                color: AppTheme.accentColor,
                onPressed: () {
                  Navigator.of(context).pushNamed(RegisterPage.routeName);
                },
              ),
              SizedBox(height: 16),
              PillButton(
                caption: 'LOG IN',
                color: AppTheme.secondaryColor,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushNamed(LoginPage.routeName);
                },
              )
            ],
          )
        ]
      )
    )
  );

}