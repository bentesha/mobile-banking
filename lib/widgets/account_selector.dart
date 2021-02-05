import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/helpers/formatters.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/pages/select_account.dart';
import 'package:mkombozi_mobile/widgets/form_cell.dart';

class AccountSelector extends StatelessWidget {
  final String label;
  final String description;
  final Account value;
  final ValueChanged<Account> onChanged;

  String get _accountNumber {
    return value == null
        ? ''
        : Formatter.maskAccountNumber(value.accountNumber);
  }

  AccountSelector(
      {Key key,
      @required this.label,
      this.description,
      this.value,
      this.onChanged})
      : super(key: key);

  build(context) => FormCell(
        onPressed: () { _handleOnCellPressed(context); },
        label: label,
        description: description,
        icon: Icon(Icons.credit_card),
        child: Text(_accountNumber, style: TextStyle(fontSize: 16)),
        trailing: Icon(Icons.chevron_right),
      );

  void _handleOnCellPressed(BuildContext context) async {
    final account = await SelectAccountPage.navigateTo(context, value);
    if (account == null || onChanged == null) {
      return;
    }
    onChanged(account);
  }
}
