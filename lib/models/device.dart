
class Device {

  String imei;
  String registeredDate;
  String subscriberId;
  String model;

  Device.fromMap(Map<String, dynamic> data) {
    imei = data['imei'];
    registeredDate = data['registered_date'];
    subscriberId = data['subscriber_id'];
    model = data['model'];
  }

  Device.fromNetwork(Map<String, dynamic> data) {
    imei = data['txt_imei'];
    registeredDate = data['dat_registered_date'];
    subscriberId = data['opt_mx_subscriber_id'];
    model = data['txt_model'];
  }

  Map<String, dynamic> toMap() => {
    'imei': imei,
    'registered_date': registeredDate,
    'subscriber_id': subscriberId,
    'model': model
  };
}