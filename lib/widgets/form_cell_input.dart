import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/widgets/form_cell.dart';

class FormCellInput extends StatelessWidget {
  final String label;
  final String hintText;
  final Widget icon;
  final TextAlign textAlign;
  final TextInputType inputType;
  final String initialValue;
  final ValueChanged<String> onChanged;

  final _controller = TextEditingController();

  FormCellInput(
      {this.label,
      this.initialValue,
      this.hintText,
      this.icon,
      this.textAlign = TextAlign.start,
      this.inputType,
      this.onChanged}) {
    _controller.text = this.initialValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return FormCell(
        label: label,
        icon: icon,
        child: TextField(
          controller: _controller,
          onChanged: onChanged,
          textAlign: textAlign,
          keyboardType: inputType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            border: UnderlineInputBorder(
                borderSide: BorderSide.none, borderRadius: BorderRadius.zero),
          ),
        ));
  }
}
