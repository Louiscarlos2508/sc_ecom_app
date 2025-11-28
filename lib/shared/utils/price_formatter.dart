/// Formate les prix en FCFA selon les règles ECONOMAX
/// Format: 1 500 FCFA
class PriceFormatter {
  PriceFormatter._();

  static String format(int priceInFcfa) {
    final String priceStr = priceInFcfa.toString();
    final StringBuffer formatted = StringBuffer();

    int count = 0;
    for (int i = priceStr.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        formatted.write(' ');
      }
      formatted.write(priceStr[i]);
      count++;
    }

    final String reversed = formatted.toString().split('').reversed.join();
    return '$reversed FCFA';
  }
}

