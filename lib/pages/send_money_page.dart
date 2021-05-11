import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/dialogs/message_dialog.dart';
import 'package:mkombozi_mobile/dialogs/pin_code_dialog.dart';
import 'package:mkombozi_mobile/formatters/decimal_input_formatter.dart';
import 'package:mkombozi_mobile/helpers/formatters.dart';
import 'package:mkombozi_mobile/helpers/utils.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/bank.dart';
import 'package:mkombozi_mobile/models/bill_reference_info.dart';
import 'package:mkombozi_mobile/models/branch.dart';
import 'package:mkombozi_mobile/models/wallet_or_bank.dart';
import 'package:mkombozi_mobile/networking/eft_request.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/resolve_bill_number_request.dart';
import 'package:mkombozi_mobile/networking/resolve_bill_number_response.dart';
import 'package:mkombozi_mobile/networking/send_money_request.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:mkombozi_mobile/widgets/account_selector.dart';
import 'package:mkombozi_mobile/widgets/branch_selector_cell.dart';
import 'package:mkombozi_mobile/widgets/form_cell_divider.dart';
import 'package:mkombozi_mobile/widgets/form_cell_input.dart';
import 'package:mkombozi_mobile/widgets/label_value_cell.dart';
import 'package:mkombozi_mobile/widgets/wallet_or_bank_selector.dart';
import 'package:mkombozi_mobile/widgets/workflow.dart';
import 'package:mkombozi_mobile/widgets/workflow_item.dart';
import 'package:mkombozi_mobile/widgets/workflow_progress_indicator.dart';
import 'package:provider/provider.dart';

class SendMoneyPage extends Workflow<_FormData> {
  static void navigateTo(
      BuildContext context, Account account, WalletOrBank walletOrBank) {
    final page = SendMoneyPage(account, walletOrBank);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  final Account account;
  final WalletOrBank walletOrBank;

  SendMoneyPage(this.account, this.walletOrBank)
      : super(
            title: 'Send Money',
            actionLabel: 'SEND MONEY',
            confirmLabel: 'CONFIRM & SEND MONEY');

  @override
  _FormData createWorkflowState() => _FormData(account, walletOrBank);

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
    } else if (_data.walletOrBank == null) {
      message = 'Service is required';
    } else if (_data.referenceNumber == null || _data.referenceNumber.isEmpty) {
      final referenceName = _data.walletOrBank.isWallet ? 'phone' : 'account';
      message = 'Enter $referenceName number';
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
    // We need to update the widget tree if the wallet/bank changes
    final _notifier = ValueNotifier<WalletOrBank>(_data.walletOrBank);
    return ValueListenableBuilder(
        valueListenable: _notifier,
        builder: (context, _, __) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WalletOrBankSelector(
                    label: _data.walletOrBank.isWallet ? 'Wallet' : 'Bank',
                    icon: Icon(_data.walletOrBank.isWallet
                        ? Icons.account_balance_wallet_outlined
                        : Icons.account_balance_sharp),
                    walletOrBank: _data.walletOrBank,
                    onChanged: (value) {
                      _data.walletOrBank = value;
                      // If bank/wallet changes, clear reference number
                      if (_notifier.value.bin != value.bin) {
                        _data.referenceNumber = '';
                      }
                      _notifier.value = value;
                    }),
                FormCellDivider(height: 32),
                AccountSelector(
                  label: 'Pay from account',
                  value: _data.account,
                  onChanged: (value) => _data.account = value,
                ),
                FormCellDivider(),
                FormCellInput(
                    onChanged: (value) => _data.referenceNumber = value,
                    label: _data.walletOrBank.isWallet
                        ? 'Phone Number'
                        : 'Account Number',
                    hintText: 'Enter ' +
                        (_data._walletOrBank.isWallet
                            ? 'phone number'
                            : 'account number'),
                    initialValue: _data.referenceNumber,
                    icon: Icon(Icons.money)),
                FormCellDivider(),
                FormCellInput(
                  label: 'Amount',
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
                  label: 'Reference',
                  initialValue: _data.reference,
                  onChanged: (value) => _data.reference = value,
                  hintText: 'For your reference',
                  icon: Icon(Icons.notes),
                )
              ],
            ));
  }
}

class _StepTwo extends WorkflowItem {
  final _FormData _data;

  _StepTwo(this._data);

