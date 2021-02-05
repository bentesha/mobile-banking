
import 'package:mkombozi_mobile/models/bank.dart';
import 'package:mkombozi_mobile/models/institution.dart';
import 'package:mkombozi_mobile/models/service.dart';
import 'package:mkombozi_mobile/models/wallet.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';

class ConfigResponse extends NetworkResponse {

  final String type;
  List<Institution> institutions;
  List<Service> services;
  List<Bank> banks;
  List<Wallet> wallets;
  List<Service> coreServices;

  ConfigResponse(int code, String message, this.type, {this.institutions, this.services, this.banks, this.wallets, this.coreServices}) : super(code, message);

}