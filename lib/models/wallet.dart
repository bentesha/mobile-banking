
import 'package:mkombozi_mobile/models/wallet_or_bank.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';

class Wallet implements WalletOrBank {

  String bin;
  String name;
  String logo;

  Wallet.fromMap(Map<String, dynamic> data) {
    bin = data['bin'];
    name = data['name'];
    logo = data['logo'];
  }

  Wallet.fromNetwork(Map<String, dynamic> data) {
    name = data['txt_name'];
    bin = data['int_bin'];
    logo = data['txt_logo'];
  }

  Map<String, dynamic> toMap() => {
    'bin': bin,
    'name': name,
    'logo': logo
  };

  String get logoUrl => logo == null ? null : NetworkRequest.WALLET_IMAGE_BASE_URL + logo;

  bool get isWallet => true;
}