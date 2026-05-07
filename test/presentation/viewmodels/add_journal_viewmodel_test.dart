import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:journal_app/data/models/journal_entry.dart';
import 'package:journal_app/data/repositories/add_journal_repository.dart';
import 'package:journal_app/data/services/local_storage_service.dart';
import 'package:journal_app/network/api_error.dart';
import 'package:journal_app/network/api_result.dart';
import 'package:journal_app/network/api_status.dart';
import 'package:journal_app/presentation/viewmodels/add_journal_viewmodel.dart';

import '../../test_helpers.dart';

class MockAddJournalRepository extends Mock implements AddJournalRepository {}
class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  late MockAddJournalRepository mockRepository;
  late MockLocalStorageService mockLocalStorageService;
  late AddJournalViewmodel viewModel;

  setUp(() {
    mockRepository = MockAddJournalRepository();
    mockLocalStorageService = MockLocalStorageService();
    viewModel = AddJournalViewmodel(mockRepository, mockLocalStorageService);
  });

  group('AddJournalViewmodel', () {
    group('addJournal', () {
      test('updates state to loading then success and returns JournalEntry', () async {
        // Arrange
        final journalEntry = JournalEntry(
          id: Id(timestamp: 1700000000000),
          title: 'Test Journal',
          content: 'This is a test entry',
          date: '2025-01-02',
          sentiment: 'happy',
        );
        when(() => mockLocalStorageService.getUserName())
            .thenAnswer((_) async => TestConstants.testUserName);
        when(() => mockRepository.addJournal(
          title: any(named: 'title'),
          content: any(named: 'content'),
          userName: any(named: 'userName'),
        )).thenAnswer((_) async => TestDataBuilder.buildSuccessResult(journalEntry));

        // Act
        final future = viewModel.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
        );

        // Assert loading state
        expect(viewModel.addJournalApiStatus, ApiStatus.loading);
        expect(viewModel.isAddJournalApiLoading, true);

        final result = await future;

        // Assert final state
        expect(result, journalEntry);
        expect(result?.title, 'Test Journal');
        expect(viewModel.addJournalApiStatus, ApiStatus.success);
        expect(viewModel.addJournalErrorMessage, null);
        verify(() => mockRepository.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
          userName: TestConstants.testUserName,
        )).called(1);
      });

      test('updates state to error when repository fails', () async {
        // Arrange
        final error = ApiError(
          message: TestConstants.invalidCredentialsError,
          statusCode: TestConstants.statusUnauthorized,
        );
        when(() => mockLocalStorageService.getUserName())
            .thenAnswer((_) async => TestConstants.testUserName);
        when(() => mockRepository.addJournal(
          title: any(named: 'title'),
          content: any(named: 'content'),
          userName: any(named: 'userName'),
        )).thenAnswer((_) async => ApiResult.failure(error));

        // Act
        final result = await viewModel.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
        );

        // Assert
        expect(result, null);
        expect(viewModel.addJournalApiStatus, ApiStatus.error);
        expect(viewModel.addJournalErrorMessage, TestConstants.invalidCredentialsError);
      });

      test('uses empty username when LocalStorageService returns null', () async {
        // Arrange
        final journalEntry = JournalEntry(
          id: Id(timestamp: 1700000000000),
          title: 'Test Journal',
          content: 'This is a test entry',
        );
        when(() => mockLocalStorageService.getUserName())
            .thenAnswer((_) async => null);
        when(() => mockRepository.addJournal(
          title: any(named: 'title'),
          content: any(named: 'content'),
          userName: any(named: 'userName'),
        )).thenAnswer((_) async => TestDataBuilder.buildSuccessResult(journalEntry));

        // Act
        final result = await viewModel.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
        );

        // Assert
        expect(result, journalEntry);
        verify(() => mockRepository.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
          userName: '',
        )).called(1);
      });

      test('resets error message on new request', () async {
        // Arrange: first call fails
        final errorMessage = TestConstants.networkError;
        when(() => mockLocalStorageService.getUserName())
            .thenAnswer((_) async => TestConstants.testUserName);
        when(() => mockRepository.addJournal(
          title: any(named: 'title'),
          content: any(named: 'content'),
          userName: any(named: 'userName'),
        )).thenAnswer((_) async => TestDataBuilder.buildFailureResult(
          message: errorMessage,
        ));

        // Act: first call
        await viewModel.addJournal(
          title: 'First',
          content: 'First content',
        );

        // Assert first call failed with error
        expect(viewModel.addJournalErrorMessage, errorMessage);

        // Arrange: second call succeeds
        final journalEntry = JournalEntry(
          id: Id(timestamp: 1700000000000),
          title: 'Success Journal',
          content: 'This succeeds',
        );
        when(() => mockRepository.addJournal(
          title: any(named: 'title'),
          content: any(named: 'content'),
          userName: any(named: 'userName'),
        )).thenAnswer((_) async => TestDataBuilder.buildSuccessResult(journalEntry));

        // Act: second call
        final result = await viewModel.addJournal(
          title: 'Success Journal',
          content: 'This succeeds',
        );

        // Assert error message is cleared on new request
        expect(result, journalEntry);
        expect(viewModel.addJournalErrorMessage, null);
        expect(viewModel.addJournalApiStatus, ApiStatus.success);
      });

      test('returns null and sets error when repository returns a failure', () async {
        // Arrange
        when(() => mockLocalStorageService.getUserName())
            .thenAnswer((_) async => TestConstants.testUserName);
        when(() => mockRepository.addJournal(
          title: any(named: 'title'),
          content: any(named: 'content'),
          userName: any(named: 'userName'),
        )).thenAnswer((_) async => TestDataBuilder.buildFailureResult(
          message: 'Journal entry is invalid',
        ));

        // Act
        final result = await viewModel.addJournal(
          title: 'Invalid Journal',
          content: 'Invalid content',
        );

        // Assert
        expect(result, null);
        expect(viewModel.addJournalApiStatus, ApiStatus.error);
        expect(viewModel.addJournalErrorMessage, 'Journal entry is invalid');
      });

      test('handles network error during add journal', () async {
        // Arrange
        when(() => mockLocalStorageService.getUserName())
            .thenAnswer((_) async => TestConstants.testUserName);
        when(() => mockRepository.addJournal(
          title: any(named: 'title'),
          content: any(named: 'content'),
          userName: any(named: 'userName'),
        )).thenAnswer((_) async => TestDataBuilder.buildFailureResult(
          message: TestConstants.networkError,
          statusCode: 0,
        ));

        // Act
        final result = await viewModel.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
        );

        // Assert
        expect(result, null);
        expect(viewModel.addJournalApiStatus, ApiStatus.error);
        expect(viewModel.addJournalErrorMessage, TestConstants.networkError);
      });
    });
  });
}

