

import 'package:flutter/cupertino.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:shortid/shortid.dart';

class ChequeBookRequest extends NetworkRequest<NetworkResponse> {

  ChequeBookRequest({@required this.account, @required this.user, @required this.pin});

  final Account account;
  final User user;
  final String pin;

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    final Map<String, dynamic> response = data['response'];
    int code = response['code'];
    String message = response['message'];
    final result = NetworkResponse(code, message);
    result.description = response['description'];
    return result;
  }

  @override
  Map<String, dynamic> get params => {
    'institution': account.institutionId,
    'account_number': account.accountNumber,
    'mobile': user.mobile,
    'subscriber': account.subscriberId,
    'pin': pin,
    'source': '1',
    'requested_service': 'CHQ',
    'request_id': shortid.generate()
  };

  @override
  String get serviceId => '203';

}