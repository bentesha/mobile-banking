
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeInput extends StatelessWidget {

  PinCodeInput({@required this.onChanged, this.controller, this.onCompleted});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;

  @override
  build(context) => PinCodeTextField(
    controller: controller,
    autoDisposeControllers: false,
    appContext: context,
    keyboardType: TextInputType.number,
    pinTheme: PinTheme(
      activeFillColor: Theme.of(context).primaryColor,
      activeColor: Theme.of(context).primaryColor,
      inactiveColor: Colors.grey.shade400,
    ),
    obscuringCharacter: '*',
    obscureText: true,
    length: 4,
    onChanged: onChanged,
    onCompleted: onCompleted,
  );

}