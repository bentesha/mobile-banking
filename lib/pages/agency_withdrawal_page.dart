import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/dialogs/pin_code_dialog.dart';
import 'package:mkombozi_mobile/formatters/decimal_input_formatter.dart';
import 'package:mkombozi_mobile/formatters/number_input_formatter.dart';
import 'package:mkombozi_mobile/helpers/utils.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/agent.dart';
import 'package:mkombozi_mobile/networking/agency_withdrawal_request.dart';
import 'package:mkombozi_mobile/networking/resolve_agent_request.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/widgets/account_selector.dart';
import 'package:mkombozi_mobile/widgets/form_cell_divider.dart';
import 'package:mkombozi_mobile/widgets/form_cell_input.dart';
import 'package:mkombozi_mobile/widgets/label_value_cell.dart';
import 'package:mkombozi_mobile/widgets/workflow.dart';
import 'package:mkombozi_mobile/widgets/workflow_item.dart';
import 'package:provider/provider.dart';

class AgencyWithdrawalPage extends Workflow<_FormData> {
  static void navigateTo(BuildContext context, Account account) {
    final page = AgencyWithdrawalPage(account);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  final Account account;

  AgencyWithdrawalPage(this.account)
      : super(
            title: 'Agency Withdrawal',
            actionLabel: 'WITHDRAW',
            confirmLabel: 'CONFIRM & WITHDRAW');

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
    } else if (_data.agentNumber == null || _data.agentNumber.isEmpty) {
      message = 'Please enter agent number';
    } else if (_data.amount == null || _data.amount.isEmpty) {
      message = 'Enter amount';
    }

    if (message != null) {
      MessageDialog.show(
          context: context, message: message, title: 'Form Error');
    }

    if (message != null) {
      return false;
    }

    // If agent number has not changed, skip resolving agent information
    if (_data.agentNumber == _data.agent?.number) {
      return true;
    }

    final request = ResolveAgentRequest(
        account: _data.account, agentNumber: _data.agentNumber);
    final response = await request.send();
    if (response.agent == null) {
      MessageDialog.show(
          context: context,
          message:
              'Agent with number "${_data.agentNumber}" could not be found.',
          title: 'Agent Not Found');
      return false;
    }
    _data.agent = response.agent;
    return true;
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
            onChanged: (value) => _data.agentNumber = value,
            inputFormatters: [NumberInputFormatter(length: 5)],
            label: 'Agent Number',
            hintText: 'Enter agent number',
            initialValue: _data.agentNumber,
            icon: Icon(Icons.house_siding)),
        FormCellDivider(),
        FormCellInput(
          label: 'Amount',
          inputFormatters: [DecimalInputFormatter()],
          initialValue: _data.amount?.toString(),
          onChanged: (value) => _data.amount = value,
          hintText: 'Enter amount e.g 20,000',
          inputType: TextInputType.number,
          textAlign: TextAlign.right,
          icon: Icon(Icons.attach_money),
        ),
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
    final request = AgencyWithdrawalRequest(
        account: _data.account,
        agent: _data.agent,
        user: loginService.currentUser,
        pin: pin,
        amount: Utils.stringToDouble(_data.amount));
    final response = await request.send();
    if (response.code == 200) {
      await MessageDialog.show(
        context: context,
        message: 'Transaction has been completed successfully',
        title: 'Transaction Complete',
      );
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
                      LabelValueCell(label: 'Amount', value: _data.amount),
                      LabelValueCell(
                          label: 'Agent Number', value: _data.agentNumber),
                      LabelValueCell(
                          label: 'Agent Name', value: _data.agent.name),
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
  String _agentNumber;
  bool isDirty = false;
  Agent agent;

  _FormData(this._account);

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

  String get agentNumber => _agentNumber;

  set agentNumber(String value) {
    isDirty = true;
    _agentNumber = value;
  }
}
