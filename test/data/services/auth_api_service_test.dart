import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/data/services/auth_api_service.dart';
import 'package:journal_app/network/api_error.dart';
import 'package:journal_app/network/api_result.dart';
import 'package:mocktail/mocktail.dart';

// Create a Mock class for Dio
class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AuthApiService authApiService;

  setUp(() {
    mockDio = MockDio();
    authApiService = AuthApiService(mockDio);
  });

  group('AuthApiService', () {
    group('signUp', () {
      test('returns success when signup API call succeeds', () async {
        // Arrange
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'User created successfully'},
          statusCode: 201,
        ));

        // Act
        final result = await authApiService.signUp(
          userName: 'testuser',
          password: 'password123',
        );

        // Assert
        expect(result.isSuccess, true);
        expect(result.data, true);
        expect(result.error, null);
        verify(() => mockDio.post(
          any(),
          data: any(named: 'data'),
        )).called(1);
      });

      test('returns failure when signup API call throws DioException', () async {
        // Arrange
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            message: 'User already exists',
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 409,
            ),
          ),
        );

        // Act
        final result = await authApiService.signUp(
          userName: 'testuser',
          password: 'password123',
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.error, isNotNull);
        expect(result.data, null);
      });

      test('returns failure with error message for generic exceptions', () async {
        // Arrange
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenThrow(Exception('Unknown error'));

        // Act
        final result = await authApiService.signUp(
          userName: 'testuser',
          password: 'password123',
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.error?.message,
            'Failed to sign up. Please try again.');
        expect(result.data, null);
      });
    });

    group('login', () {
      test('returns success with token when login API call succeeds', () async {
        // Arrange
        const expectedToken = 'mock_jwt_token_12345';
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: expectedToken,
          statusCode: 200,
        ));

        // Act
        final result = await authApiService.login(
          userName: 'testuser',
          password: 'password123',
        );

        // Assert
        expect(result.isSuccess, true);
        expect(result.data, expectedToken);
        expect(result.error, null);
      });

      test('returns failure when login API call throws DioException', () async {
        // Arrange
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            message: 'Invalid credentials',
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 401,
            ),
          ),
        );

        // Act
        final result = await authApiService.login(
          userName: 'testuser',
          password: 'wrongpassword',
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.error, isNotNull);
        expect(result.data, null);
      });

      test('returns failure when token is empty', () async {
        // Arrange
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: '',
          statusCode: 200,
        ));

        // Act
        final result = await authApiService.login(
          userName: 'testuser',
          password: 'password123',
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.error?.message,
            'Login succeeded but token not found in response.');
        expect(result.data, null);
      });

      test('returns failure with error message for generic exceptions', () async {
        // Arrange
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
            )).thenThrow(Exception('Network error'));

        // Act
        final result = await authApiService.login(
          userName: 'testuser',
          password: 'password123',
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.error?.message, 'Failed to login. Please try again.');
        expect(result.data, null);
      });
    });
  });
}

