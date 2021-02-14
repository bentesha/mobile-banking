
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/widgets/form_cell.dart';

class FormCellDropDown extends StatefulWidget {

  FormCellDropDown({@required this.label, @required this.options, this.icon, this.onChanged});

  final List<String> options;
  final String label;
  final Widget icon;
  final ValueChanged<String> onChanged;

  @override
  createState() => _PageState();

}

class _PageState extends State<FormCellDropDown> {

  String _value;

  _handleValueChanged(String value) {
    setState(() {
      _value = value;
    });
    if (widget.onChanged != null) {
      widget.onChanged(value);
    }
  }

  @override
  build(context) => FormCell(
    label: widget.label,
    icon: widget.icon,
    child: DropdownButton<String>(
      isExpanded: true,
      value: _value,
      onChanged: _handleValueChanged,
      items: (widget.options ?? []).map((item) => DropdownMenuItem(
        value: item,
        child: Text(item)
      )).toList(),
    )
  );

}