import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/dialogs/pin_code_dialog.dart';
import 'package:mkombozi_mobile/formatters/decimal_input_formatter.dart';
import 'package:mkombozi_mobile/helpers/utils.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/networking/loan_application_request.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/widgets/form_cell_divider.dart';
import 'package:mkombozi_mobile/widgets/form_cell_dropdown.dart';
import 'package:mkombozi_mobile/widgets/form_cell_input.dart';
import 'package:mkombozi_mobile/widgets/label_value_cell.dart';
import 'package:mkombozi_mobile/widgets/workflow.dart';
import 'package:mkombozi_mobile/widgets/workflow_item.dart';
import 'package:provider/provider.dart';

class LoanApplicationPage extends Workflow<_FormData> {
  static void navigateTo(BuildContext context, Account account) {
    final page = LoanApplicationPage(account);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  final Account account;

  LoanApplicationPage(this.account)
      : super(
            title: 'Loan Application',
            actionLabel: 'REQUEST LOAN',
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

    if (_data.netSalary == null || _data.netSalary.isEmpty) {
      message = 'Net salary is required';
    } else if (_data.description == null || _data.description.isEmpty) {
      message = 'Enter description';
    } else if (_data.company == null || _data.company.isEmpty) {
      message = 'Company is required';
    } else if (_data.amount == null || _data.amount.isEmpty) {
      message = 'Enter loan requested amount';
    } else if (_data.duration == null || _data.duration.isEmpty) {
      message = 'Select loan duration';
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
        FormCellInput(
            onChanged: (value) => _data.netSalary = value,
            label: 'Net Salary',
            inputFormatters: [DecimalInputFormatter()],
            hintText: 'Your net salary',
            inputType: TextInputType.number,
            textAlign: TextAlign.right,
            initialValue: _data.netSalary,
            icon: Icon(Icons.attach_money)),
        FormCellDivider(),
        FormCellInput(
            onChanged: (value) => _data.description = value,
            label: 'Description',
            hintText: 'Load description',
            initialValue: _data.description,
            icon: Icon(Icons.attach_money)),
        FormCellDivider(),
        FormCellInput(
            onChanged: (value) => _data.company = value,
            label: 'Company',
            hintText: 'Your company name',
            initialValue: _data.company,
            icon: Icon(Icons.attach_money)),
        FormCellDivider(),
        FormCellInput(
            onChanged: (value) => _data.amount = value,
            label: 'Request Amount',
            inputFormatters: [DecimalInputFormatter()],
            hintText: 'Loan requested amount',
            inputType: TextInputType.number,
            textAlign: TextAlign.right,
            initialValue: _data.amount,
            icon: Icon(Icons.attach_money)),
        FormCellDivider(),
        FormCellDropDown(
            onChanged: (value) => _data.duration = value,
            value: _data.duration,
            label: 'Requested Duration (month)',
            options: List.generate(36, (index) => (index + 1).toString()),
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
    final request = LoanApplicationRequest(
        account: _data.account,
        user: user,
        pin: pin,
        netSalary: Utils.stringToDouble(_data.netSalary),
        amount: Utils.stringToDouble(_data.amount),
        description: _data.description,
        company: _data.company,
        duration: _data.duration);

    final response = await request.send();
    if (response.code == 200) {
      await MessageDialog.show(
          context: context, message: 'Your loan application has been submitted', title: 'Success');
      return true;
    }

    await MessageDialog.show(context: context, message: response.description, title: response.message);
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
                          label: 'Net Salary', value: _data.netSalary),
                      LabelValueCell(
                          label: 'Description', value: _data.description),
                      LabelValueCell(label: 'Company', value: _data.company),
                      LabelValueCell(
                          label: 'Amount Requested', value: _data.amount),
                      LabelValueCell(
                          label: 'Repayment Period', value: _data.duration)
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
  String _description;
  String _company;
  String _duration;
  bool isDirty = false;

  _FormData(this._account);

  Account get account => _account;

  String get description => _description;

  set description(String value) {
    isDirty = true;
    _description = value;
  }

  String get company => _company;

  set company(String value) {
    isDirty = true;
    _company = value;
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

  String get duration => _duration;

  set duration(String value) {
    isDirty = true;
    _duration = value;
  }
}
