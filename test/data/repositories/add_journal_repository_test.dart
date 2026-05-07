import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:journal_app/data/models/journal_entry.dart';
import 'package:journal_app/data/repositories/add_journal_repository.dart';
import 'package:journal_app/data/services/add_journal_service.dart';

import '../../test_helpers.dart';

class MockAddJournalService extends Mock implements AddJournalService {}

void main() {
  late MockAddJournalService mockAddJournalService;
  late AddJournalRepository repository;

  setUp(() {
    mockAddJournalService = MockAddJournalService();
    repository = AddJournalRepository(mockAddJournalService);
  });

  group('AddJournalRepository', () {
    group('addJournal', () {
      test('returns success when service returns success', () async {
        // Arrange
        final journalEntry = JournalEntry(
          id: Id(timestamp: 1700000000000),
          title: 'Test Journal',
          content: 'This is a test entry',
          date: '2025-01-02',
          sentiment: 'happy',
        );
        when(() => mockAddJournalService.addJournal(
          title: any(named: 'title'),
          content: any(named: 'content'),
          userName: any(named: 'userName'),
        )).thenAnswer((_) async => TestDataBuilder.buildSuccessResult(journalEntry));

        // Act
        final result = await repository.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
          userName: TestConstants.testUserName,
        );

        // Assert
        expect(result.isSuccess, true);
        expect(result.data, journalEntry);
        expect(result.data?.title, 'Test Journal');
        expect(result.error, null);
        verify(() => mockAddJournalService.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
          userName: TestConstants.testUserName,
        )).called(1);
      });

      test('passes through failure without changing the error', () async {
        // Arrange
        final error = TestDataBuilder.buildApiError(
          message: TestConstants.networkError,
          statusCode: TestConstants.statusInternalServerError,
        );
        when(() => mockAddJournalService.addJournal(
          title: any(named: 'title'),
          content: any(named: 'content'),
          userName: any(named: 'userName'),
        )).thenAnswer((_) async => TestDataBuilder.buildFailureResult(
          message: error.message,
          statusCode: error.statusCode,
        ));

        // Act
        final result = await repository.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
          userName: TestConstants.testUserName,
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.error?.message, error.message);
        expect(result.error?.statusCode, error.statusCode);
        expect(result.data, null);
      });

      test('preserves service error when permission denied (401)', () async {
        // Arrange
        final error = TestDataBuilder.buildApiError(
          message: TestConstants.invalidCredentialsError,
          statusCode: TestConstants.statusUnauthorized,
        );
        when(() => mockAddJournalService.addJournal(
          title: any(named: 'title'),
          content: any(named: 'content'),
          userName: any(named: 'userName'),
        )).thenAnswer((_) async => TestDataBuilder.buildFailureResult(
          message: error.message,
          statusCode: error.statusCode,
        ));

        // Act
        final result = await repository.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
          userName: TestConstants.testUserName,
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.error?.message, TestConstants.invalidCredentialsError);
        expect(result.error?.statusCode, TestConstants.statusUnauthorized);
      });
    });
  });
}

