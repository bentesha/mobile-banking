import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/dialogs/pin_code_dialog.dart';
import 'package:mkombozi_mobile/formatters/decimal_input_formatter.dart';
import 'package:mkombozi_mobile/formatters/number_input_formatter.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/networking/standing_order_request.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/widgets/account_selector.dart';
import 'package:mkombozi_mobile/widgets/form_cell_date.dart';
import 'package:mkombozi_mobile/widgets/form_cell_divider.dart';
import 'package:mkombozi_mobile/widgets/form_cell_dropdown.dart';
import 'package:mkombozi_mobile/widgets/form_cell_input.dart';
import 'package:mkombozi_mobile/widgets/label_value_cell.dart';
import 'package:mkombozi_mobile/widgets/workflow.dart';
import 'package:mkombozi_mobile/widgets/workflow_item.dart';
import 'package:provider/provider.dart';

class StandingOrderPage extends Workflow<_FormData> {
  static void navigateTo(BuildContext context, Account account) {
    final page = StandingOrderPage(account);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  final Account account;

  StandingOrderPage(this.account)
      : super(
            title: 'Standing Order',
            actionLabel: 'SET ORDER',
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
    } else if (_data._amount == null || _data.amount.isEmpty) {
      message = 'Enter amount';
    } else if (_data.accountNumber == null || _data.accountNumber.isEmpty) {
      message = 'Enter account number';
    } else if (_data.institutionName == null || _data.institutionName.isEmpty) {
      message = 'Enter institution name';
    } else if (_data.institutionCode == null || _data.institutionCode.isEmpty) {
      message = 'Enter institution code';
    } else if (_data.numberOfExecutions == null ||
        _data.numberOfExecutions.isEmpty) {
      message = 'Enter number of executions';
    } else if (_data.startDate == null) {
      message = 'Enter start date';
    } else if (_data.dayOfMonth == null || _data.dayOfMonth.isEmpty) {
      message = 'Enter day of month';
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
            onChanged: (value) => _data.amount = value,
            label: 'Amount',
            inputFormatters: [DecimalInputFormatter()],
            hintText: 'Standing order amount',
            inputType: TextInputType.number,
            textAlign: TextAlign.right,
            initialValue: _data.amount,
            icon: Icon(Icons.attach_money)),
        FormCellDivider(),
        FormCellInput(
          label: 'Account Number',
          initialValue: _data.accountNumber,
          onChanged: (value) => _data.accountNumber = value,
          hintText: 'Recipient account number',
          icon: Icon(Icons.money),
        ),
        FormCellDivider(),
        FormCellInput(
          label: 'Institution Name',
          initialValue: _data.institutionName,
          onChanged: (value) => _data.institutionName = value,
          hintText: 'Name of receiving institution',
          icon: Icon(Icons.account_balance_sharp),
        ),
        FormCellDivider(),
        FormCellInput(
            label: 'Institution Code',
            hintText: 'Code of the receiving institution',
            initialValue: _data.institutionCode,
            onChanged: (value) => _data.institutionCode = value,
            icon: Icon(Icons.tag)),
        FormCellDivider(),
        FormCellInput(
          label: 'Number of Executions',
          inputFormatters: [NumberInputFormatter()],
          hintText: 'Number of standing order executions',
          initialValue: _data.numberOfExecutions,
          onChanged: (value) => _data.numberOfExecutions = value,
          icon: Icon(Icons.repeat),
          inputType: TextInputType.number,
        ),
        FormCellDivider(),
        FormCellDate(
            label: 'Start Date',
            hintText: 'Standing order start date',
            date: _data.startDate,
            onChanged: (value) => _data.startDate = value,
            icon: Icon(Icons.date_range)),
        FormCellDivider(),
        FormCellDropDown(
          label: 'Day of Month',
          value: _data.dayOfMonth,
          options: List.generate(31, (index) => (index + 1).toString()),
          icon: Icon(Icons.date_range),
          onChanged: (value) => _data.dayOfMonth = value,
        )
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
    final request = StandingOrderRequest(
        account: _data.account,
        user: user,
        pin: pin,
        dayOfMonth: _data.dayOfMonth,
        firstExecutionDate: _data.startDate,
        noOfExecutions: int.parse(_data.numberOfExecutions),
        amount: double.parse(_data.amount),
        recipientAccount: _data.accountNumber,
        institutionName: _data.institutionName,
        institutionCode: _data.institutionCode);
    final response = await request.send();
    if (response.code == 200) {
      await MessageDialog.show(
          context: context,
          message: 'Standing order was successfully set',
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
                          label: 'Pay from', value: _data.account.maskedNumber),
                      LabelValueCell(label: 'Amount', value: _data.amount),
                      LabelValueCell(
                          label: 'Account Number', value: _data.accountNumber),
                      LabelValueCell(
                          label: 'Institution Name',
                          value: _data.institutionName),
                      LabelValueCell(
                          label: 'Institution Code',
                          value: _data.institutionCode),
                      LabelValueCell(
                          label: 'Number of executions',
                          value: _data.numberOfExecutions),
                      LabelValueCell(
                          label: 'Start date',
                          value: DateFormat.yMMMd().format(_data.startDate)),
                      LabelValueCell(
                          label: 'Day of month', value: _data.dayOfMonth)
                    ])))
      ],
    );
  }

  @override
  String get title => 'Confirm';
}

class _FormData {
  Account _account;
  String _accountNumber;
  String _institutionName;
  String _institutionCode;
  String _numberOfExecutions;
  DateTime _startDate;
  String _dayOfMonth;
  String _amount;
  bool isDirty = false;

  _FormData(this._account);

  String get accountNumber => _accountNumber;

  set accountNumber(String value) {
    isDirty = true;
    _accountNumber = value;
  }

  String get dayOfMonth => _dayOfMonth;

  set dayOfMonth(String value) {
    isDirty = true;
    _dayOfMonth = value;
  }

  DateTime get startDate => _startDate;

  set startDate(DateTime value) {
    isDirty = true;
    _startDate = value;
  }

  String get numberOfExecutions => _numberOfExecutions;

  set numberOfExecutions(String value) {
    isDirty = true;
    _numberOfExecutions = value;
  }

  String get institutionCode => _institutionCode;

  set institutionCode(String value) {
    isDirty = true;
    _institutionCode = value;
  }

  String get institutionName => _institutionName;

  set institutionName(String value) {
    isDirty = true;
    _institutionName = value;
  }

  Account get account => _account;

  set account(value) {
    isDirty = true;
    _account = value;
  }

  String get amount => _amount;

  set amount(value) {
    isDirty = true;
    _amount = value;
  }
}
