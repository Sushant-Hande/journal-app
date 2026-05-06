import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/data/repositories/auth_repository.dart';
import 'package:journal_app/data/services/local_storage_service.dart';
import 'package:journal_app/network/api_error.dart';
import 'package:journal_app/network/api_result.dart';
import 'package:journal_app/network/api_status.dart';
import 'package:journal_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Create Mock classes
class MockAuthRepository extends Mock implements AuthRepository {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockLocalStorageService mockLocalStorageService;
  late AuthViewModel authViewModel;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockLocalStorageService = MockLocalStorageService();
    authViewModel = AuthViewModel(mockAuthRepository, mockLocalStorageService);
  });

  group('AuthViewModel', () {
    group('signUp', () {
      test('updates state to loading then success when signup succeeds', () async {
        // Arrange
        when(() => mockAuthRepository.signUp(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.success(true));

        // Act & Assert
        expect(authViewModel.signUpApiStatus, ApiStatus.initial);
        expect(authViewModel.isSignUpApiLoading, false);

        final future = authViewModel.signUp(
          userName: 'newuser',
          password: 'password123',
        );

        // Should be loading immediately (or very soon)
        expect(authViewModel.signUpApiStatus, ApiStatus.loading);
        expect(authViewModel.isSignUpApiLoading, true);

        final result = await future;

        // Assert final state
        expect(result, true);
        expect(authViewModel.signUpApiStatus, ApiStatus.success);
        expect(authViewModel.isSignUpApiLoading, false);
        expect(authViewModel.signUpErrorMessage, null);
      });

      test('updates state to loading then error when signup fails', () async {
        // Arrange
        final error = ApiError(message: 'User already exists', statusCode: 409);
        when(() => mockAuthRepository.signUp(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.failure(error));

        // Act
        final result = await authViewModel.signUp(
          userName: 'existinguser',
          password: 'password123',
        );

        // Assert
        expect(result, false);
        expect(authViewModel.signUpApiStatus, ApiStatus.error);
        expect(authViewModel.isSignUpApiLoading, false);
        expect(authViewModel.signUpErrorMessage, 'User already exists');
      });

      test('clears previous error message before signup', () async {
        // Arrange - First create an error state
        final error = ApiError(message: 'Previous error', statusCode: 400);
        when(() => mockAuthRepository.signUp(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.failure(error));

        // Act - First signup fails and sets error
        await authViewModel.signUp(
          userName: 'user1',
          password: 'password1',
        );
        expect(authViewModel.signUpErrorMessage, 'Previous error');

        // Now mock success for second attempt
        when(() => mockAuthRepository.signUp(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.success(true));

        // Act - Second signup succeeds
        await authViewModel.signUp(
          userName: 'user2',
          password: 'password2',
        );

        // Assert - Error message should be cleared
        expect(authViewModel.signUpErrorMessage, null);
      });

      test('passes correct parameters to repository', () async {
        // Arrange
        when(() => mockAuthRepository.signUp(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.success(true));

        const testUserName = 'testuser@example.com';
        const testPassword = 'SecurePass123!';

        // Act
        await authViewModel.signUp(
          userName: testUserName,
          password: testPassword,
        );

        // Assert
        verify(() => mockAuthRepository.signUp(
              userName: testUserName,
              password: testPassword,
            )).called(1);
      });
    });

    group('login', () {
      test('updates state to loading then success when login succeeds', () async {
        // Arrange
        const token = 'mock_jwt_token';
        when(() => mockAuthRepository.login(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.success(token));
        when(() => mockLocalStorageService.saveAuthToken(any()))
            .thenAnswer((_) async => {});
        when(() => mockLocalStorageService.setIsLoggedIn(any()))
            .thenAnswer((_) async => {});
        when(() => mockLocalStorageService.setUserName(any()))
            .thenAnswer((_) async => {});

        // Act
        final result = await authViewModel.login(
          userName: 'testuser',
          password: 'password123',
        );

        // Assert
        expect(result, true);
        expect(authViewModel.loginApiStatus, ApiStatus.success);
        expect(authViewModel.isLoginApiLoading, false);
        expect(authViewModel.loginErrorMessage, null);
        verify(() => mockLocalStorageService.saveAuthToken(token))
            .called(1);
        verify(() => mockLocalStorageService.setIsLoggedIn(true))
            .called(1);
        verify(() => mockLocalStorageService.setUserName('testuser'))
            .called(1);
      });

      test('returns failure when token is empty', () async {
        // Arrange
        when(() => mockAuthRepository.login(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.success(''));

        // Act
        final result = await authViewModel.login(
          userName: 'testuser',
          password: 'password123',
        );

        // Assert
        expect(result, false);
        expect(authViewModel.loginApiStatus, ApiStatus.error);
        expect(authViewModel.loginErrorMessage,
            'Login succeeded but token was not returned.');
      });

      test('returns failure when repository returns error', () async {
        // Arrange
        final error = ApiError(
          message: 'Invalid credentials',
          statusCode: 401,
        );
        when(() => mockAuthRepository.login(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.failure(error));

        // Act
        final result = await authViewModel.login(
          userName: 'testuser',
          password: 'wrongpassword',
        );

        // Assert
        expect(result, false);
        expect(authViewModel.loginApiStatus, ApiStatus.error);
        expect(authViewModel.loginErrorMessage, 'Invalid credentials');
      });

      test('handles token save failure', () async {
        // Arrange
        const token = 'mock_jwt_token';
        when(() => mockAuthRepository.login(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.success(token));
        when(() => mockLocalStorageService.saveAuthToken(any()))
            .thenThrow(Exception('Storage error'));

        // Act
        final result = await authViewModel.login(
          userName: 'testuser',
          password: 'password123',
        );

        // Assert
        expect(result, false);
        expect(authViewModel.loginApiStatus, ApiStatus.error);
        expect(authViewModel.loginErrorMessage,
            contains('Failed to save authentication token'));
      });

      test('continues on user data save failure', () async {
        // Arrange
        const token = 'mock_jwt_token';
        when(() => mockAuthRepository.login(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.success(token));
        when(() => mockLocalStorageService.saveAuthToken(any()))
            .thenAnswer((_) async => {});
        when(() => mockLocalStorageService.setIsLoggedIn(any()))
            .thenThrow(Exception('Storage error'));

        // Act - should not throw
        final result = await authViewModel.login(
          userName: 'testuser',
          password: 'password123',
        );

        // Assert
        expect(result, true); // Login still succeeds
        expect(authViewModel.loginApiStatus, ApiStatus.success);
      });
    });

    group('logout', () {
      test('clears all auth data and resets state', () async {
        // Arrange - Set initial state by performing login
        const token = 'mock_jwt_token';
        when(() => mockAuthRepository.login(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.success(token));
        when(() => mockLocalStorageService.saveAuthToken(any()))
            .thenAnswer((_) async => {});
        when(() => mockLocalStorageService.setIsLoggedIn(any()))
            .thenAnswer((_) async => {});
        when(() => mockLocalStorageService.setUserName(any()))
            .thenAnswer((_) async => {});

        // Set initial state
        await authViewModel.login(
          userName: 'testuser',
          password: 'password123',
        );
        expect(authViewModel.loginApiStatus, ApiStatus.success);

        // Now mock clearAuthSession for logout
        when(() => mockLocalStorageService.clearAuthSession())
            .thenAnswer((_) async => {});

        // Act
        await authViewModel.logout();

        // Assert
        expect(authViewModel.loginApiStatus, ApiStatus.initial);
        expect(authViewModel.signUpApiStatus, ApiStatus.initial);
        expect(authViewModel.loginErrorMessage, null);
        expect(authViewModel.signUpErrorMessage, null);
        verify(() => mockLocalStorageService.clearAuthSession())
            .called(1);
      });
    });

    group('state properties', () {
      test('isSignUpApiLoading returns true only when status is loading', () async {
        // Arrange
        when(() => mockAuthRepository.signUp(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.success(true));

        // Initial state
        expect(authViewModel.isSignUpApiLoading, false);

        // During signup, loading should be true
        final future = authViewModel.signUp(
          userName: 'user',
          password: 'password',
        );
        expect(authViewModel.isSignUpApiLoading, true);

        // After completion
        await future;
        expect(authViewModel.isSignUpApiLoading, false);
      });

      test('isLoginApiLoading returns true only when status is loading', () async {
        // Arrange
        const token = 'mock_token';
        when(() => mockAuthRepository.login(
              userName: any(named: 'userName'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => ApiResult.success(token));
        when(() => mockLocalStorageService.saveAuthToken(any()))
            .thenAnswer((_) async => {});
        when(() => mockLocalStorageService.setIsLoggedIn(any()))
            .thenAnswer((_) async => {});
        when(() => mockLocalStorageService.setUserName(any()))
            .thenAnswer((_) async => {});

        // Initial state
        expect(authViewModel.isLoginApiLoading, false);

        // During login, loading should be true
        final future = authViewModel.login(
          userName: 'user',
          password: 'password',
        );
        expect(authViewModel.isLoginApiLoading, true);

        // After completion
        await future;
        expect(authViewModel.isLoginApiLoading, false);
      });

      test('error messages are nullable', () {
        expect(authViewModel.loginErrorMessage, null);
        expect(authViewModel.signUpErrorMessage, null);
      });
    });
  });
}




