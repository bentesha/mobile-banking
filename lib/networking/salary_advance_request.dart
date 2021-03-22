
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:mkombozi_mobile/networking/salary_advance_response.dart';
import 'package:mkombozi_mobile/utils/utils.dart';

class SalaryAdvanceRequest extends NetworkRequest<SalaryAdvanceResponse> {

  SalaryAdvanceRequest({
      @required this.account,
      @required this.user,
      @required this.pin,
      @required this.amount
    });

  final Account account;
  final User user;
  final String pin;
  final double amount;

  @override
  Map<String, dynamic> get params => {
    'institution': account.institutionId,
    'account_number': account.accountNumber,
    'pin': pin,
    'mobile': user.mobile,
    'subscriber': account.subscriberId,
    'source': '1', // SOURCE = MOBILE
    'request_id': Utils.randomId(),
    'amount': amount.toString(),
    'subscriber_company': '',
    'description': 'Salary Advance',
    'retrievalReferenceNumber': Utils.randomId(),
    'consent': '1',
    'requested_service': 'SAL',
    'day_of_the_month': '0',
    'repayment_duration': '0'
  };
  @override
  String get serviceId => '200';

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    final response = data['response'];
    int code = response['code'];
    String message = response['message'];
    final result = SalaryAdvanceResponse(code, message);
    result.description = response['description'];
    return result;
  }

}