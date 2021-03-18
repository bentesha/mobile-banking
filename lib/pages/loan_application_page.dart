
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/dialogs/pin_code_dialog.dart';
import 'package:mkombozi_mobile/formatters/decimal_input_formatter.dart';
import 'package:mkombozi_mobile/helpers/utils.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/fixed_deposit.dart';
import 'package:mkombozi_mobile/networking/loan_application_request.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/widgets/account_selector.dart';
import 'package:mkombozi_mobile/widgets/fixed_deposit_selector.dart';
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
    print('isFixedDeposit ${_data.isFixedDeposit}');
    print('fixedDeposit: ${_data.fixedDeposit != null}');
    String message;
    if (_data.isFixedDeposit && _data.fixedDeposit == null) {
      message = 'Select fixed deposit';
    } else if (_data.netSalary == null || _data.netSalary.isEmpty) {
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
        AccountSelector(
          label: 'Account',
          value: _data.account,
          onChanged: (value) {
            if (_data.account != value) {
              _data.fixedDeposit = null;
              _data.account = value;
              Workflow.of(context).updateState();
            }
          },
        ),
        FormCellDivider(),
        FormCellDropDown(
          label: 'Loan Type',
          options: ['Normal Loan', 'Fixed Deposit'],
          value: _data.isFixedDeposit ? 'Fixed Deposit' : 'Normal Loan',
          onChanged: (value) {
            _data.isFixedDeposit = value == 'Fixed Deposit';
            if (!_data.isFixedDeposit) {
              _data.fixedDeposit = null;
            }
            Workflow.of(context).updateState();
          },
        ),
        FormCellDivider(),
        _data.isFixedDeposit
          ? Column(
            children: [
              FixedDepositSelector(
                label: 'Fixed Deposit',
                accountNumber: _data.account.accountNumber,
                value: _data.fixedDeposit,
                onChanged: (value) => _data.fixedDeposit = value,
              ),
              FormCellDivider()]
          )
          : SizedBox(height: 0, width: 0),
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
            hintText: 'Loan description',
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
        fixedDeposit: _data.fixedDeposit,
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
                          label: 'Account', value: _data.account.maskedNumber),
                      LabelValueCell(
                          label: 'Net Salary', value: _data.netSalary),
                      LabelValueCell(
                          label: 'Loan Type', value: _data.isFixedDeposit ? 'Fixed Deposit' : 'Normal Loan'),
                      _data.isFixedDeposit
                        ? LabelValueCell(
                          label: 'Fixed Deposit', value: _data.fixedDeposit.toString())
                        : SizedBox(height: 0, width: 0),
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
  bool _isFixedDeposit = false;
  FixedDeposit _fixedDeposit;
  String _duration;
  bool isDirty = false;

  _FormData(this._account);

  Account get account => _account;

  set account(Account value) {
    _account = value;
    isDirty = true;
  }

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

  bool get isFixedDeposit => _isFixedDeposit;

  set isFixedDeposit(bool value) {
    isDirty = true;
    _isFixedDeposit = value;
  }

  FixedDeposit get fixedDeposit => _fixedDeposit;

  set fixedDeposit(FixedDeposit value) {
    isDirty = true;
    _fixedDeposit = value;
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
