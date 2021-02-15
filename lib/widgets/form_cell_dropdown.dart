import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/widgets/form_cell.dart';

class FormCellDropDown extends StatefulWidget {
  FormCellDropDown(
      {@required this.label,
      @required this.options,
      @required this.value,
      this.icon,
      this.onChanged});

  final List<String> options;
  final String label;
  final Widget icon;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  createState() => _PageState();
}

class _PageState extends State<FormCellDropDown> {
  String _value;

  @override
  initState() {
    _value = widget.value;
    super.initState();
  }

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
        items: (widget.options ?? [])
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
      ));
}
