
import 'dart:io';

class Token {

  Token.fromMap(Map<String, dynamic> data) {
    token = data['txt_token'];
    service = data['service'];
    reference = data['txt_reference'];
    date = data['dat_added_date'];
    amount = data['dbl_amount'];
  }

  String token;
  String service;
  String reference;
  String date;
  String amount;
}