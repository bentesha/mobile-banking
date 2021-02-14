import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mkombozi_mobile/widgets/form_cell.dart';

class FormCellDate extends StatefulWidget {
  final String label;
  final String hintText;
  final Widget icon;
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  FormCellDate({this.label, this.date, this.hintText, this.icon, this.onChanged});

  @override
  createState() => _WidgetState();

}

class _WidgetState extends State<FormCellDate> {

  DateTime _date;

  @override
  initState() {
    _date = widget.date;
    super.initState();
  }

  String _formatDate(DateTime date) {
    if (date == null) {
      return null;
    }
    DateFormat df = DateFormat('dd MMM yyyy');
    return df.format(date);
  }

  String get displayValue => _formatDate(_date) ?? widget.hintText ?? '';

  _showDatePicker() async {
    final value = await showDatePicker(
        context: context,
        initialDate: _date ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365))
    );
    if (value == null || widget.onChanged == null) {
      return;
    }
    setState(() {
      _date = value;
    });
    widget.onChanged(value);
  }

  @override
  build(context) => FormCell(
    label: widget.label,
    icon: widget.icon,
    trailing: Icon(Icons.chevron_right),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(displayValue)
    ),
    onPressed: _showDatePicker,
  );

}
