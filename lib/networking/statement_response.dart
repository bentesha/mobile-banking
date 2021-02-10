import 'package:mkombozi_mobile/networking/network_response.dart';

class StatementResponse extends NetworkResponse {

  String description;
  String openingBalance;
  String closingBalance;
  List<TransactionItem> transactions;

  StatementResponse(int code, String message) : super(code, message);
}

class TransactionItem {
  String description;
  bool isCredit;
  String date;
  String fromAccount;
  String toAccount;
  String amount;
  String currencyCode;
  String accountId1;
  String accountId2;
  bool selected;

  TransactionItem.fromMap(Map<String, dynamic> data) {
    description = data['transDescription'];
    isCredit = data['transType'] as String == 'Credit';
    date = data['transDate'];
    fromAccount = data['fromAcc'];
    toAccount = data['toAcc'];
    currencyCode = data['currCode'];
    accountId1 = data['accID1'];
    accountId2 = data['accID2'];
    amount = data['transAmount'];
  }
}
