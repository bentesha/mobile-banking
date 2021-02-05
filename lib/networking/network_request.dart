
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mkombozi_mobile/networking/network_response.dart';


abstract class NetworkRequest<T extends NetworkResponse> {

  static const END_POINT = 'http://41.188.154.221:8000/api/mobile/';

  static const DEVICE_ID = '27fd082e222be23d';

  static const APP_VERSION = '1.6.0';

  /// Default HTTP method for API network requests
  String get method => 'POST';

  String get contentType => 'application/x-www-form-urlencoded';

  String get serviceId;

  Map<String, dynamic> get params;

  Future<T> send() async {
    final client = http.Client();
    final request = http.Request(method, Uri.parse(END_POINT));
    request.followRedirects = true;
    final params = HashMap<String, dynamic>();
    params['service_id']  = serviceId;
    params['udid'] = DEVICE_ID;
    params.addAll(this.params);
    print('params: $params');
    request.bodyFields = params.cast();
    request.headers['content-type'] = contentType;
    final response = await client.send(request).timeout(Duration(seconds: 5));
    final jsonResult = await response.stream.bytesToString();
    print('---- begin network result ----');
    print(jsonResult);
    print('---- end network result ----');
    client.close();
    return createResponse(json.decode(jsonResult));
  }

  @protected
  List<Map<String, dynamic>> asMapList(List<dynamic> list) {
    return List.castFrom(list);
  }

  NetworkResponse createResponse(Map<String, dynamic> data);

}