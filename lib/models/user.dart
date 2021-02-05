

class User {

  String id;
  String mobile;
  String name;
  String email;
  int agency;
  int visa;

  User({this.id, this.mobile, this.name, this.email, this.agency, this.visa});

  User.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    mobile = data['mobile'];
    name = data['name'];
    email = data['email'];
    agency = data['agency'];
    visa = data['visa'];
  }

  User.fromNetwork(Map<String, dynamic> data) : this.fromMap(data);

  toMap() => {
    'id': id,
    'mobile': mobile,
    'name': name,
    'email': email,
    'agency': agency,
    'visa': visa
  };
}