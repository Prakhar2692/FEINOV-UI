import 'package:intl/intl.dart';

class AppFormatters {
  const AppFormatters._();

  static String formatCurrency(
    num value, {
    String locale = 'en_IN',
    String symbol = '₹',
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  static String formatDate(
    DateTime dateTime, {
    String pattern = 'dd MMM yyyy',
  }) {
    return DateFormat(pattern).format(dateTime);
  }
}
