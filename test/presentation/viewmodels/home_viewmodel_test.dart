import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:journal_app/data/models/journal_entry.dart';
import 'package:journal_app/data/repositories/home_repository.dart';
import 'package:journal_app/data/services/local_storage_service.dart';
import 'package:journal_app/network/api_status.dart';
import 'package:journal_app/presentation/viewmodels/home_viewmodel.dart';

import '../../test_helpers.dart';

class MockHomeRepository extends Mock implements HomeRepository {}
class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  late MockHomeRepository mockRepository;
  late MockLocalStorageService mockLocalStorage;
  late HomeViewmodel viewModel;

  setUp(() {
    mockRepository = MockHomeRepository();
    mockLocalStorage = MockLocalStorageService();
    viewModel = HomeViewmodel(mockRepository, mockLocalStorage);
  });

  group('HomeViewmodel.getJournals', () {
    test('updates state to loading then success and sorts journals newest-first', () async {
      // Arrange
      final older = JournalEntry(id: Id(timestamp: 1600000000000), title: 'older');
      final newer = JournalEntry(id: Id(timestamp: 1700000000000), title: 'newer');
      // return in unsorted order
      when(() => mockLocalStorage.getUserName()).thenAnswer((_) async => TestConstants.testUserName);
      when(() => mockRepository.getJournalsFor(userName: any(named: 'userName')))
          .thenAnswer((_) async => TestDataBuilder.buildSuccessResult([older, newer]));

      // Act
      final future = viewModel.getJournals();

      // Assert intermediate loading state
      expect(viewModel.getJournalsApiStatus, ApiStatus.loading);

      final result = await future;

      // Assert final state
      expect(result, true);
      expect(viewModel.getJournalsApiStatus, ApiStatus.success);
      expect(viewModel.getJournalErrorMessage, null);
      // newest first
      expect(viewModel.journals.first.title, 'newer');
      expect(viewModel.journals.last.title, 'older');
      verify(() => mockRepository.getJournalsFor(userName: TestConstants.testUserName)).called(1);
    });

    test('updates state to error when repository fails', () async {
      // Arrange
      when(() => mockLocalStorage.getUserName()).thenAnswer((_) async => TestConstants.testUserName);
      when(() => mockRepository.getJournalsFor(userName: any(named: 'userName')))
          .thenAnswer((_) async => TestDataBuilder.buildFailureResult(message: TestConstants.networkError));

      // Act
      final result = await viewModel.getJournals();

      // Assert
      expect(result, false);
      expect(viewModel.getJournalsApiStatus, ApiStatus.error);
      expect(viewModel.getJournalErrorMessage, TestConstants.networkError);
    });

    test('uses empty username when LocalStorageService returns null', () async {
      // Arrange
      when(() => mockLocalStorage.getUserName()).thenAnswer((_) async => null);
      final journals = [JournalEntry(title: 'A')];
      when(() => mockRepository.getJournalsFor(userName: any(named: 'userName')))
          .thenAnswer((_) async => TestDataBuilder.buildSuccessResult(journals));

      // Act
      final result = await viewModel.getJournals();

      // Assert
      expect(result, true);
      verify(() => mockRepository.getJournalsFor(userName: '')).called(1);
    });

    test('sorts entries when date is provided as ISO string and when id is missing', () async {
      // Arrange: one entry has id timestamp, another has date string
      final entryWithDateStr = JournalEntry(date: '2025-01-02', title: 'dateStr');
      final entryWithTs = JournalEntry(id: Id(timestamp: 1600000000), title: 'tsSeconds');

      when(() => mockLocalStorage.getUserName()).thenAnswer((_) async => TestConstants.testUserName);
      when(() => mockRepository.getJournalsFor(userName: any(named: 'userName')))
          .thenAnswer((_) async => TestDataBuilder.buildSuccessResult([entryWithTs, entryWithDateStr]));

      // Act
      final result = await viewModel.getJournals();

      // Assert: entryWithDateStr (2025) should be newer than entryWithTs (1970s)
      expect(result, true);
      expect(viewModel.journals.first.title, 'dateStr');
      expect(viewModel.journals.last.title, 'tsSeconds');
    });
  });

  group('HomeViewmodel.addJournalEntry', () {
    test('adds entry and keeps list sorted newest-first', () {
      // Arrange
      final entry1 = JournalEntry(id: Id(timestamp: 1600000000000), title: 'first');
      final entry2 = JournalEntry(id: Id(timestamp: 1700000000000), title: 'second');

      // Act
      viewModel.addJournalEntry(entry1);
      viewModel.addJournalEntry(entry2);

      // Assert
      expect(viewModel.journals.length, 2);
      expect(viewModel.journals.first.title, 'second');
      expect(viewModel.journals.last.title, 'first');
      expect(viewModel.getJournalsApiStatus, ApiStatus.success);
    });
  });
}

