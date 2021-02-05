
import 'dart:async';
import 'package:mkombozi_mobile/data/offline_database.dart';
import 'package:mkombozi_mobile/models/account.dart';

class AccountService {

  final OfflineDatabase _db;

  AccountService(this._db);

  Future<List<Account>> getAccounts() async {
    return _db.getAccounts();
  }

}