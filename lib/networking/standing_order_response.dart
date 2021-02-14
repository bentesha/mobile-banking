
import 'package:mkombozi_mobile/networking/network_response.dart';

class StandingOrderResponse extends NetworkResponse {

  StandingOrderResponse(int code, String message) : super(code, message);

  String description;

}