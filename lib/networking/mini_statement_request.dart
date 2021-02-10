
import 'package:flutter/cupertino.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/statement_request.dart';
import 'package:shortid/shortid.dart';

class MiniStatementRequest extends StatementRequest {

  MiniStatementRequest({
    @required Account account,
    @required User user,
    @required String pin
}) : super(account, user, pin);
  
  @override
  String get serviceId => '101';

  @override
  Map<String, dynamic> get params {
    final params = super.params;
    params['retrievalReferenceNumber'] = shortid.generate();
    return params;
  }

}