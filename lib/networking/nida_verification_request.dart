
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:mkombozi_mobile/networking/nida_verification_response.dart';

class NidaVerificationRequest extends NetworkRequest<NidaVerificationResponse> {

  NidaVerificationRequest({
    @required this.nin,
    @required this.phoneNumber,
    this.questionCode,
    this.answer,
    this.first = false
  });

  final bool first;
  final String questionCode;
  final String answer;
  final String nin;
  final String phoneNumber;

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    try {
      final Map<String, dynamic> response = data['response'];
      int code = response['code'];
      String message = response['message'];
      String description = response['description'];
      final result = NidaVerificationResponse(code, message);
      result.description = description;

      if (result.code == 200 || result.code == 210) {
        result.questionCode = response['question'];
        result.questionEn = response['question-en'];
        result.questionSw = response['question-sw'];
      }
      return result;
    } catch(error) {
      return NidaVerificationResponse(
        500,
        'Unkown Error!'
      )..description = 'Sorry! Something unexpected happened. Please try again later!';
    }
  }

  @override
  Map<String, dynamic> get params {
    final params = {
      'institution': NetworkRequest.INSTITUTION_ID,
      'answer': answer,
      'question': questionCode,
      'nin': nin,
      'mobile': phoneNumber
    };

    if (first) {
      params['first'] = '1';
    }
    return params;
  }

  @override
  String get serviceId => '206';

}