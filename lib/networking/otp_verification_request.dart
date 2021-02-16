
import 'package:flutter/cupertino.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';

class OtpVerificationRequest extends NetworkRequest<NetworkResponse> {

  OtpVerificationRequest({@required this.otp});

  String otp;

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) =>
      NetworkResponse.from(data);

  @override
  Map<String, dynamic> get params => {
    'otp': otp
  };

  @override
  String get serviceId => '2';

}