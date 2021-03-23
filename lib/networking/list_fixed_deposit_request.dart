
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/fixed_deposit.dart';
import 'package:mkombozi_mobile/networking/list_fixed_deposit_response.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';

class ListFixedDepositRequest extends NetworkRequest<ListFixedDepositResponse> {

  String pin;
  Account account;

  @override
  Map<String, dynamic> get params => {
    'institution': account.institutionId,
    'account_number': account.accountNumber,
    'pin': pin,
    'subscriber': account.subscriberId,
    'step': '1',
    'loan_type': 'FD'
  };

  @override
  String get serviceId => '201';

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    final Map<String, dynamic> response = data['response'];
    int code = response['code'];
    String message = response['message'];
    String description = response['description'];
    final result = ListFixedDepositResponse(code, message);
    result.description = description;
    if (code != 200) {
      return result;
    }
    final list = asMapList(response['activeFDs']);
    result.fixedDeposits = list.map((data) {
      return FixedDeposit.fromNetwork(data)
        ..accountNumber = account.accountNumber;
      }).toList();

    return result;
  }
}