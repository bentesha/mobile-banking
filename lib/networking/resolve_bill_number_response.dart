import 'package:mkombozi_mobile/models/bill_reference_info.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';

class ResolveBillNumberResponse extends NetworkResponse {
  ResolveBillNumberResponse(int code, String message) : super(code, message);

  BillReferenceInfo info;
  
}