
import 'package:flutter/services.dart';

class PhoneNumberInputFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regex = RegExp(r'^(\+255$|\+255[6,7][0-9]{0,8}$)');
    return regex.hasMatch(newValue.text) ? newValue : oldValue;
  }

}