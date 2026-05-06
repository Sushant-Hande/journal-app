import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/data/repositories/auth_repository.dart';
import 'package:journal_app/data/services/auth_api_service.dart';
import 'package:journal_app/network/api_error.dart';
import 'package:journal_app/network/api_result.dart';
import 'package:mocktail/mocktail.dart';

// Create a Mock class for AuthApiService
class MockAuthApiService extends Mock implements AuthApiService {}

void main() {
  late MockAuthApiService mockAuthApiService;
  late AuthRepository authRepository;

  setUp(() {
    mockAuthApiService = MockAuthApiService();
    authRepository = AuthRepository(mockAuthApiService);
  });

  group('AuthRepository', () {
    group('signUp', () {
      test('returns success when service returns success', () async {
        // Arrange
        when(() => mockAuthApiService.signUp(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.success(true));

        // Act
        final result = await authRepository.signUp(
          userName: 'newuser',
          password: 'password123',
        );

        // Assert
        expect(result.isSuccess, true);
        expect(result.data, true);
        verify(() => mockAuthApiService.signUp(
              userName: 'newuser',
              password: 'password123',
            )).called(1);
      });

      test('returns failure when service returns failure', () async {
        // Arrange
        final error = ApiError(
          message: 'User already exists',
          statusCode: 409,
        );
        when(() => mockAuthApiService.signUp(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.failure(error));

        // Act
        final result = await authRepository.signUp(
          userName: 'existinguser',
          password: 'password123',
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.error?.message, 'User already exists');
        expect(result.data, null);
      });

      test('passes correct parameters to service', () async {
        // Arrange
        when(() => mockAuthApiService.signUp(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.success(true));

        const testUserName = 'testuser@example.com';
        const testPassword = 'securePassword123!';

        // Act
        await authRepository.signUp(
          userName: testUserName,
          password: testPassword,
        );

        // Assert
        verify(() => mockAuthApiService.signUp(
              userName: testUserName,
              password: testPassword,
            )).called(1);
      });
    });

    group('login', () {
      test('returns success with token when service returns success', () async {
        // Arrange
        const expectedToken = 'jwt_token_xyz';
        when(() => mockAuthApiService.login(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.success(expectedToken));

        // Act
        final result = await authRepository.login(
          userName: 'testuser',
          password: 'password123',
        );

        // Assert
        expect(result.isSuccess, true);
        expect(result.data, expectedToken);
        verify(() => mockAuthApiService.login(
              userName: 'testuser',
              password: 'password123',
            )).called(1);
      });

      test('returns failure when service returns failure', () async {
        // Arrange
        final error = ApiError(
          message: 'Invalid credentials',
          statusCode: 401,
        );
        when(() => mockAuthApiService.login(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.failure(error));

        // Act
        final result = await authRepository.login(
          userName: 'testuser',
          password: 'wrongpassword',
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.error?.message, 'Invalid credentials');
        expect(result.error?.statusCode, 401);
      });

      test('passes correct parameters to service', () async {
        // Arrange
        when(() => mockAuthApiService.login(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer(
            (_) async => ApiResult.success('token'));

        const testUserName = 'user@example.com';
        const testPassword = 'password123';

        // Act
        await authRepository.login(
          userName: testUserName,
          password: testPassword,
        );

        // Assert
        verify(() => mockAuthApiService.login(
              userName: testUserName,
              password: testPassword,
            )).called(1);
      });
    });
  });
}

