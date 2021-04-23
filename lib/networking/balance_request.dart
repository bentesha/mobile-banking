
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/balance_response.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:mkombozi_mobile/utils/utils.dart';

class BalanceRequest extends NetworkRequest<BalanceResponse> {

  static const SOURCE_MOBILE = '1';

  User user;
  Account account;
  String pin;

  BalanceRequest(this.user, this.account, this.pin) {
    assert(this.user != null);
    assert(this.account != null);
    assert(this.pin != null && this.pin.length == 4);
  }

  @override
  Map<String, dynamic> get params => {
    'institution': account.institutionId,
    'account_number': account.accountNumber,
    'pin': pin,
    'mobile': user.mobile,
    'subscriber': account.subscriberId,
    'source': SOURCE_MOBILE, // SOURCE = MOBILE
    'request_id': Utils.randomId()
  };

  @override
  String get serviceId => '100';

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    final Map<String, dynamic> response = data['response'];
    final int code = response['code'];
    final String message = response['message'];
    final result = BalanceResponse(code, message);

    result.balance = response['balance'];
    result.currency = response['currency'];
    result.transaction = response['transaction'];

    return result;
  }

}