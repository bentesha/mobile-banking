
import 'package:flutter/cupertino.dart';
import 'package:mkombozi_mobile/data/offline_database.dart';
import 'package:mkombozi_mobile/models/device.dart';
import 'package:mkombozi_mobile/models/service.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/config_request.dart';
import 'package:mkombozi_mobile/networking/login_request.dart';
import 'package:mkombozi_mobile/networking/login_response.dart';

class LoginService {
  
  OfflineDatabase _db;

  LoginService(this._db);
  
  User get currentUser => _db.currentUser;
  
  Future<LoginResponse> login(String pin) async {
    assert(pin != null && pin.length == 4);
    
    LoginRequest loginRequest = LoginRequest(pin);
    final loginResponse = await loginRequest.send();
    
    if (loginResponse.code == 200) {
      final combinedServices = <Service>[];
      await _db.setCurrentUser(loginResponse.subscriber);
      await _db.saveDevices(loginResponse.devices);
      await _db.saveAccounts(loginResponse.accounts);
      combinedServices.addAll(loginResponse.services);

      // Get configuration from server
      final configRequest = ConfigRequest();
      final configResponse = await configRequest.send();
      if (configResponse.code == 200) {
        await _db.saveWallets(configResponse.wallets);
        await _db.saveBanks(configResponse.banks);
        await _db.saveInstitutions(configResponse.institutions);
        combinedServices.addAll(configResponse.services);
        combinedServices.addAll(configResponse.coreServices);
      }
      await _db.saveServices(combinedServices);
    }

    return loginResponse;
  }

  Future<void> logout() async {
    // Clear all data
    await _db.deleteCurrentUser();
    await _db.saveDevices([]);
    await _db.saveAccounts([]);
    await _db.saveAccounts([]);
    await _db.saveWallets([]);
    await _db.saveServices([]);
    await _db.saveBanks([]);
  }

  Future<List<Device>> getDevices() {
    return _db.getDevices();
  }
}
