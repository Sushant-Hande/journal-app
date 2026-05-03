import 'package:intl/intl.dart';

// Get current date formatted using intl package
String getCurrentDate({String format = 'dd MMMM yyyy'}) {
  final now = DateTime.now();
  return DateFormat(format).format(now);
}

extension StringExtension on String {
  String formatDate({String format = 'dd/MM/yyyy'}) {
    if (isEmpty) return '';
    try {
      final dateTime = DateTime.parse(this);
      return DateFormat(format).format(dateTime);
    } catch (_) {
      return this; // fallback if parsing fails
    }
  }
}
