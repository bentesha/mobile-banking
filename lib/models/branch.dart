
class Branch {
  String name;
  String code;

  Branch.fromNetwork(Map<String, dynamic> data) {
    name = data['txt_name'];
    code = data['txt_code'];
  }

  bool operator ==(other) {
    return other is Branch && other?.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}