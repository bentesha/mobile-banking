import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/formatters/number_input_formatter.dart';
import 'package:mkombozi_mobile/networking/otp_verification_request.dart';
import 'package:mkombozi_mobile/pages/login.dart';
import 'package:mkombozi_mobile/theme/primary_background_gradient.dart';
import 'package:mkombozi_mobile/theme/theme.dart';
import 'package:mkombozi_mobile/widgets/pill_button.dart';
import 'package:mkombozi_mobile/widgets/progress_view.dart';

class OtpPage extends StatefulWidget {
  OtpPage(this.mobileNumber);

  final String mobileNumber;

  static void navigateTo(BuildContext context, String mobileNumber) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => OtpPage(mobileNumber)));
  }

  @override
  createState() => _PageState();
}

class _PageState extends State<OtpPage> {
  bool _loading = false;
  final _otpController = TextEditingController();

  bool get enableButton => _otpController.text.length == 6;

  _verifyOtp() async {
    setState(() {
      _loading = true;
    });

    final request = OtpVerificationRequest(otp: _otpController.text);
    final response = await request.send();
    if (response.code == 200) {
      await MessageDialog.show(
          context: context,
          title: 'Verification Complete',
          message: 'You will be directed to the login page to continue.');
      return Navigator.of(context)
          .pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
    }
    MessageDialog.show(
      context: context,
      title: response.message,
      message: response.description
    );

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
                        Text('Almost Done...',
                            style: TextStyle(
                                fontSize: 20,
                                color: AppTheme.accentColor,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        Text(
                            'A verification code has been sent to ${widget.mobileNumber}',
                            style: TextStyle(color: Colors.white, height: 1.5)),
                        SizedBox(height: 16),
                        Text(
                            'Enter the verification code below to complete your registration',
                            style: TextStyle(color: Colors.white, height: 1.3)),
                        SizedBox(height: 36),
                        _TextField(
                          label: 'Verification Code',
                          controller: _otpController,
                          obscuredText: true,
                          inputFormatters: [NumberInputFormatter(length: 6)],
                          onChanged: (value) => setState(() {}),
                        ),
                        SizedBox(height: 48),
                      ],
                    )),
            PillButton(
              caption: _loading ? 'PLEASE WAIT..' : 'VERIFY',
              color: AppTheme.accentColor,
              disabledColor: AppTheme.accentColor.withOpacity(0.5),
              onPressed: enableButton ? _verifyOtp : null,
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
