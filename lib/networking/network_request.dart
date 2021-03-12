
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mkombozi_mobile/networking/network_response.dart';


abstract class NetworkRequest<T extends NetworkResponse> {

  static const INSTITUTION_ID = '30000003';
  static const END_POINT = 'http://41.188.154.221:8000/api/mobile/';
  static const SERVICE_IMAGE_BASE_URL = '${END_POINT}service_logos/';
  static const BANK_IMAGE_BASE_URL = '${END_POINT}bank_logos/';
  static const WALLET_IMAGE_BASE_URL = '${END_POINT}wallet_logos/';

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
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    final params = HashMap<String, dynamic>();
    params['service_id']  = serviceId;
    params['udid'] = deviceInfo.androidId;
    params.addAll(this.params);
    print('params: $params');
    request.bodyFields = params.cast();
    request.headers['content-type'] = contentType;
    try {
      final response = await client.send(request).timeout(Duration(seconds: 10));
      final jsonResult = await response.stream.bytesToString();
      print('---- begin network result ----');
      print(jsonResult);

      print('---- end network result ----');
      return createResponse(json.decode(jsonResult));
    } on IOException catch(e) {
      print(e);
      final response = {
        'code': 500,
        'message': 'Network Error',
        'description': 'Please check your data connection or retry again later.'
      };
      return createResponse({ 'response': response });
    } on TimeoutException catch(e) {
      print(e);
      final response = {
        'code': 500,
        'message': 'Device Offline',
        'description': 'Please check your data connection or retry again later.'
      };
      return createResponse({ 'response': response });
    } on FormatException catch(e) {
      // Possibly the returned response body is not a valid JSON formatted string
      print(e);
      final response = {
        'code': 500,
        'message': 'Server Error',
        'description': 'Unknown server error. Please retry again shortly!'
      };
      return createResponse({ 'response': response });
    } finally {
      client.close();
    }
  }

  @protected
  List<Map<String, dynamic>> asMapList(List<dynamic> list) {
    return List.castFrom(list);
  }

  NetworkResponse createResponse(Map<String, dynamic> data);

}