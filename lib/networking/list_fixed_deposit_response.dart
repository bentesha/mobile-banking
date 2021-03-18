
import 'package:mkombozi_mobile/models/fixed_deposit.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';

class ListFixedDepositResponse extends NetworkResponse {

  ListFixedDepositResponse(int code, String message) : super(code, message);

  List<FixedDeposit> fixedDeposits;

}