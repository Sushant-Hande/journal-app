import 'package:journal_app/network/api_error.dart';
import 'package:journal_app/network/api_result.dart';

/// Common test data and utilities for unit testing
class TestConstants {
  /// Sample authentication
  static const String testUserName = 'testuser@example.com';
  static const String testPassword = 'TestPassword123!';
  static const String testToken = 'mock_jwt_token_xyz123abc';

  /// Sample error messages
  static const String userAlreadyExistsError = 'User already exists';
  static const String invalidCredentialsError = 'Invalid credentials';
  static const String networkError = 'Network error occurred';
  static const String unknownError = 'Unknown error';

  /// HTTP status codes
  static const int statusUnauthorized = 401;
  static const int statusConflict = 409;
  static const int statusInternalServerError = 500;
}

/// Utility functions for creating common test objects
class TestDataBuilder {
  /// Build an ApiError with common test data
  static ApiError buildApiError({
    String message = TestConstants.unknownError,
    int? statusCode,
    String? code,
  }) {
    return ApiError(
      message: message,
      statusCode: statusCode,
      code: code,
    );
  }

  /// Build a success ApiResult
  static ApiResult<T> buildSuccessResult<T>(T data) {
    return ApiResult.success(data);
  }

  /// Build a failure ApiResult
  static ApiResult<T> buildFailureResult<T>({
    String message = TestConstants.unknownError,
    int? statusCode,
  }) {
    return ApiResult.failure(
      ApiError(
        message: message,
        statusCode: statusCode,
      ),
    );
  }
}

