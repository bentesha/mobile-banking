
import 'package:mkombozi_mobile/helpers/formatters.dart';

class FixedDeposit  {
  String receiptId;
  String accountNumber;
  String currency;
  String matureDate;
  double amount;

  FixedDeposit.fromMap(Map<String, dynamic> data) {
    receiptId = data['receipt_id'];
    accountNumber = data['account_number'];
    currency = data['currency'];
    matureDate = data['mature_date'];
    amount = data['amount'];
  }

  Map<String, dynamic> toMap() => {
    'receipt_id': receiptId,
    'account_number': accountNumber,
    'currency': currency,
    'mature_date': matureDate,
    'amount': amount
  };

  FixedDeposit.fromNetwork(Map<String, dynamic> data) {
    receiptId = data['receipt_id'];
    currency = data['currCode'];
    matureDate = data['mature_date'];
    final amountString = data['transAmount'] as String ?? '0';
    amount = double.tryParse(amountString.replaceAll(',', '')) ?? 0;
  }

  bool operator ==(other) {
    return other != null && other is FixedDeposit && other.receiptId == receiptId;
  }

  @override
  int get hashCode => receiptId.hashCode;

  @override
  String toString() => '$currency ${Formatter.formatCurrency(amount)} ($matureDate)';
}