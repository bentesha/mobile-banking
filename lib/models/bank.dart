
import 'package:mkombozi_mobile/models/wallet_or_bank.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';

class Bank implements WalletOrBank {

  String bin;
  String name;
  String logo;

  Bank.fromMap(Map<String, dynamic> data) {
    bin = data['bin'];
    name = data['name'];
    logo = data['logo'];
  }

  Bank.fromNetwork(Map<String, dynamic> data) {
    name = data['txt_name'];
    bin = data['int_bin'];
    logo = data['txt_logo'];
  }

  Map<String, dynamic> toMap() => {
    'bin': bin,
    'name': name,
    'logo': logo
  };

  String get logoUrl => logo == null ? null : NetworkRequest.BANK_IMAGE_BASE_URL + logo;

  bool get isWallet => false;
}