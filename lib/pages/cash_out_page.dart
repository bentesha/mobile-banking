
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/wallet_or_bank.dart';
import 'package:mkombozi_mobile/pages/select_cash_out_method.dart';
import 'package:mkombozi_mobile/widgets/account_selector.dart';
import 'package:mkombozi_mobile/widgets/cash_out_method_selector.dart';
import 'package:mkombozi_mobile/widgets/form_cell_divider.dart';
import 'package:mkombozi_mobile/widgets/form_cell_input.dart';
import 'package:mkombozi_mobile/widgets/label_value_cell.dart';
import 'package:mkombozi_mobile/widgets/wallet_or_bank_selector.dart';
import 'package:mkombozi_mobile/widgets/workflow.dart';
import 'package:mkombozi_mobile/widgets/workflow_item.dart';

class CashOutPage extends Workflow<_FormData> {
  static void navigateTo(
      BuildContext context, Account account, CashOutMethod method) {
    final page = CashOutPage(account, method);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  final Account account;
  final CashOutMethod method;

  CashOutPage(this.account, this.method)
      : super(
      title: 'Cash Out',
      actionLabel: 'CASH OUT',
      confirmLabel: 'CONFIRM & CASH OUT');

  @override
  _FormData createWorkflowState() => _FormData(account, method);

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
    } else if (_data._method == null) {
      message = 'Select cash out method';
    } else if (_data._amount == null || _data.amount.isEmpty) {
      message = 'Enter amount';
    } else if (_data._reference == null || _data.reference.isEmpty) {
      message = 'Enter phone number';
    }

    if (message != null) {
      MessageDialog.show(context, message);
    }

    return message == null;
  }

  @override
  Widget build(BuildContext context) {
    // We need to update the widget tree if the wallet/bank changes
    final _notifier = ValueNotifier<CashOutMethod>(_data.method);
    return ValueListenableBuilder(
        valueListenable: _notifier,
        builder: (context, _, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CashOutMethodSelector(
                label: 'Cash out option',
                icon: SvgPicture.asset('assets/cash-out.svg',
                  height: 24,
                  width: 24,
                  color: Theme.of(context).iconTheme.color
                ),
                method: _data.method,
                onChanged: (value) {
                  _data.method = value;
                  _notifier.value = value;
                }
            ),
            FormCellDivider(height: 32),
            AccountSelector(
              label: 'Account',
              value: _data.account,
              onChanged: (value) => _data.account = value,
            ),
            FormCellDivider(),
            FormCellInput(
                onChanged: (value) => _data.reference = value,
                label: 'Pay to',
                hintText: 'Enter phone number',
                initialValue: _data.reference,
                icon: Icon(Icons.money)),
            FormCellDivider(),
            FormCellInput(
              label: 'Amount',
              initialValue: _data.amount?.toString(),
              onChanged: (value) => _data.amount = value,
              hintText: 'Enter amount e.g 20,000',
              inputType: TextInputType.number,
              textAlign: TextAlign.right,
              icon: Icon(Icons.attach_money),
            ),
            FormCellDivider(),
            FormCellInput(
              label: 'Reference',
              initialValue: _data.notes,
              onChanged: (value) => _data.notes = value,
              hintText: 'For your reference',
              icon: Icon(Icons.notes),
            )
          ],
        )
    );
  }
}

class _StepTwo extends WorkflowItem {
  final _FormData _data;

  _StepTwo(this._data);

  @override
  void complete(context) {
    print('On complete: Step 2');
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
                          label: 'Cash Out Option', value: _data.method == CashOutMethod.atm ? 'ATM' : 'Agent'),
                      LabelValueCell(
                          label: 'Account', value: _data.account.maskedNumber),
                      LabelValueCell(
                          label: 'Paid To', value: _data.reference),
                      LabelValueCell(label: 'Amount', value: _data.amount),
                      LabelValueCell(label: 'Reference', value: _data.notes),
                      LabelValueCell(label: 'Charges', value: '1,200.00')
                    ])))
      ],
    );
  }

  @override
  String get title => 'Confirm';
}

class _FormData {
  CashOutMethod _method;
  Account _account;
  String _amount;
  String _reference;
  String _notes;
  bool isDirty = false;

  _FormData(this._account, this._method);

  CashOutMethod get method => _method;

  set method(CashOutMethod value) {
    isDirty = true;
    _method = value;
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

  String get reference => _reference;

  set reference(value) {
    isDirty = true;
    _reference = value;
  }

  String get notes => _notes;

  set notes(value) {
    isDirty = true;
    _notes = value;
  }
}
