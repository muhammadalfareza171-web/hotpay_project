class CurrencyFormatter {
  CurrencyFormatter._();

  /// Formats an integer amount to Indonesian Rupiah, e.g., 28000 -> "Rp 28.000"
  static String format(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }
}
