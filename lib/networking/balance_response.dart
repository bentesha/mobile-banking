
import 'package:mkombozi_mobile/networking/network_response.dart';

class BalanceResponse extends NetworkResponse {

  double balance;
  String currency;
  String transaction;

  BalanceResponse(int code, String message) : super(code, message);
}