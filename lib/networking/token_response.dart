
import 'package:mkombozi_mobile/models/token.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';

class TokenResponse extends NetworkResponse {

  TokenResponse(int code, String message) : super(code, message);

  String description;
  List<Token> tokens;

}