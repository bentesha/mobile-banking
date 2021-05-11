
import 'package:mkombozi_mobile/models/bank.dart';
import 'package:mkombozi_mobile/networking/send_money_request.dart';
import 'package:mkombozi_mobile/utils/utils.dart';

class EFTRequest extends SendMoneyRequest {

  @override
  Map<String, dynamic> get params => {
    'account_number': account.accountNumber,
    'subscriber': account.subscriberId,
    'institution': account.institutionId,
    'pin': pin,
    'destination_institution_code': (walletOrBank as Bank).eftId,
    'destination_institution_name': walletOrBank.name,
    'destination_account': referenceNumber,
    'destination_bank': (walletOrBank as Bank).bin,
    'mobile': user.mobile,
    'source': '1',
    'request_id': Utils.randomId(),
    'retrievalReferenceNumber': Utils.randomId(),
    'amount': amount.toString()
  };

  @override
  String get serviceId => '103';
  
}