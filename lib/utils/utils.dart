import 'dart:math';

abstract class Utils {
  // Returns a 12 digits random string
  static String randomId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return (timestamp + (1000 + random.nextInt(9000)).toString()).substring(5);
  }
}
