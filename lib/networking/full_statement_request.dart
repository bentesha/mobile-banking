
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/statement_request.dart';

class FullStatementRequest extends StatementRequest {

  FullStatementRequest({
    @required Account account,
    @required User user,
    @required String pin,
    @required this.startDate,
    @required this.endDate
  }) : super(account, user, pin);

  final DateTime startDate;
  final DateTime endDate;

  @override
  String get serviceId => '110';

  @override
  Map<String, dynamic> get params {
    final params = super.params;
    final formatter = DateFormat('yyyyMMdd');
    params['from_date'] = formatter.format(startDate);
    params['to_date'] = formatter.format(endDate);
    return params;
  }

}