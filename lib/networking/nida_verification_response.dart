
import 'package:mkombozi_mobile/networking/network_response.dart';

class NidaVerificationResponse extends NetworkResponse {
  NidaVerificationResponse(int code, String message) : super(code, message);

  String questionCode;
  String questionEn;
  String questionSw;
}