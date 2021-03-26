
import 'package:mkombozi_mobile/models/branch.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:mkombozi_mobile/networking/resolve_branch_response.dart';

class ResolveBranchRequest extends NetworkRequest<ResolveBranchResponse> {

  ResolveBranchRequest();

  @override
  Map<String, dynamic> get params => {
    'institution': NetworkRequest.INSTITUTION_ID,
    'eft_id': NetworkRequest.INSTITUTION_EFT_ID,
  };

  @override
  String get serviceId => '207';

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    final Map<String, dynamic> response = data['response'];
    int code = response['code'];
    String message = response['message'];
    String description = response['description'];
    final result = ResolveBranchResponse(code, message);
    result.description = description;
    final branchList = asMapList(response['branches']);
    result.branches = branchList.map((data) => Branch.fromNetwork(data)).toList();
    return result;
  }
}