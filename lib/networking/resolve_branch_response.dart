
import 'package:mkombozi_mobile/models/branch.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';

class ResolveBranchResponse extends NetworkResponse {
  
  ResolveBranchResponse(int code, String message) : super(code, message);

  var branches = <Branch>[];
}