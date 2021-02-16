import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/formatters/number_input_formatter.dart';
import 'package:mkombozi_mobile/formatters/phone_number_input_formatter.dart';
import 'package:mkombozi_mobile/networking/otp_page.dart';
import 'package:mkombozi_mobile/networking/register_request.dart';
import 'package:mkombozi_mobile/theme/primary_background_gradient.dart';
import 'package:mkombozi_mobile/theme/theme.dart';
import 'package:mkombozi_mobile/widgets/pill_button.dart';
import 'package:mkombozi_mobile/widgets/progress_view.dart';

class RegisterPage extends StatefulWidget {
  static final routeName = '/register';

  @override
  createState() => _PageState();
}

class _PageState extends State<RegisterPage> {
  bool _loading = false;
  final _mobileController = TextEditingController(text: '+255');
  final _pinController = TextEditingController();

  bool get enableButton =>
      !_loading &&
      _pinController.text.length == 4 &&
      _mobileController.text.length == 13;

  _handleRegister() async {
    setState(() {
      _loading = true;
    });
    final mobile = _mobileController.text.substring(1);
    final deviceInfo = await DeviceInfoPlugin().androidInfo;

    final request = RegisterRequest(
        mobile: mobile,
        pin: _pinController.text,
        model: deviceInfo.model,
        udid: deviceInfo.androidId);
    final response = await request.send();
    if (response.code == 200) {
      OtpPage.navigateTo(context, _mobileController.text);
    } else {
      MessageDialog.show(
          context: context,
          title: response.message,
          message: response.description);
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  build(context) => Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(gradient: PrimaryBackgroundGradient()),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            _loading
                ? Expanded(child: ProgressView())
                : SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Register Device',
                            style: TextStyle(
                                fontSize: 20,
                                color: AppTheme.accentColor,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Flexible(
                                child: Text(
                                    'To register this device, enter your mobile number and the PIN code you received from your bank.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    )))
                          ],
                        ),
                        SizedBox(height: 36),
                        _TextField(
                          label: 'Mobile Number',
                          controller: _mobileController,
                          inputFormatters: [PhoneNumberInputFormatter()],
                          onChanged: (value) => setState(() {}),
                        ),
                        SizedBox(height: 8),
                        _TextField(
                          label: 'PIN Code',
                          controller: _pinController,
                          obscuredText: true,
                          inputFormatters: [NumberInputFormatter(length: 4)],
                          onChanged: (value) => setState(() {}),
                        ),
                        SizedBox(height: 48),
                      ],
                    )),
            PillButton(
              caption: _loading ? 'PLEASE WAIT..' : 'REGISTER',
              color: AppTheme.accentColor,
              disabledColor: AppTheme.accentColor.withOpacity(0.5),
              onPressed: enableButton ? _handleRegister : null,
            )
          ])));
}

class _TextField extends StatelessWidget {
  _TextField(
      {@required this.label,
      this.inputFormatters = const [],
      this.obscuredText = false,
      this.onChanged,
      this.controller,
      this.prefix});

  final String label;
  final List<TextInputFormatter> inputFormatters;
  final bool obscuredText;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final Widget prefix;

  @override
  build(context) {
    final textStyle = TextStyle(
        fontSize: 18,
        color: AppTheme.accentColor,
        fontWeight: FontWeight.bold,
        letterSpacing: 3);

    return TextField(
      inputFormatters: inputFormatters,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      controller: controller,
      style: textStyle,
      textAlign: TextAlign.center,
      obscureText: obscuredText,
      obscuringCharacter: '*',
      cursorColor: AppTheme.accentColor,
      decoration: InputDecoration(
        prefixStyle: textStyle,
        prefix: prefix,
        hintText: label,
        hintStyle: TextStyle(
            letterSpacing: 1,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            fontSize: 16),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.accentColor, width: 2),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.accentColor, width: 1),
        ),
      ),
    );
  }
}