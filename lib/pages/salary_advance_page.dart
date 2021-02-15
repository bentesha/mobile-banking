import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/dialogs/pin_code_dialog.dart';
import 'package:mkombozi_mobile/formatters/decimal_input_formatter.dart';
import 'package:mkombozi_mobile/helpers/utils.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/networking/salary_advance_request.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/widgets/account_selector.dart';
import 'package:mkombozi_mobile/widgets/form_cell_divider.dart';
import 'package:mkombozi_mobile/widgets/form_cell_input.dart';
import 'package:mkombozi_mobile/widgets/label_value_cell.dart';
import 'package:mkombozi_mobile/widgets/workflow.dart';
import 'package:mkombozi_mobile/widgets/workflow_item.dart';
import 'package:provider/provider.dart';

class SalaryAdvancePage extends Workflow<_FormData> {
  static void navigateTo(BuildContext context, Account account) {
    final page = SalaryAdvancePage(account);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  final Account account;

  SalaryAdvancePage(this.account)
      : super(
            title: 'Salary Advance',
            actionLabel: 'REQUEST ADVANCE',
            confirmLabel: 'CONFIRM');

  @override
  _FormData createWorkflowState() => _FormData(account);

  @override
  build(context, data) => [_StepOne(data), _StepTwo(data)];

  @override
  bool isDirty(_FormData data) => data.isDirty;
}

class _StepOne extends WorkflowItem {
  final _FormData _data;

  _StepOne(this._data);

  @override
  String get title => 'Details';

  @override
  Future<bool> moveNext(context) async {
    String message;

    if (_data._account == null) {
      message = 'Account is required';
    } else if (_data.netSalary == null || _data.netSalary.isEmpty) {
      message = 'Enter net salary';
    } else if (_data.amount == null || _data.amount.isEmpty) {
      message = 'Enter amount';
    }

    if (message != null) {
      MessageDialog.showFormError(context: context, message: message);
    }

    return message == null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AccountSelector(
          label: 'Account',
          value: _data.account,
          onChanged: (value) => _data.account = value,
        ),
        FormCellDivider(),
        FormCellInput(
            onChanged: (value) => _data.netSalary = value,
            label: 'Net Salary',
            inputFormatters: [DecimalInputFormatter()],
            hintText: 'Your net salary amount',
            inputType: TextInputType.number,
            textAlign: TextAlign.right,
            initialValue: _data.netSalary,
            icon: Icon(Icons.attach_money)),
        FormCellDivider(),
        FormCellInput(
            onChanged: (value) => _data.amount = value,
            inputFormatters: [DecimalInputFormatter()],
            label: 'Advance Amount',
            hintText: 'Requested salary advance amount',
            inputType: TextInputType.number,
            textAlign: TextAlign.right,
            initialValue: _data.amount,
            icon: Icon(Icons.attach_money)),
      ],
    );
  }
}

class _StepTwo extends WorkflowItem {
  final _FormData _data;

  _StepTwo(this._data);

  @override
  Future<bool> complete(context) async {
    final pin = await PinCodeDialog.show(context);
    if (pin == null) {
      return false;
    }
    final user = Provider.of<LoginService>(context, listen: false).currentUser;
    final request = SalaryAdvanceRequest(
        account: _data.account,
        user: user,
        pin: pin,
        netSalary: Utils.stringToDouble(_data.netSalary),
        amount: Utils.stringToDouble(_data.amount));

    final response = await request.send();
    if (response.code == 200) {
      await MessageDialog.show(
          context: context,
          message: 'Your salary advance request has been submitted',
          title: 'Success');
      return true;
    }

    await MessageDialog.show(
        context: context,
        message: response.description,
        title: response.message);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Icon(Icons.info, color: Colors.blue.shade800),
          SizedBox(width: 8),
          Flexible(
            child: Text('Please check and confirm details below',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontWeight: FontWeight.bold)),
          )
        ]),
        SizedBox(height: 32),
        Ink(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelValueCell(
                          label: 'Account', value: _data.account.maskedNumber),
                      LabelValueCell(
                          label: 'Net Salary', value: _data.netSalary),
                      LabelValueCell(
                          label: 'Requested Advance', value: _data.amount)
                    ])))
      ],
    );
  }

  @override
  String get title => 'Confirm';
}

class _FormData {
  Account _account;
  String _amount;
  String _netSalary;
  bool isDirty = false;

  _FormData(this._account);

  Account get account => _account;

  set account(value) {
    isDirty = true;
    _account = value;
  }

  String get netSalary => _netSalary;

  set netSalary(String value) {
    isDirty = true;
    _netSalary = value;
  }

  String get amount => _amount;

  set amount(value) {
    isDirty = true;
    _amount = value;
  }
}
