
class Wallet {

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
    bin = data['txt_bin'];
    logo = data['txt_logo'];
  }

  Map<String, dynamic> toMap() => {
    'bin': bin,
    'name': name,
    'logo': logo
  };
}