
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeDialog {

  static Future<String> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title:Text('Enter PIN'),
        content: PinCodeTextField(
          onChanged: null,
          appContext: context,
          length: 4,
          keyboardType: TextInputType.number,
          obscureText: true,
          obscuringCharacter: '*',
          onCompleted: (value) {
            Navigator.of(context).pop<String>(value);
          },
        ),
        actions: [],
      )
    );
  }

}