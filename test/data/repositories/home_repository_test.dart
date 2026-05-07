import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:journal_app/data/models/journal_entry.dart';
import 'package:journal_app/data/repositories/home_repository.dart';
import 'package:journal_app/data/services/home_api_service.dart';

import '../../test_helpers.dart';

class MockHomeApiService extends Mock implements HomeApiService {}

void main() {
  late MockHomeApiService mockService;
  late HomeRepository repository;

  setUp(() {
    mockService = MockHomeApiService();
    repository = HomeRepository(mockService);
  });

  group('HomeRepository', () {
    test('forwards getJournalsFor to HomeApiService and returns result', () async {
      // Arrange
      final journals = [JournalEntry(title: 'A'), JournalEntry(title: 'B')];
      when(() => mockService.getJournalsFor(userName: any(named: 'userName')))
          .thenAnswer((_) async => TestDataBuilder.buildSuccessResult(journals));

      // Act
      final result = await repository.getJournalsFor(userName: TestConstants.testUserName);

      // Assert
      expect(result.isSuccess, true);
      expect(result.data, journals);
      verify(() => mockService.getJournalsFor(userName: TestConstants.testUserName)).called(1);
    });

    test('passes through failure from HomeApiService', () async {
      // Arrange
      final errorResult = TestDataBuilder.buildFailureResult<List<JournalEntry>>(message: TestConstants.networkError);
      when(() => mockService.getJournalsFor(userName: any(named: 'userName')))
          .thenAnswer((_) async => errorResult);

      // Act
      final result = await repository.getJournalsFor(userName: TestConstants.testUserName);

      // Assert
      expect(result.isSuccess, false);
      expect(result.error?.message, TestConstants.networkError);
      verify(() => mockService.getJournalsFor(userName: TestConstants.testUserName)).called(1);
    });
  });
}

