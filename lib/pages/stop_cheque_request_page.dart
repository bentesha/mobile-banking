import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/dialogs/pin_code_dialog.dart';
import 'package:mkombozi_mobile/formatters/number_input_formatter.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/networking/stop_cheque_request.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/widgets/account_selector.dart';
import 'package:mkombozi_mobile/widgets/action_button.dart';
import 'package:mkombozi_mobile/widgets/form_cell_divider.dart';
import 'package:mkombozi_mobile/widgets/form_cell_input.dart';
import 'package:mkombozi_mobile/widgets/progress_view.dart';
import 'package:provider/provider.dart';

class StopChequeRequestPage extends StatefulWidget {
  StopChequeRequestPage(this.account);

  final Account account;

  static void navigateTo(BuildContext context, Account account) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => StopChequeRequestPage(account)));
  }

  @override
  createState() => _PageState();
}

class _PageState extends State<StopChequeRequestPage> {
  Account _account;
  String _chequeNumber;
  bool _loading = false;

  @override
  initState() {
    _account = widget.account;
    super.initState();
  }

  _submitRequest() async {
    if (_chequeNumber == null || _chequeNumber.isEmpty) {
      MessageDialog.show(
        context: context,
        title: 'Validation Error',
        message: 'Enter cheque number'
      );
      return;
    }

    final pin = await PinCodeDialog.show(context);
    if (pin == null) {
      return;
    }
    final loginService = Provider.of<LoginService>(context, listen: false);
    setState(() {
      _loading = true;
    });
    final request = StopChequeRequest(
      account: _account,
      user: loginService.currentUser,
      pin: pin,
      chequeNumber: _chequeNumber
    );
    final response = await request.send();
    if (response.code == 200) {
      await MessageDialog.show(
        context: context,
        message: response.description,
        title: response.message
      );
      return Navigator.of(context).pop();
    }
    MessageDialog.show(
      context: context,
      message: response.message,
      title: response.description
    );
    setState(() {
      _loading = false;
    });
  }

  @override
  build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Stop Cheque',
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
                              width: double.infinity,
                              color: Colors.green.shade50,
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Select account and enter cheque number to block')
                                ],
                              )),
                          SizedBox(height: 16),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: AccountSelector(
                              label: 'Account',
                              value: _account,
                              onChanged: (value) {
                                setState((){
                                  _account = value;
                                });
                              }
                            )
                          ),
                          FormCellDivider(),
                          Padding(
                              padding: EdgeInsets.all(16),
                              child: FormCellInput(
                                label: 'Cheque Number',
                                initialValue: _chequeNumber,
                                hintText: 'Cheque number to block',
                                icon: Icon(Icons.tag),
                                inputFormatters: [NumberInputFormatter()],
                                inputType: TextInputType.number,
                                onChanged: (value) => _chequeNumber = value,
                              )),
                          Divider()
                        ],
                      )),
            ActionButton(
              caption: 'STOP CHEQUE',
              loading: _loading,
              onPressed: _loading ? null : _submitRequest,
            )
          ],
        )));
  }
}
