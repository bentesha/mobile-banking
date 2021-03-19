
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/bank.dart';
import 'package:mkombozi_mobile/models/branch.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:mkombozi_mobile/networking/standing_order_response.dart';
import 'package:mkombozi_mobile/utils/utils.dart';

class StandingOrderRequest extends NetworkRequest<StandingOrderResponse> {

  StandingOrderRequest({
    @required this.account,
    @required this.bank,
    @required this.branch,
    @required this.user,
    @required this.pin,
    @required this.dayOfMonth,
    @required this.firstExecutionDate,
    @required this.noOfExecutions,
    @required this.amount,
    @required this.recipientAccount
  });
  
  final Account account;
  final Bank bank;
  final Branch branch;
  final User user;
  final String pin;
  final String dayOfMonth;
  final DateTime firstExecutionDate;
  final int noOfExecutions;
  final double amount;
  final String recipientAccount;

  @override
  Map<String, dynamic> get params => {
    'institution': account.institutionId,
    'account_number': account.accountNumber,
    'pin': pin,
    'mobile': user.mobile,
    'subscriber': account.subscriberId,
    'source': '1', // SOURCE MOBILE
    'request_id': Utils.randomId(),
    'retrievalReferenceNumber': Utils.randomId(),
    'firstExecutionDate': DateFormat('d-M-yyyy').format(firstExecutionDate),
    'frequency': 'M',
    'noOfExecutions': noOfExecutions.toString(),
    'amount': amount.toString(),
    'description': 'Standing Order',
    'destination_account': recipientAccount,
    'standingOrderType': 'external',
    'receivingInstitutionName': bank.name,
    'receivingInstitutionCode': bank.eftId,
    'creditAccountBranch': branch.code
  };

  @override
  String get serviceId => '202';

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    final Map<String, dynamic> response = data['response'];
    int code = response['code'];
    String message = response['message'];
    final result = StandingOrderResponse(code, message);
    result.description = response['description'];
    return result;
  }
}