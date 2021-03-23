
class Utils {

  static double stringToDouble(String string, {double defaultValue}) {
    return double.tryParse(string.replaceAll(',', '')) ?? defaultValue;
  }

  static bool validatePhoneNumber(String phoneNumber) {
    if (phoneNumber == null) {
      return false;
    }
    final regex = RegExp(r'^(255|0)[1-9][0-9]{8}$');
    return regex.hasMatch(phoneNumber);
  }

}