
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/dialogs/pin_code_dialog.dart';
import 'package:mkombozi_mobile/formatters/decimal_input_formatter.dart';
import 'package:mkombozi_mobile/helpers/formatters.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/bill_reference_info.dart';
import 'package:mkombozi_mobile/models/service.dart';
import 'package:mkombozi_mobile/networking/bill_payment_request.dart';
import 'package:mkombozi_mobile/networking/general_payment_request.dart';
import 'package:mkombozi_mobile/networking/resolve_agent_request.dart';
import 'package:mkombozi_mobile/networking/resolve_bill_number_request.dart';
import 'package:mkombozi_mobile/networking/resolve_bill_number_response.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/widgets/account_selector.dart';
import 'package:mkombozi_mobile/widgets/form_cell_divider.dart';
import 'package:mkombozi_mobile/widgets/form_cell_input.dart';
import 'package:mkombozi_mobile/widgets/label_value_cell.dart';
import 'package:mkombozi_mobile/widgets/service_selector.dart';
import 'package:mkombozi_mobile/widgets/workflow.dart';
import 'package:mkombozi_mobile/widgets/workflow_item.dart';
import 'package:provider/provider.dart';

class BillPaymentPage extends Workflow<_FormData> {
  static void navigateTo(
      BuildContext context, Account account, Service service) {
    final page = BillPaymentPage(account, service);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  final Account account;
  final Service service;

  BillPaymentPage(this.account, this.service)
      : super(
            title: 'Pay Bill',
            actionLabel: 'PAY BILL',
            confirmLabel: 'CONFIRM & PAY BILL');

  @override
  _FormData createWorkflowState() => _FormData(service, account);

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

    if (_data.account == null) {
      message = 'Account is required';
    } else if (_data.service == null) {
      message = 'Service is required';
    } else if (_data.referenceNumber == null || _data.referenceNumber.isEmpty) {
      message = 'Enter reference number';
    } else if (_data.amount == null || _data.amount.isEmpty) {
      message = 'Enter amount';
    }

    if (message != null) {
      MessageDialog.showFormError(context: context, message: message);
    }

    if (message != null) {
      return false;
    }

    // Only resolve payment reference for these services
    final shouldResolve = [
      ResolveBillNumberRequest.MTI_GEPG,
      ResolveBillNumberRequest.MTI_LUKU,
      ResolveBillNumberRequest.MTI_PAYMENT_SOLUTION,
      ResolveBillNumberRequest.MTI_AIRTIME
    ].contains(_data.service.mti);

    if (!shouldResolve) {
      return true;
    }

    final referenceInfo = await _resolveReference(context);
    _data.referenceInfo = referenceInfo;
    return referenceInfo != null || _data.service.mti != ResolveBillNumberRequest.MTI_GEPG;
  }

  Future<BillReferenceInfo> _resolveReference(BuildContext context) {
    final request = ResolveBillNumberRequest(
      reference: _data.referenceNumber,
      account: _data.account,
      mti: _data.service.mti
    );
    BillReferenceInfo info;
    return showDialog<BillReferenceInfo>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Payment Details'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(info),
            child: Text('OK')
          )
        ],
        content: FutureBuilder<ResolveBillNumberResponse>(
          future: request.send(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                padding: EdgeInsets.only(top: 40),
                height: 100,
                child: Center(
                  child: CircularProgressIndicator()
                )
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                height: 100,
                child: Text('Could not resolve number')
              );
            }

            final response = snapshot.data;
            if (response.code != 200) {
              return SizedBox(
                height: 100,
                child: Text('Reference number not found!')
              );
            }

            info = response.info;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Name'),
                  subtitle: Text(info.resolvedName), 
                ),
                ListTile(
                  title: Text('Institution'),
                  subtitle: Text(info.institutionName)
                ),
                ListTile(
                  title: Text('Amount'),
                  subtitle: Text(info.amount)
                )
              ],
            );
          }
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ServiceSelector(
            label: 'Send payment to',
            icon: Icon(Icons.account_balance_wallet_outlined),
            service: _data.service,
            onChanged: (value) => _data.service = value),
        FormCellDivider(height: 32),
        AccountSelector(
          label: 'Pay from account',
          value: _data.account,
          onChanged: (value) {
            _data.account = value;
            Workflow.of(context).updateState();
          },
        ),
        FormCellDivider(),
        FormCellInput(
            onChanged: (value) => _data.referenceNumber = value,
            label: 'Reference Number',
            hintText: 'Enter reference number',
            initialValue: _data.referenceNumber,
            icon: Icon(Icons.money)),
        FormCellDivider(),
        FormCellInput(
          label: 'Amount to pay',
          inputFormatters: [DecimalInputFormatter()],
          initialValue: _data.amount?.toString(),
          onChanged: (value) => _data.amount = value,
          hintText: 'Enter amount to send. e.g 20,000',
          inputType: TextInputType.number,
          textAlign: TextAlign.right,
          icon: Icon(Icons.attach_money),
        ),
        FormCellDivider(),
        FormCellInput(
          label: 'Description',
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
    final request = _data.referenceNumber != null
      ? GeneralPaymentRequest()
      : BillPaymentRequest();
    if (request is GeneralPaymentRequest) {
      request.destinationTransactinId =_data.referenceInfo.destinationTransactionId;
    }
    request.account = _data.account;
    request.service = _data.service;
    request.pin = pin;
    request.user = loginService.currentUser;
    request.referenceNumber = _data.referenceNumber;

    if (request is GeneralPaymentRequest) {
      request.destinationTransactinId = _data.referenceInfo.destinationTransactionId;
    }

    request.amount = double.parse(_data._amount.replaceAll(',', ''));
    request.reference = _data.reference;

    final response = await request.send();
    if (response.code == 200) {
      await MessageDialog.show(
          context: context, message: response.description, title: response.message);
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
                      _data.referenceInfo != null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LabelValueCell(
                              label: 'Name',
                              value: _data.referenceInfo.resolvedName
                            ),
                            LabelValueCell(
                              label: 'Institution',
                              value: _data.referenceInfo.institutionName
                            )]
                      )
                      : LabelValueCell(
                          label: 'Send to', value: _data.service.name),
                      LabelValueCell(
                          label: 'Pay from', value: _data.account.maskedNumber),
                      LabelValueCell(
                          label: 'Reference number',
                          value: _data.referenceNumber),
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
  Service _service;
  Account _account;
  String _amount;
  String _referenceNumber;
  String _reference;
  BillReferenceInfo _referenceInfo;
  bool isDirty = false;

  _FormData(this._service, this._account);

  Service get service => _service;

  set service(value) {
    isDirty = true;
    _service = value;
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

  String get referenceNumber => _referenceNumber;

  set referenceNumber(value) {
    isDirty = true;
    _referenceNumber = value;
  }

  BillReferenceInfo get referenceInfo => _referenceInfo;

  set referenceInfo(BillReferenceInfo value) {
    isDirty = true;
    _referenceInfo = value;
  }

  String get reference => _reference;

  set reference(value) {
    isDirty = true;
    _reference = value;
  }
}
