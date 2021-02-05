
import 'package:mkombozi_mobile/models/bank.dart';
import 'package:mkombozi_mobile/models/institution.dart';
import 'package:mkombozi_mobile/models/service.dart';
import 'package:mkombozi_mobile/models/wallet.dart';
import 'package:mkombozi_mobile/networking/config_response.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';

class ConfigRequest extends NetworkRequest<ConfigResponse> {
  @override
  Map<String, dynamic> get params => { 'app_version': '1.6.0' };

  @override
  String get serviceId => '0';

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    final Map<String, dynamic> response = data['response'];
    final int status = response['status'];
    final String message = response['message'];
    final String type = response['type'];
    final result = ConfigResponse(status, message, type);
    final institutions = asMapList(data['my_institutions']);
    final services =  asMapList(data['services']);
    final banks =  asMapList(data['banks']);
    final wallets =  asMapList(data['wallets']);
    result.institutions = institutions.map((entry) => Institution.fromNetwork(entry)).toList();
    result.services = services.map((e) => Service.fromNetwork(e)).toList();
    result.wallets = wallets.map((e) => Wallet.fromNetwork(e)).toList();
    result.banks = banks.map((e) => Bank.fromNetwork(e)).toList();

    return result;
  }

}
