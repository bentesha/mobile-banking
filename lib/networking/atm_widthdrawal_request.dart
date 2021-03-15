
import 'package:flutter/cupertino.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/atm_withdrawal_response.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:mkombozi_mobile/utils/utils.dart';

class AtmWithdrawalRequest extends NetworkRequest<AtmWithdrawalResponse> {

  AtmWithdrawalRequest({
    @required this.account,
    @required this.user,
    @required this.pin,
    @required this.recipientMobile,
    @required this.amount
  });

  final Account account;
  final User user;
  final String pin;
  final String recipientMobile;
  final double amount;

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    final Map<String, dynamic> response = data['response'];
    int code = response['code'];
    String message = response['message'];
    final result = AtmWithdrawalResponse(code, message);
    result.description = response['description'];
    return result;
  }

  @override
  Map<String, dynamic> get params => {
    'recipient_number': recipientMobile,
    'institution': account.institutionId,
    'account_number': account.accountNumber,
    'pin': pin,
    'mobile': user.mobile,
    'subscriber': account.subscriberId,
    'source': '1',
    'request_id': Utils.randomId(),
    'amount': amount.toString(),
    'save_payee': '1',
    'reference': '',
    'retrievalReferenceNumber': Utils.randomId()
  };

  @override
  String get serviceId => '102';



}