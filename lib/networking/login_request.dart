
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/device.dart';
import 'package:mkombozi_mobile/models/service.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/login_response.dart';
import 'package:mkombozi_mobile/networking/network_request.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';

class LoginRequest extends NetworkRequest<LoginResponse> {

  LoginRequest(this.pin) {
    assert(pin != null);
  }

  final String pin;
  final String institution = '30000003';

  @override
  Map<String, dynamic> get params => {
    'pin': pin,
    'institution': institution
  };

  @override
  String get serviceId => '3';

  @override
  NetworkResponse createResponse(Map<String, dynamic> data) {
    final Map<String, dynamic> response = data['response'];
    final int status = response['code'];
    final String message = response['message'];
    final result = LoginResponse(status, message);
    final accounts = asMapList(data['accounts']);
    final services = asMapList(data['services']);
    final devices = asMapList(data['devices']);
    result.subscriber = User.fromNetwork(data['subscriber']);
    result.accounts = accounts.map((entry) => Account.fromNetwork(entry)).toList();
    result.services = services.map((entry) => Service.fromNetwork(entry)).toList();
    result.devices = devices.map((entry) => Device.fromNetwork(entry)).toList();

    return result;
  }

}