
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/pages/home.dart';
import 'package:mkombozi_mobile/pages/login.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {

  static const START_PAGE = '/start';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Color(0xffa3cc55),
        canvasColor: Colors.white,
        primaryColor: Color(0xff086086),
        textTheme: theme.textTheme.copyWith(
          caption: theme.textTheme.caption.copyWith(color: Colors.blue.shade700)
        ),
        iconTheme: theme.iconTheme.copyWith(color: Colors.grey.shade500),
      ),
      initialRoute: LoginPage.routeName,
      routes: {
        '/start': (_)=> LoginPage(),
        LoginPage.routeName: (_) => LoginPage(),
        HomePage.routeName: (_) => HomePage(),
      }
    );
  }
}