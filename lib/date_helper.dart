import 'package:intl/intl.dart';

extension StringExtension on String {
  String formatDate({
    String format = 'dd/MM/yyyy',
  }) {
    if (isEmpty) return '';
    try {
      final dateTime = DateTime.parse(this);
      return DateFormat(format).format(dateTime);
    } catch (_) {
      return this; // fallback if parsing fails
    }
  }
}
