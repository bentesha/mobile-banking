import 'package:flutter/cupertino.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/fixed_deposit.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:mkombozi_mobile/utils/utils.dart';

class LoanApplicationRequest extends NetworkRequest<NetworkResponse> {
  LoanApplicationRequest(
      {@required this.account,
      this.fixedDeposit,
      @required this.user,
      @required this.amount,
      @required this.description,
      @required this.company,
      @required this.pin,
      @required this.duration});

  final Account account;
  final User user;
  final FixedDeposit fixedDeposit;
  final double amount;
  final String description;
  final String company;
  final String pin;
  final String duration;

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) =>
      NetworkResponse.from(data);

  @override
  Map<String, dynamic> get params {
    final params = {
      'institution': account.institutionId,
      'account_number': account.accountNumber,
      'pin': pin,
      'mobile': user.mobile,
      'subscriber': account.subscriberId,
      'source': '1', // SOURCE = MOBILE
      'request_id': Utils.randomId(),
      'amount': amount.toString(),
      'subscriber_company': '',
      'company': company,
      'description': description,
      'retrievalReferenceNumber': Utils.randomId(),
      'consent': '1',
      'requested_service': '201',
      'day_of_the_month': '0',
      'repayment_duration': duration
    };
    if (fixedDeposit != null) {
      params['receipt_number'] = fixedDeposit.receiptId;
      params['loan_type'] = 'FD';
      params['step'] = '2';
    }
    return params;
  }

  @override
  String get serviceId => '201';
}
