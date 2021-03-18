import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/data/offline_database.dart';
import 'package:mkombozi_mobile/helpers/formatters.dart';
import 'package:mkombozi_mobile/models/fixed_deposit.dart';
import 'package:mkombozi_mobile/widgets/form_cell.dart';
import 'package:provider/provider.dart';

class FixedDepositSelector extends StatefulWidget {
  FixedDepositSelector(
      {@required this.label,
      @required this.accountNumber,
      @required this.value,
      this.icon,
      this.onChanged});

  final String label;
  final Widget icon;
  final String accountNumber;
  final FixedDeposit value;
  final ValueChanged<FixedDeposit> onChanged;

  @override
  createState() => _FixedDepositSelectorState();
}

class _FixedDepositSelectorState extends State<FixedDepositSelector> {
  FixedDeposit _value;

  @override
  initState() {
    _value = widget.value;
    super.initState();
  }

  _handleValueChanged(FixedDeposit value) {
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
      child: Consumer<OfflineDatabase>(
        builder: (context, database, child) {
          return FutureBuilder<List<FixedDeposit>>(
            future: database.getFixedDeposits(widget.accountNumber),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error loading fixed deposits');
              }

              return DropdownButtonFormField<FixedDeposit>(
                decoration: InputDecoration.collapsed(hintText: widget.label),
                itemHeight: 100,
                isExpanded: true,
                value: _value,
                onChanged: _handleValueChanged,
                items: (snapshot.data ?? [])
                    .map((fd) => DropdownMenuItem(
                      value: fd,
                      child: Text(fd.toString()),
                    )).toList(),
              );
            }
          );
        }
      ));
}
