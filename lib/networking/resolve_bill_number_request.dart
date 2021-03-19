import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/bill_reference_info.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:mkombozi_mobile/networking/resolve_bill_number_response.dart';
import 'package:mkombozi_mobile/utils/utils.dart';

class ResolveBillNumberRequest extends NetworkRequest<ResolveBillNumberResponse> {

  String reference;
  Account account;

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    
    final Map<String, dynamic> response = data['response'];
    final code = response['code'];
    final message = response['message'];
    final description = response['description'];
    final result = ResolveBillNumberResponse(code, message);
    result.description = description;
    final info = BillReferenceInfo();
    info.resolvedName = response['resolved_name'];
    info.paymentType = response['payment_type'];
    info.institutionName = response['institution_name'];
    info.institutionDescription = response['institution_description'];
    info.amount = response['amount'];
    info.phoneNumber = response['phone'];
    info.destinationTransactionId = response['destination_transaction_id'];
    result.info = info;
    return result;
  }

  @override
  Map<String, dynamic> get params => {
    'request_id': Utils.randomId(),
    'reference_to_resolve': reference,
    'institution': account.institutionId,
    'channel_route': '10'
  };

  @override
  String get serviceId => '8';

}