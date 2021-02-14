
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';

class ChangePinRequest extends NetworkRequest<NetworkResponse> {

  ChangePinRequest({
    @required this.account,
    @required this.user,
    @required this.pin,
    @required this.newPin
  });

  final Account account;
  final User user;
  final String pin;
  final String newPin;

  @override
  Map<String, dynamic> get params => {
    'institution': account.institutionId,
    'mobile': user.mobile,
    'pin': pin,
    'new_pin': newPin
  };

  @override
  String get serviceId => '4';

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    final Map<String, dynamic> response = data['response'];
    int code = response['code'];
    String message = response['message'];
    final result = NetworkResponse(code, message);
    result.description = response['description'];
    return result;
  }

}