import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/dialogs/pin_code_dialog.dart';
import 'package:mkombozi_mobile/formatters/decimal_input_formatter.dart';
import 'package:mkombozi_mobile/formatters/number_input_formatter.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/bank.dart';
import 'package:mkombozi_mobile/models/branch.dart';
import 'package:mkombozi_mobile/networking/standing_order_request.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/widgets/account_selector.dart';
import 'package:mkombozi_mobile/widgets/branch_selector_cell.dart';
import 'package:mkombozi_mobile/widgets/form_cell_date.dart';
import 'package:mkombozi_mobile/widgets/form_cell_divider.dart';
import 'package:mkombozi_mobile/widgets/form_cell_dropdown.dart';
import 'package:mkombozi_mobile/widgets/form_cell_input.dart';
import 'package:mkombozi_mobile/widgets/label_value_cell.dart';
import 'package:mkombozi_mobile/widgets/wallet_or_bank_selector.dart';
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
    } else if (_data.bank == null) {
      message = 'Select destination bank';
    } else if (_data.branch == null) {
      message = 'Select destination branch';
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
          onChanged: (value) {
            _data.account = value;
            Workflow.of(context).updateState();
          },
        ),
        FormCellDivider(),
        WalletOrBankSelector(
          label: 'To bank',
          icon: Icon(Icons.account_balance_sharp),
          bankOnly: true,
          walletOrBank: _data.bank,
          onChanged: (value) {
            _data.bank = value as Bank;
            Workflow.of(context).updateState();
          }
        ),
        FormCellDivider(),
        BranchSelectorCell(
          label: 'Branch',
          value: _data.branch,
          hintText: 'Select branch',
          icon: Icon(Icons.house_siding),
          account: _data.account,
          bank: _data.bank,
          onChanged: (value) {
            _data.branch = value;
            Workflow.of(context).updateState();
          }
        ),
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
            onChanged: (value) => _data.amount = value,
            label: 'Amount',
            inputFormatters: [DecimalInputFormatter()],
            hintText: 'Standing order amount',
            inputType: TextInputType.number,
            textAlign: TextAlign.right,
            initialValue: _data.amount,
            icon: Icon(Icons.attach_money)),
        FormCellDivider(),
        FormCellDropDown(
          label: 'Frequency',
          options: ['D', 'M', 'Y'],
          icon: Icon(Icons.refresh),
          value: _data.frequency,
          onChanged: (value) => _data.frequency = value,
        ),
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
        frequency: _data.frequency,
        noOfExecutions: int.parse(_data.numberOfExecutions),
        amount: double.parse(_data.amount.replaceAll(',', '')),
        recipientAccount: _data.accountNumber,
        bank: _data.bank,
        branch: _data.branch);
    final response = await request.send();
    if (response.code == 200) {
      await MessageDialog.show(
          context: context,
          message: response.description,
          title: response.message);
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
                      LabelValueCell(
                          label: 'To Bank',
                          value: _data.bank.name),
                      LabelValueCell(
                          label: 'Branch',
                          value: _data.branch.name),
                      LabelValueCell(
                          label: 'Account Number', value: _data.accountNumber),
                      LabelValueCell(label: 'Amount', value: _data.amount),
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
  Bank _bank;
  Branch _branch;
  String _accountNumber;
  String _numberOfExecutions;
  DateTime _startDate;
  String _dayOfMonth;
  String _amount;
  String _frequency = 'M';
  bool isDirty = false;

  _FormData(this._account);

  String get accountNumber => _accountNumber;

  set accountNumber(String value) {
    isDirty = true;
    _accountNumber = value;
  }

  Bank get bank => _bank;

  set bank(Bank value) {
    _bank = value;
    isDirty = true;
  }

  Branch get branch => _branch;

  set branch(Branch value) {
    _branch = value;
    isDirty = true;
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

  String get frequency => _frequency;

  set frequency(String value) {
    isDirty = true;
    _frequency = value;
  }

  String get numberOfExecutions => _numberOfExecutions;

  set numberOfExecutions(String value) {
    isDirty = true;
    _numberOfExecutions = value;
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
