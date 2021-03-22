import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/bill_reference_info.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:mkombozi_mobile/networking/resolve_bill_number_response.dart';
import 'package:mkombozi_mobile/utils/utils.dart';

class ResolveBillNumberRequest extends NetworkRequest<ResolveBillNumberResponse> {

  static const MTI_LUKU = 'LUKU';
  static const MTI_GEPG = 'GEPG';
  static const MTI_PAYMENT_SOLUTION = 'PAYSOLN';
  static const MTI_AIRTIME = 'TOP';

  ResolveBillNumberRequest({
    @required this.reference,
    @required this.account,
    @required this.mti
  });

  final String reference;
  final Account account;
  final String mti;

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    
    final Map<String, dynamic> response = data['response'];
    final code = response['code'];
    final message = response['message'];
    final description = response['description'];
    final result = ResolveBillNumberResponse(code, message);
    result.description = description;
    final info = BillReferenceInfo();
    info.resolvedName = response['resolved_name'] ?? response['pyr_name'];
    info.paymentType = response['payment_type'] ?? 'PARTIAL';
    info.institutionName = response['institution_name'] ?? response['sp_name'];
    info.institutionDescription = response['institution_description'] ?? '';
    info.amount = response['amount'] ?? response['min_pay_amount'];
    // info.phoneNumber = response['phone'];
    info.destinationTransactionId = response['destination_transaction_id'];
    result.info = info;
    return result;
  }

  @override
  Map<String, dynamic> get params {
    String channel = '10';
    String utility;
    if (mti == MTI_LUKU) {
      channel = '7';
      utility = 'LUKU';
    }
    if (mti == MTI_GEPG) {
      channel = '3';
      utility = 'GEPG';
    }


    final params = {
      'request_id': Utils.randomId(),
      'reference_to_resolve': reference,
      'institution': account.institutionId,
      'channel_route': channel,
    };

    if (utility != null) {
      params['utility'] = utility;
    }

    return params;
  }

  @override
  String get serviceId => '8';

}