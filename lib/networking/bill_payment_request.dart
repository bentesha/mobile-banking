
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:mkombozi_mobile/networking/payment_request.dart';

class BillPaymentRequest extends PaymentRequest {

  String referenceNumber;

  @override
  String get serviceId => '105';

  @override
  Map<String, dynamic> get params {
    final map = super.params;
    map['utility_reference'] = referenceNumber;
    map['utility'] = service.mti;

    return map;
  }

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

}