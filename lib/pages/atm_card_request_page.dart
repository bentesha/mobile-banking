import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/dialogs/pin_code_dialog.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/networking/atm_card_request.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/widgets/account_selector.dart';
import 'package:mkombozi_mobile/widgets/action_button.dart';
import 'package:mkombozi_mobile/widgets/progress_view.dart';
import 'package:provider/provider.dart';

class AtmCardRequestPage extends StatefulWidget {
  AtmCardRequestPage(this.account);

  final Account account;

  static void navigateTo(BuildContext context, Account account) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => AtmCardRequestPage(account)));
  }

  @override
  createState() => _PageState();
}

class _PageState extends State<AtmCardRequestPage> {
  Account _account;
  bool _loading = false;

  @override
  initState() {
    _account = widget.account;
    super.initState();
  }

  _submitRequest() async {
    final pin = await PinCodeDialog.show(context);
    if (pin == null) {
      return;
    }
    final loginService = Provider.of<LoginService>(context, listen: false);
    setState(() {
      _loading = true;
    });
    final request = AtmCardRequest(
        account: _account, user: loginService.currentUser, pin: pin);
    final response = await request.send();
    if (response.code == 200) {
      await MessageDialog.show(
          context: context,
          message: 'Your ATM Card request was successfully sent',
          title: 'Request Sent');
      return Navigator.of(context).pop();
    }
    MessageDialog.show(
        context: context,
        title: response.message,
        message: response.description);
    setState(() {
      _loading = false;
    });
  }

  @override
  build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ATM Card Request',
              style: Theme.of(context).textTheme.headline6),
          backgroundColor: Colors.white,
          iconTheme:
              Theme.of(context).iconTheme.copyWith(color: Colors.grey.shade700),
        ),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: _loading
                    ? ProgressView()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              color: Colors.green.shade50,
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text('Instant ATM Card Request',
                                  //     style: TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //       color: Colors.green.shade800
                                  //     )
                                  // ),
                                  // SizedBox(height: 8),
                                  Text(
                                      'Select the account below for which you want to request an ATM card')
                                ],
                              )),
                          Divider(height: 1),
                          Padding(
                              padding: EdgeInsets.all(16),
                              child: AccountSelector(
                                label: 'Account',
                                value: _account,
                                onChanged: (value) => _account = value,
                              )),
                          Divider()
                        ],
                      )),
            ActionButton(
              caption: 'SEND REQUEST',
              loading: _loading,
              onPressed: _loading ? null : _submitRequest,
            )
          ],
        )));
  }
}
