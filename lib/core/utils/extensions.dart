import 'package:intl/intl.dart';

extension StringX on String {
  String get sanitized => trim();

  bool get isValidEmail {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(trim());
  }

  bool get isValidPhone {
    final regex = RegExp(r'^[6-9]\d{9}$');
    return regex.hasMatch(trim());
  }
}

extension DateTimeX on DateTime {
  String toDisplayString({String pattern = 'dd MMM yyyy'}) {
    final formatter = DateFormat(pattern);
    return formatter.format(this);
  }
}
