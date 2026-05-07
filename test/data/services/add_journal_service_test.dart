import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:journal_app/data/models/journal_entry.dart';
import 'package:journal_app/data/services/add_journal_service.dart';
import 'package:journal_app/network/dio_error_mapper.dart';

import '../../test_helpers.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AddJournalService service;

  setUp(() {
    mockDio = MockDio();
    service = AddJournalService(mockDio);
  });

  group('AddJournalService', () {
    group('addJournal', () {
      test('returns success when response is a valid Map with JournalEntry data', () async {
        // Arrange
        final responseData = {
          'id': {'timestamp': 1700000000000, 'date': '2025-01-02'},
          'title': 'Test Journal',
          'content': 'This is a test entry',
          'date': '2025-01-02',
          'sentiment': 'happy',
        };

        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: responseData,
          statusCode: 200,
        ));

        // Act
        final result = await service.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
          userName: TestConstants.testUserName,
        );

        // Assert
        expect(result.isSuccess, true);
        expect(result.data, isNotNull);
        expect(result.data?.title, 'Test Journal');
        expect(result.data?.content, 'This is a test entry');
        expect(result.error, null);
        verify(() => mockDio.post(
          any(),
          data: {'title': 'Test Journal', 'content': 'This is a test entry'},
        )).called(1);
      });

      test('returns failure when response is not a Map', () async {
        // Arrange
        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: 'invalid data',
          statusCode: 200,
        ));

        // Act
        final result = await service.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
          userName: TestConstants.testUserName,
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.data, null);
        expect(result.error, isNotNull);
        expect(result.error?.message, 'Error while adding Journal');
      });

      test('returns failure when response is a list instead of Map', () async {
        // Arrange
        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: [],
          statusCode: 200,
        ));

        // Act
        final result = await service.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
          userName: TestConstants.testUserName,
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.error?.message, 'Error while adding Journal');
      });

      test('maps DioException to ApiError with proper message', () async {
        // Arrange
        final dio = Dio();
        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
        )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
            message: 'Connection timeout',
          ),
        );

        // Act
        final result = await service.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
          userName: TestConstants.testUserName,
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.error, isNotNull);
        expect(result.error?.message, isNotEmpty);
      });

      test('maps DioException with badResponse (401) correctly', () async {
        // Arrange
        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
        )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 401,
            ),
            message: 'Unauthorized',
          ),
        );

        // Act
        final result = await service.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
          userName: TestConstants.testUserName,
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.error?.statusCode, 401);
      });

      test('returns failure with default message on generic exception', () async {
        // Arrange
        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
        )).thenThrow(Exception('Unexpected error'));

        // Act
        final result = await service.addJournal(
          title: 'Test Journal',
          content: 'This is a test entry',
          userName: TestConstants.testUserName,
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.error?.message, 'Failed to Add Journal. Please try again.');
      });
    });
  });
}

