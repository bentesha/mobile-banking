
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/bank.dart';
import 'package:mkombozi_mobile/models/branch.dart';
import 'package:mkombozi_mobile/networking/resolve_branch_request.dart';
import 'package:mkombozi_mobile/widgets/form_cell.dart';

class BranchSelectorCell extends StatefulWidget {

  final String label;
  final String hintText;
  final Widget icon;
  final Branch value;
  final Account account;
  final Bank bank;
  final ValueChanged<Branch> onChanged;

  BranchSelectorCell({
    @required this.label,
    @required this.value,
    @required this.hintText,
    @required this.icon,
    @required this.account,
    @required this.bank,
    @required this.onChanged});

  @override
  State<StatefulWidget> createState() => _BranchSelectorCellState();

}

class _BranchSelectorCellState extends State<BranchSelectorCell> {

  List<Branch> _branches;
  Branch _value;

  Future<List<Branch>> _getBranches() async {
    if (_branches == null && widget.account != null && widget.bank != null) {
      final request = ResolveBranchRequest();
      final response = await request.send();
      _branches = response.branches;
    }
    return _branches ?? <Branch>[];
  }

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormCell(
        label: widget.label,
        icon: widget.icon,
        child: FutureBuilder<List<Branch>>(
          initialData: [],
          future: _getBranches(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Could not load branches');
            }

            return DropdownButtonFormField<Branch>(
              decoration: InputDecoration.collapsed(hintText: widget.hintText),
              // hint: Text(widget.hintText),
              value: _value,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
                print('branch changed: ${value?.name ?? 'no branch name'}');
                widget.onChanged(value);
              },
              items: snapshot.data.map((branch) => DropdownMenuItem(
                child: Text(branch.name),
                value: branch)
              ).toList()
            );
          },
        ));
  }
}
