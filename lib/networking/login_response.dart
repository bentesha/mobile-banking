
import 'package:mkombozi_mobile/models/account.dart';
import 'package:mkombozi_mobile/models/device.dart';
import 'package:mkombozi_mobile/models/service.dart';
import 'package:mkombozi_mobile/models/user.dart';
import 'package:mkombozi_mobile/networking/network_response.dart';

class LoginResponse extends NetworkResponse {

  User subscriber;
  List<Account> accounts;
  List<Device> devices;
  List<Service> services;

  LoginResponse(int status, String message) : super(status, message);


}