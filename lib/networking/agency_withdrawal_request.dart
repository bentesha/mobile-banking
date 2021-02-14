
import 'package:flutter/cupertino.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/agent.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/agency_withdrawal_response.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:shortid/shortid.dart';

class AgencyWithdrawalRequest extends NetworkRequest<AgencyWithdrawalResponse> {

  AgencyWithdrawalRequest({
    @required this.account,
    @required this.agent,
    @required this.user,
    @required this.pin,
    @required this.amount
  });

  final Agent agent;
  final Account account;
  final String pin;
  final User user;
  final double amount;


  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    final Map<String, dynamic> response = data['response'];
    int code = response['code'];
    String message = response['message'];
    final result = AgencyWithdrawalResponse(code, message);
    result.description = response['description'];
    return result;
  }

  @override
  Map<String, dynamic> get params => {
    'agent_id': agent.account,
    'account_number': account.accountNumber,
    'pin': pin,
    'institution': account.institutionId,
    'mobile': user.mobile,
    'subscriber': account.subscriberId,
    'source': '1',
    'request_id': shortid.generate(),
    'amount': amount.toString(),
    'save_payee': '1',
    'agent_account_number': agent.account,
    'retrievalReferenceNumber': shortid.generate(),
    'reference': ''
  };

  @override
  String get serviceId => '108';
}