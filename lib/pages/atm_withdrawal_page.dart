import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/dialogs/pin_code_dialog.dart';
import 'package:mkombozi_mobile/formatters/decimal_input_formatter.dart';
import 'package:mkombozi_mobile/formatters/number_input_formatter.dart';
import 'package:mkombozi_mobile/helpers/utils.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/networking/atm_widthdrawal_request.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/widgets/account_selector.dart';
import 'package:mkombozi_mobile/widgets/currency_icon.dart';
import 'package:mkombozi_mobile/widgets/form_cell_divider.dart';
import 'package:mkombozi_mobile/widgets/form_cell_input.dart';
import 'package:mkombozi_mobile/widgets/label_value_cell.dart';
import 'package:mkombozi_mobile/widgets/workflow.dart';
import 'package:mkombozi_mobile/widgets/workflow_item.dart';
import 'package:provider/provider.dart';

class AtmWithdrawalPage extends Workflow<_FormData> {
  static void navigateTo(BuildContext context, Account account) {
    final page = AtmWithdrawalPage(account);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  final Account account;

  AtmWithdrawalPage(this.account)
      : super(
            title: 'Cash Out',
            actionLabel: 'CASH OUT',
            confirmLabel: 'CONFIRM & CASH OUT');

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
    } else if (_data.recipientMobile == null || _data.recipientMobile.isEmpty) {
      message = 'Enter phone number';
    } else if (!Utils.validatePhoneNumber(_data.recipientMobile)) {
      message = 'Enter a valid phone number';
    } else if (_data._amount == null || _data.amount.isEmpty) {
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
            onChanged: (value) => _data.recipientMobile = value,
            inputFormatters: [NumberInputFormatter(length: 12)],
            label: 'Mobile Number',
            hintText: 'Enter phone number',
            inputType: TextInputType.number,
            initialValue: _data.recipientMobile,
            icon: Icon(Icons.money)),
        FormCellDivider(),
        FormCellInput(
          label: 'Amount',
          inputFormatters: [DecimalInputFormatter()],
          initialValue: _data.amount?.toString(),
          onChanged: (value) => _data.amount = value,
          hintText: 'Enter amount e.g 20,000',
          inputType: TextInputType.number,
          textAlign: TextAlign.right,
          icon: CurrencyIcon()
        ),
        FormCellDivider(),
        FormCellInput(
          label: 'Reference',
          initialValue: _data.reference,
          onChanged: (value) => _data.reference = value,
          hintText: 'For your reference',
          icon: Icon(Icons.notes),
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
    final loginService = Provider.of<LoginService>(context, listen: false);
    final request = AtmWithdrawalRequest(
        account: _data.account,
        user: loginService.currentUser,
        pin: pin,
        recipientMobile: _data.recipientMobile,
        amount: Utils.stringToDouble(_data.amount));
    final response = await request.send();
    if (response.code == 200) {
      await MessageDialog.show(
          context: context,
          message: 'Transaction was successfully completed',
          title: 'Transaction Completed');
      return true;
    }

    MessageDialog.show(
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
                          label: 'Mobile Number', value: _data.recipientMobile),
                      LabelValueCell(label: 'Amount', value: _data.amount),
                      LabelValueCell(
                          label: 'Reference', value: _data.reference),
                    ])))
      ],
    );
  }

  @override
  String get title => 'Confirm';
}

class _FormData {
  Account _account;
  String _recipientMobile;
  String _amount;
  String _reference;
  bool isDirty = false;

  _FormData(this._account);

  Account get account => _account;

  set account(value) {
    isDirty = true;
    _account = value;
  }

  String get recipientMobile => _recipientMobile;

  set recipientMobile(String value) {
    isDirty = true;
    _recipientMobile = value;
  }

  String get amount => _amount;

  set amount(value) {
    isDirty = true;
    _amount = value;
  }

  String get reference => _reference;

  set reference(value) {
    isDirty = true;
    _reference = value;
  }
}
