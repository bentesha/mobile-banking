import 'dart:async';
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/airtime_service.dart';
import 'package:mkombozi_mobile/models/bank.dart';
import 'package:mkombozi_mobile/models/device.dart';
import 'package:mkombozi_mobile/models/fixed_deposit.dart';
import 'package:mkombozi_mobile/models/institution.dart';
import 'package:mkombozi_mobile/models/service.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/models/wallet.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDatabase {
  static const String DATABASE_NAME = 'database.db';

  User _currentUser;

  Database _db;

  User get currentUser => _currentUser;

  Future<void> open() async {
    _db = await openDatabase(DATABASE_NAME, version: 1, onCreate: _onCreate);
    _currentUser = await _getCurrentUser();
  }

  static Future<void> delete() {
    return deleteDatabase(DATABASE_NAME);
  }

  Future<User> _getCurrentUser() async {
    final result = await _db.query('user');
    return result.length == 0 ? null : User.fromMap(result.first);
  }

  Future<void> setCurrentUser(User user) async {
    final batch = _db.batch();
    batch.delete('user');
    batch.insert('user', user.toMap());
    await batch.commit(noResult: true);
    _currentUser = await _getCurrentUser();
  }

  Future<void> deleteCurrentUser() async {
    await _db.delete('user');
    _currentUser = null;
  }

  Future<List<Account>> getAccounts() async {
    final result = await _db.query('account');
    return result.map((entry) => Account.fromMap(entry)).toList();
  }

  Future<void> saveAccounts(List<Account> accounts) async {
    return _db.transaction((txn) async {
      final batch = txn.batch();
      batch.delete('account');
      accounts.forEach((account) => batch.insert('account', account.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace));
      return await batch.commit(noResult: true);
    });
  }

  Future<List<Device>> getDevices() async {
    final result = await _db.query('device');
    return result.map((entry) => Device.fromMap(entry)).toList();
  }

  Future<void> saveDevices(List<Device> devices) async {
    return _db.transaction((txn) {
      final batch = txn.batch();
      batch.delete('device');
      devices.forEach((device) => batch.insert('device', device.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace));
      return batch.commit(noResult: true);
    });
  }

  Future<List<Service>> getServices() async {
    final result = await _db.query('service');
    return result.map((entry) => Service.fromMap(entry)).toList();
  }

  Future<List<Service>> getCoreServices() async {
    final result = await _db.query('service', where: 'core_id = 1');
    return result.map((entry) => Service.fromMap(entry)).toList();
  }

  Future<List<AirtimeService>> getAirtimeRechargeServices() async {
    final services = await getServices();
    final rechargeService = services
      .where((service) => service.mti == 'TOP')
      .first;
    final wallets = await getWallets();
    final utilities = ['TIGO-PESA', 'MPESA', 'AIRTEL-MONEY'];
    return utilities.map((utility) {
      final wallet = wallets.where((wallet) => wallet.bin == utility).first;
      final data = rechargeService.toMap();
      data['logo'] = wallet.logo;
      data['name'] = wallet.name;
      return AirtimeService.fromMap(data, utility);
    }).toList();
  }

  Future<List<Service>> getGeneralServices() async {
    final result = await _db.query('service', where: 'category_id IN (3, 4)');
    return result.map((entry) => Service.fromMap(entry)).toList();
  }

  Future<List<Service>> getServiceByAppCategory(String id) async {
    final result = await _db.query('service', where: 'app_category_id = ? AND core_id != 1', whereArgs: [id]);
    return result.map((entry) => Service.fromMap(entry)).toList();
  }

  // Future<List<WalletOrBank>> getBanksOrWallets(String type) async {
  //   assert(type == 'bank' || type == 'wallet');
  //   final result = await _db.query(type);
  //   return result.map((entry) {
  //     return type == 'bank'
  //         ? Bank.fromMap(entry)
  //         : Wallet.fromMap(entry);
  //   }).toList().cast<WalletOrBank>();
  // }

  Future<void> saveServices(List<Service> services) async {
    return _db.transaction((txn) {
      final batch = txn.batch();
      batch.delete('service');
      services.forEach((service) => batch.insert('service', service.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace));
      return batch.commit(noResult: true);
    });
  }

  Future<List<Institution>> getInstitutions() async {
    final result = await _db.query('institution');
    return result.map((entry) => Institution.fromMap(entry)).toList();
  }

  Future<void> saveInstitutions(List<Institution> institutions) async {
    return _db.transaction((txn) {
      final batch = txn.batch();
      batch.delete('institution');
      institutions.forEach((item) => batch.insert('institution', item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace));
      return batch.commit(noResult: true);
    });
  }

  Future<List<Wallet>> getWallets() async {
    final result = await _db.query('wallet');
    return result.map((entry) => Wallet.fromMap(entry)).toList();
  }

  Future<void> saveWallets(List<Wallet> wallets) async {
    return _db.transaction((txn) {
      final batch = txn.batch();
      batch.delete('wallet');
      wallets.forEach((wallet) => batch.insert('wallet', wallet.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace));
      return batch.commit(noResult: true);
    });
  }

  Future<List<Bank>> getBanks() async {
    final result = await _db.query('bank');
    return result.map((entry) => Bank.fromMap(entry)).toList();
  }

  Future<void> saveBanks(List<Bank> banks) async {
    return _db.transaction((txn) {
      final batch = txn.batch();
      batch.delete('bank');
      banks.forEach((bank) => batch.insert('bank', bank.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace));
      return batch.commit(noResult: true);
    });
  }

  Future<List<FixedDeposit>> getFixedDeposits(String accountNumber) async {
    final rows = await _db.query('fixed_deposit', where: 'account_number = ?', whereArgs: [accountNumber]);
    return rows.map((data) => FixedDeposit.fromMap(data)).toList();
  }

  Future<void> saveFixedDeposits(List<FixedDeposit> fixedDeposits) async {
    if (fixedDeposits == null || fixedDeposits.length == 0) {
      return;
    }
    return _db.transaction((txn) {
      final batch = txn.batch();
      batch.delete('fixed_deposit');
      fixedDeposits.forEach((fd) => batch.insert('fixed_deposit', fd.toMap()));
      return batch.commit(noResult: true);
    });
  }

  void _onCreate(Database db, int version) async {
    final userTable = '''
      CREATE TABLE user (
        id TEXT PRIMARY KEY,
        mobile TEXT NOT NULL,
        name TEXT NOT NULL,
        email TEXT,
        agency INTEGER,
        visa INTEGER
        )
    ''';

    final accountTable = '''
      CREATE TABLE account (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        account_number TEXT UNIQUE,
        subscriber_account_main TEXT,
        subscriber_id TEXT,
        institution_id TEXT
        )
    ''';

    final deviceTable = '''
      CREATE TABLE device (
        imei TEXT PRIMARY KEY,
        registered_date TEXT,
        subscriber_id TEXT,
        model TEXT
      )
    ''';

    final serviceTable = '''
      CREATE TABLE service (
        id TEXT PRIMARY KEY,
        mti TEXT,
        name TEXT,
        description TEXT,
        logo TEXT,
        control_number_id TEXT,
        category_id TEXT,
        app_category_id TEXT,
        state_id TEXT,
        core_id TEXT,
        row_value TEXT,
        limit_category_id TEXT
      )
    ''';

    final institutionTable = '''
      CREATE TABLE institution (
        id TEXT PRIMARY KEY,
        name TEXT,
        bin TEXT,
        logo TEXT,
        primary_color TEXT,
        secondary_color TEXT,
        splash_image TEXT,
        app_logo TEXT,
        app_theme_id TEXT,
        scheme_id TEXT
      )
    ''';

    final bankTable = '''
      CREATE TABLE bank (
        bin TEXT PRIMARY KEY,
        name TEXT,
        logo TEXT,
        eft_id TEXT
      )
    ''';

    final walletTable = '''
      CREATE TABLE wallet (
        bin TEXT PRIMARY KEY,
        name TEXT,
        logo TEXT
      )
    ''';

    final fdTable = '''
      CREATE TABLE fixed_deposit (
        receipt_id TEXT PRIMARY KEY,
        account_number TEXT NOT NULL,
        currency TEXT,
        mature_date TEXT,
        amount REAL DEFAULT 0
      )
    ''';

    final batch = db.batch();

    batch.execute(userTable);
    batch.execute(accountTable);
    batch.execute(serviceTable);
    batch.execute(deviceTable);
    batch.execute(institutionTable);
    batch.execute(bankTable);
    batch.execute(walletTable);
    batch.execute(fdTable);

    await batch.commit(noResult: true);
  }
}
