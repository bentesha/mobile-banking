
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

}