
import 'package:flutter/services.dart';

class NumberInputFormatter extends TextInputFormatter {

  NumberInputFormatter({this.length = 32}) {
    assert(length != null);
  }

  final int length;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final input = newValue.text;
    if (input == '') {
      return newValue;
    }
    if (input.length > length) {
      return oldValue;
    }
    final regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(input) ? newValue : oldValue;
  }


}