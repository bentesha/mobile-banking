import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/full_statement_request.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';
import 'package:mkombozi_mobile/networking/statement_response.dart';
import 'package:shortid/shortid.dart';

abstract class StatementRequest extends NetworkRequest<StatementResponse> {

  StatementRequest(this.account, this.user, this.pin);

  final Account account;
  final User user;
  final String pin;

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    final Map<String, dynamic> response = data['response'];
    final int code = response['code'];
    final String message = response['message'];
    final result = StatementResponse(code, message);

    if (code == 200) {
      result.description = response['description'];
      result.transactions = asMapList(response['transactions'])
          .map((data) => TransactionItem.fromMap(data))
          .toList();

      if (this is FullStatementRequest && result.transactions.length >= 2) {
        result.openingBalance = result.transactions[0].amount;
        result.closingBalance = result.transactions[result.transactions.length - 1].amount;
      }
    }
    return result;
  }

  @override
  @mustCallSuper
  Map<String, dynamic> get params => {
        'institution': account.institutionId,
        'account_number': account.accountNumber,
        'pin': pin,
        'mobile': user.mobile,
        'subscriber': account.subscriberId,
        'source': '1', // SOURCE = MOBILE
        'request_id': shortid.generate()
      };
}
