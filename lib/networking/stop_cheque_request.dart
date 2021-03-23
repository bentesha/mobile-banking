
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:mkombozi_mobile/utils/utils.dart';

class StopChequeRequest extends NetworkRequest<NetworkResponse> {

  final Account account;
  final String chequeNumber;
  final User user;
  final String pin;

  StopChequeRequest({
    @required this.account,
    @required this.chequeNumber,
    @required this.pin,
    @required this.user
  });

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    return NetworkResponse.from(data);
  }

  @override
  Map<String, dynamic> get params => {
    'institution': account.institutionId,
    'account_number': account.accountNumber,
    'subscriber': account.subscriberId,
    'pin': pin,
    'mobile': user.mobile,
    'source': '1',
    'request_id': Utils.randomId(),
    'retrievalReferenceNumber': Utils.randomId(),
    'checkNumber': chequeNumber
  };

  @override
  String get serviceId => '205';
  
}