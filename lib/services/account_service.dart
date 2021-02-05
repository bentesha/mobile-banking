
import 'dart:async';
import 'package:mkombozi_mobile/data/offline_database.dart';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/service.dart';
import 'package:mkombozi_mobile/models/wallet_or_bank.dart';

class AccountService {

  final OfflineDatabase _db;

  AccountService(this._db);

  Future<List<Account>> getAccounts() async {
    return _db.getAccounts();
  }

  Future<List<Service>> getServices() async {
    return _db.getServices();
  }

  Future<List<Service>> getGeneralServices() async {
    return _db.getGeneralServices();
  }

  Future<List<Service>> getCoreServices() async {
    return _db.getCoreServices();
  }

  Future<List<Service>> getServiceByAppCategory(String id) async {
    return _db.getServiceByAppCategory(id);
  }

  Future<List<WalletOrBank>> getBanksOrWallets(String type) async {
    assert(type == 'bank' || type == 'wallet');
    return type == 'bank' ? _db.getBanks() : _db.getWallets();
  }
}