import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/theme/primary_background_gradient.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/pages/home.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/theme/theme.dart';
import 'package:mkombozi_mobile/widgets/pin_code_input.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = '/login';

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;

  _handlePinComplete(String pin) async {
    final loginService = Provider.of<LoginService>(context, listen: false);
    setState(() {
      _loading = true;
    });
    final response = await loginService.login(pin);
    if (response.code == 200) {
      return Navigator.of(context)
          .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
    } else if (response.code == 100) {
      MessageDialog.show(
          context: context,
          message:
              'Sorry, we could not authenticate you. Please make sure you are using a valid PIN',
          title: 'Authentication Failed');
    } else {
      MessageDialog.show(
          context: context,
          message: response.description,
          title: response.message);
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: [
        Container(
            width: double.infinity,
            //decoration: BoxDecoration(gradient: PrimaryBackgroundGradient()),
            child: Consumer<LoginService>(builder: (context, loginService, _) {
              final user = loginService.currentUser;
              return Column(
                children: [
                  SizedBox(height: 150),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          //shape: BoxShape.circle
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Image.asset('assets/brand-logo.png',
                              //height: 100,
                              width: 150
                          ))),
                  SizedBox(height: 70),
                  Text('Hello!',
                      style: TextStyle(fontSize: 18, color: AppTheme.primaryColor)),
                  SizedBox(height: 8),
                  Text(user?.name ?? '',
                      style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 32),
                  Text('Enter your PIN to continue',
                      style: TextStyle(color: AppTheme.primaryColor)),
                  SizedBox(height: 32),
                ],
              );
            })),
        Padding(
            padding: EdgeInsets.only(top: 32),
            child: _loading
                ? CircularProgressIndicator()
                : SizedBox(
                    width: 200,
                    child: PinCodeInput(
                      onChanged: (value) {},
                      onCompleted: _handlePinComplete,
                    )))
      ])),
    );
  }
}
