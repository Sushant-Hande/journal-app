import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/date_helper.dart';

void main() {
  group('StringExtension.formatDate', () {
    test('formats a valid ISO date string', () {
      expect('2026-05-04'.formatDate(), '04/05/2026');
    });

    test('returns the original value when parsing fails', () {
      expect('not-a-date'.formatDate(), 'not-a-date');
    });

    test('returns empty string for empty input', () {
      expect(''.formatDate(), '');
    });
  });
}

