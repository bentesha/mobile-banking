
class Bank {

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
    bin = data['txt_bin'];
    logo = data['txt_logo'];
  }

  Map<String, dynamic> toMap() => {
    'bin': bin,
    'name': name,
    'logo': logo
  };
}