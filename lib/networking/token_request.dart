import 'package:flutter/cupertino.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/token.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:mkombozi_mobile/networking/token_response.dart';
import 'package:mkombozi_mobile/utils/utils.dart';

class TokenRequest extends NetworkRequest<TokenResponse> {
  TokenRequest({@required this.account, @required this.user});

  final Account account;
  final User user;

  @override
  Map<String, dynamic> get params => {
    'institution': account.institutionId,
    'account_number': account.accountNumber,
    'mobile': user.mobile,
    'subscriber': account.subscriberId,
    'source': '1', // SOURCE MOBILE
    'request_id': Utils.randomId()
  };

  @override
  String get serviceId => '106';

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    final Map<String, dynamic> response = data['response'];
    int code = response['code'];
    String message = response['message'];
    final result = TokenResponse(code, message);
    result.description = response['description'];

    if (code == 200) {
      result.tokens = asMapList(response['tokens'])
          .map((data) => Token.fromMap(data))
          .toList();
    }

    return result;
  }

}
