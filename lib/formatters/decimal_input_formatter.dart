import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') {
      return newValue;
    }
    String text = newValue.text.replaceAll(',', '');
    final number = double.tryParse(text);
    if (number == null) {
      return oldValue;
    }
    final formatted = NumberFormat.decimalPattern().format(number);
    return TextEditingValue(
        text: formatted,
        selection: TextSelection(
            extentOffset: formatted.length, baseOffset: formatted.length));
  }
}
