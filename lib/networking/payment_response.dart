
import 'package:mkombozi_mobile/networking/network_response.dart';

class PaymentResponse extends NetworkResponse {

  PaymentResponse(int code, String message) : super(code, message);

  String description;
  String transaction;

}