
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mkombozi_mobile/networking/config_request.dart';
import 'package:mkombozi_mobile/networking/login_request.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {

  static final String routeName = '/login';

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }

}

class _LoginPageState extends State<LoginPage> {

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter PIN'
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final loginService = Provider.of<LoginService>(context, listen: false);
                  setState(() {
                    loading = true;
                  });
                  final response = await loginService.login('8270');
                  setState(() {
                    loading = false;
                  });
                },
                child: Text(loading ? 'Loading...' : 'LOGIN'),
              )
            ],
          )
        )
      ),
    );
  }

}