
import 'package:mkombozi_mobile/networking/payment_request.dart';

class GeneralPaymentRequest extends PaymentRequest {

  String referenceNumber;
  String destinationTransactinId;

  @override
  String get serviceId => '111';

  @override
  Map<String, dynamic> get params {
    final map = super.params;
    map['destination_transaction_id'] = destinationTransactinId;
    map['payment_reference'] = referenceNumber;

    return map;
  }

}