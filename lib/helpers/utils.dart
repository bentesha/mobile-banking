
class Utils {

  static double stringToDouble(String string) {
    return double.parse(string.replaceAll(',', ''));
  }

}