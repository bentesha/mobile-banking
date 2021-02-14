import 'package:flutter/cupertino.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:shortid/shortid.dart';

class LoanApplicationRequest extends NetworkRequest<NetworkResponse> {
  LoanApplicationRequest(
      {@required this.account,
      @required this.user,
      @required this.netSalary,
      @required this.amount,
      @required this.description,
      @required this.company,
      @required this.pin,
      @required this.duration});

  final Account account;
  final User user;
  final double netSalary;
  final double amount;
  final String description;
  final String company;
  final String pin;
  final String duration;

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) =>
      NetworkResponse.from(data);

  @override
  // TODO: implement params
  Map<String, dynamic> get params => {
        'institution': account.institutionId,
        'account_number': account.accountNumber,
        'pin': pin,
        'mobile': user.mobile,
        'subscriber': account.subscriberId,
        'source': '1', // SOURCE = MOBILE
        'request_id': shortid.generate(),
        'net_salary': netSalary.toString(),
        'amount': amount.toString(),
        'subscriber_company': '',
        'company': company,
        'description': description,
        'retrievalReferenceNumber': shortid.generate(),
        'consent': '1',
        'requested_service': '201',
        'day_of_the_month': '0',
        'repayment_duration': duration
      };

  @override
  String get serviceId => '201';
}
