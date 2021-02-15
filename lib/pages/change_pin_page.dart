
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mkombozi_mobile/app.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/networking/change_pin_request.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/widgets/action_button.dart';
import 'package:mkombozi_mobile/widgets/pin_code_input.dart';
import 'package:mkombozi_mobile/widgets/progress_view.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class ChangePinPage extends StatefulWidget {

  ChangePinPage(this.account);

  static void navigateTo(BuildContext context, Account account) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ChangePinPage(account)
    ));
  }

  createState() => _PageState();
  final Account account;

}

class _PageState extends State<ChangePinPage> {

  int index = 0;
  bool loading = false;
  final steps = [
    _Step('Enter your current PIN to continue'),
    _Step('Enter your new PIN'),
    _Step('Re-enter your new PIN to confirm')
  ];
  final controller = TextEditingController();

  _Step get currentStep => steps[index];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _moveBy(int offset) {
    if (index + offset >= steps.length) {
      currentStep.pin = controller.text;
      return _changePin();
    }
    setState(() {
      currentStep.pin = controller.text;
      index += offset;
      controller.clear();
      currentStep.pin = '';
    });
  }

  _changePin() async {
    if (steps[1].pin != steps[2].pin) {
      MessageDialog.show(
        context: context,
        message: 'You must re-enter your new PIN to confirm',
        title: 'PIN Mismatch'
      );
      return _moveBy(-1);
    } else if (steps[0].pin == steps[1].pin) {
      MessageDialog.show(
        context: context,
        message: 'To renew your PIN, your new PIN must be different from the current one',
        title: 'Identical PINs'
      );
      return _moveBy(-1);
    }

    final loginService = Provider.of<LoginService>(context, listen: false);
    final request = ChangePinRequest(
      account: widget.account,
      user: loginService.currentUser,
      pin: steps[0].pin,
      newPin: steps[1].pin
    );

    setState(() {
      loading = true;
    });
    final response = await request.send();
    if (response.code == 200) {
      await MessageDialog.show(
        context: context,
        message: 'You will be prompted to log in with your new PIN.',
        title: 'PIN Changed Successfully'
      );
      await loginService.logout();
      Navigator.of(context).pushNamedAndRemoveUntil(MyApp.START_PAGE, (route) => false);
    } else if (response.code == 100) {
      MessageDialog.show(
        context: context,
        message: 'The PIN your provided was not valid. Please retry with the correct PIN.',
        title: 'PIN Not Changed'
      );
      _moveBy(-2);
    } else {
      MessageDialog.show(
        context: context,
        message: response.description,
        title: response.message
      );
      _moveBy(-2);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  build(context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme.copyWith(
          color: Colors.grey.shade700
        ),
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (index > 0) {
              _moveBy(-1);
              return false;
            }
            return true;
          },
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: loading
                    ? ProgressView()
                    : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 32),
                        SvgPicture.asset('assets/pin_lock.svg', height: 100, width: 100),
                        SizedBox(height: 32),
                        Text('Change PIN',
                          style: theme.textTheme.headline6
                        ),
                        SizedBox(height: 16),
                        Text(currentStep.message),
                        SizedBox(height: 36),
                        SizedBox(
                          width: 200,
                          child: PinCodeInput(
                            controller: controller,
                            onChanged: (value) {
                              setState(() {
                                currentStep.pin = value;
                              });
                            },
                          )
                        ),
                      ],
                    ),
                  )
                ),
                ActionButton(
                  onPressed: currentStep.pin.length == 4
                      ? () { _moveBy(1); }
                      : null,
                  caption: index >= 2 ? 'CHANGE PIN' : 'NEXT',
                  loading: loading,
                )
              ],
            ),
          )
        )
      )
    );
  }

}

class _Step {

  _Step(this.message);

  final String message;
  String pin = '';
}