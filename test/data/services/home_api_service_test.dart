import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:journal_app/data/services/home_api_service.dart';

import '../../test_helpers.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late HomeApiService service;

  setUp(() {
    mockDio = MockDio();
    service = HomeApiService(mockDio);
  });

  group('HomeApiService', () {
    test('returns list of JournalEntry on success', () async {
      // Arrange
      final responseData = [
        {
          'id': {'timestamp': 1700000000000},
          'title': 'Entry 1',
          'content': 'Hello',
          'date': '2024-01-01'
        },
        {
          'id': {'timestamp': 1600000000000},
          'title': 'Entry 2',
          'content': 'World',
          'date': '2023-01-01'
        }
      ];

      when(() => mockDio.get(any())).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: responseData,
            statusCode: 200,
          ));

      // Act
      final result = await service.getJournalsFor(userName: TestConstants.testUserName);

      // Assert
      expect(result.isSuccess, true);
      expect(result.data, isNotNull);
      expect(result.data!.length, 2);
      expect(result.data!.first.title, 'Entry 1');
      verify(() => mockDio.get(any(that: contains(TestConstants.testUserName)))).called(1);
    });

    test('returns failure when response is not a list', () async {
      // Arrange
      when(() => mockDio.get(any())).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: {'foo': 'bar'},
            statusCode: 200,
          ));

      // Act
      final result = await service.getJournalsFor(userName: TestConstants.testUserName);

      // Assert
      expect(result.isSuccess, false);
      expect(result.error?.message, contains('Invalid response format'));
      verify(() => mockDio.get(any(that: contains(TestConstants.testUserName)))).called(1);
    });

    test('maps DioException to ApiError via DioErrorMapper', () async {
      // Arrange
      when(() => mockDio.get(any())).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      ));

      // Act
      final result = await service.getJournalsFor(userName: TestConstants.testUserName);

      // Assert
      expect(result.isSuccess, false);
      expect(result.error?.message, 'No internet connection.');
    });

    test('ignores non-map items in list and parses maps', () async {
      // Arrange: list contains a non-map item and a valid map
      final responseData = [
        42,
        {
          'id': {'timestamp': 1700000000000},
          'title': 'OnlyMap',
          'content': 'Hello',
          'date': '2024-01-01'
        }
      ];

      when(() => mockDio.get(any())).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: responseData,
            statusCode: 200,
          ));

      // Act
      final result = await service.getJournalsFor(userName: TestConstants.testUserName);

      // Assert
      expect(result.isSuccess, true);
      expect(result.data, isNotNull);
      expect(result.data!.length, 1);
      expect(result.data!.first.title, 'OnlyMap');
    });

    test('maps badResponse status codes using DioErrorMapper', () async {
      // Arrange: throw a DioException with badResponse and a 401 status
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 401,
        data: null,
      );

      when(() => mockDio.get(any())).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: response,
      ));

      // Act
      final result = await service.getJournalsFor(userName: TestConstants.testUserName);

      // Assert
      expect(result.isSuccess, false);
      expect(result.error?.message, 'Unauthorized. Please login again.');
      expect(result.error?.statusCode, 401);
    });
  });
}

