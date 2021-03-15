

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/service.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:mkombozi_mobile/networking/payment_response.dart';
import 'package:mkombozi_mobile/utils/utils.dart';

abstract class PaymentRequest extends NetworkRequest<PaymentResponse> {

  Account account;
  User user;
  Service service;
  String pin;
  double amount;
  String referenceNumber;
  String reference;
  bool savePayee = false;

  @override
  @mustCallSuper
  Map<String, dynamic> get params => {
    'institution': account.institutionId,
    'account_number': account.accountNumber,
    'pin': pin,
    'mobile': user.mobile,
    'subscriber': account.subscriberId,
    'source': '1',
    'request_id': Utils.randomId(),
    'amount': amount.toString(),
    'retrievalReferenceNumber': Utils.randomId(),
    'savePayee': savePayee ? '1' : '0',
    'reference': reference,
  };

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    final Map<String, dynamic> response = data['response'];
    final int code = response['code'];
    final String message = response['message'];
    final result = PaymentResponse(code, message);
    result.description = response['description'];
    result.transaction = response['transaction'];

    return result;
  }

}