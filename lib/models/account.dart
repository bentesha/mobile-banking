
class Account {

  String id;
  String name;
  String accountNumber;
  String subscriberAccountMain;
  String subscriberId;
  String institutionId;

  Account.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    accountNumber = data['account_number'];
    subscriberAccountMain = data['subscriber_account_main'];
    subscriberId = data['subscriber_id'];
    institutionId = data['institution_id'];
  }

  Account.fromNetwork(Map<String, dynamic> data) {
    id = data['id'];
    name = data['txt_name'];
    accountNumber = data['txt_account_number'];
    subscriberAccountMain = data['int_subscriber_account_main'];
    subscriberId = data['opt_mx_subscriber_id'];
    institutionId = data['opt_mx_institution_id'];
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'account_number': accountNumber,
    'subscriber_account_main': subscriberAccountMain,
    'subscriber_id': subscriberId,
    'institution_id': institutionId
  };
}