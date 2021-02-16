
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';

class RegisterRequest extends NetworkRequest<NetworkResponse> {

  RegisterRequest({
    @required this.mobile,
    @required this.pin,
    @required this.model,
    @required this.udid
  });

  final String pin;
  final String model;
  final String udid;
  final String mobile;

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) =>
      NetworkResponse.from(data);

  @override
  Map<String, dynamic> get params => {
    'institution': NetworkRequest.INSTITUTION_ID,
    'pin': pin,
    'mobile': mobile,
    'model': model,
    'udid': udid
  };

  @override
  String get serviceId => '1';

}