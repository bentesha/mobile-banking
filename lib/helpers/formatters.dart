
import 'package:intl/intl.dart';

class Formatter {
  
  static String maskAccountNumber(String accountNumber) {
    final lastFour = accountNumber.substring(accountNumber.length - 4, accountNumber.length);
    return '**** **** **** **${lastFour.substring(0, 2)} ${lastFour.substring(2, 4)}';
  }

  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(amount);
  }
}