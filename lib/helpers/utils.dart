
class Utils {

  static double stringToDouble(String string) {
    return double.parse(string.replaceAll(',', ''));
  }

  static bool validatePhoneNumber(String phoneNumber) {
    if (phoneNumber == null) {
      return false;
    }
    final regex = RegExp(r'^(255|0)[1-9][0-9]{8}$');
    return regex.hasMatch(phoneNumber);
  }

}