  @override
  Future<bool> complete(context) async {
    final pin = await PinCodeDialog.show(context);
    print('PIN $pin');
    if (pin == null) {
      return false;
    }
    final user = Provider.of<LoginService>(context, listen: false);
    final request = _data.walletOrBank is Bank 
        ? EFTRequest()
        : SendMoneyRequest();
    request.walletOrBank = _data.walletOrBank;
    request.account = _data._account;
    request.pin = pin;
    request.user = user.currentUser;
    request.referenceNumber = _data.referenceNumber;
    request.amount = Utils.stringToDouble(_data.amount);
    request.reference = _data._referenceNumber;

    final response = await request.send();
    if (response.code == 200) {
      final title = 'Money Sent';
      final message =
          '${Utils.stringToDouble(_data.amount)} was sent to ${_data.referenceNumber}';
      await MessageDialog.show(
          context: context, message: message, title: title);
      return true;
    }

    await MessageDialog.show(
        context: context,
        message: response.description,
        title: response.message);
    return false;
  }

  Future<void> _resolveName() async {
    if (!_data.walletOrBank.isWallet &&
      _data.walletOrBank.bin != NetworkRequest.INSTITUTION_BIN) {
        return null;
    } 

    final request = ResolveBillNumberRequest(
      account: _data.account,
      reference: _data.referenceNumber,
      mti: _data.walletOrBank.isWallet
        ? _data.walletOrBank.bin
        : NetworkRequest.INSTITUTION_BIN,
      isWallet: _data.walletOrBank.isWallet
    );
    final response = await request.send();
    _data.info = response.info;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _resolveName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return WorkflowProgressIndicator(
            'Checking number..'
          );
        }

        if (snapshot.connectionState == ConnectionState.done || snapshot.hasError) {
          return _buildContent(context);
        }

        return Container();
      }
    );
  }

  Widget _buildContent(BuildContext context) {
    final shouldResolveAgent = 
      _data.walletOrBank.bin == NetworkRequest.INSTITUTION_BIN
        || _data.walletOrBank.isWallet;
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
        Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelValueCell(
                          label: 'Send to', value: _data.walletOrBank.name),
                      LabelValueCell(
                          label: _data.walletOrBank.isWallet
                              ? 'Phone number'
                              : 'Account number',
                          value: _data.referenceNumber),
                      shouldResolveAgent
                      ? LabelValueCell(
                        label: _data.walletOrBank.isWallet ? 'Name' : 'Account Name',
                        value: _data?.info?.resolvedName ?? 'Name not found'
                      )
                      : SizedBox(height: 0),
                      LabelValueCell(
                          label: 'Pay from', value: _data.account.maskedNumber),
                      LabelValueCell(label: 'Amount', value: _data.amount),
                      LabelValueCell(
                          label: 'Reference', value: _data.reference),
                      shouldResolveAgent
                      ? LabelValueCell(
                        label: 'Charge',
                        value: Formatter.formatCurrency(_data?.info?.amount ?? 0)
                      )
                      : SizedBox(height: 0)
                    ])))
      ],
    );
  }

  @override
  String get title => 'Confirm';
}

class _ResolvableLabelValueCell extends StatelessWidget {

  _ResolvableLabelValueCell({
    @required this.label,
    @required this.account,
    @required this.reference,
    @required this.mti,
  });

  final String label;
  final Account account;
  final String reference;
  final String mti;
  
  Future<String> _resolveName() async {
    final request = ResolveBillNumberRequest(
      account: account,
      reference: reference,
      mti: mti
    );
    final response = await request.send();
    return response?.info?.resolvedName;
  }

  build(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label ?? '',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: Colors.grey.shade600
            )
          ),
          SizedBox(width: 32),
          Flexible(
            child: FutureBuilder<String>(
              future: _resolveName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2,)
                      ),
                      SizedBox(width: 8),
                      Text('Checking name..', style: TextStyle(fontStyle: FontStyle.italic))
                    ]
                  );
                }

                if (snapshot.hasError || snapshot.data == null) {
                  return Text('Name not found!',
                    style: TextStyle(
                      color: Colors.red,
                      fontStyle: FontStyle.italic
                    )
                  );
                }

                return Text(snapshot.data ?? '',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                  overflow: TextOverflow.visible,
                );
              }
            )
          )
        ],
      )
    );
  }

}

class _FormData {
  WalletOrBank _walletOrBank;
  Branch _branch;
  Account _account;
  String _amount;
  String _referenceNumber;
  String _reference;
  bool isDirty = false;
  BillReferenceInfo info;

  _FormData(this._account, this._walletOrBank);

  WalletOrBank get walletOrBank => _walletOrBank;

  set walletOrBank(value) {
    isDirty = true;
    _walletOrBank = value;
  }

  Branch get branch => _branch;

  set branch (Branch value) {
    isDirty = true;
    _branch = value;
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

  String get reference => _reference;

  set reference(value) {
    isDirty = true;
    _reference = value;
  }
}
