import 'package:dio/dio.dart';

import 'api_error.dart';

class DioErrorMapper {
  static ApiError map(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const ApiError(message: 'Connection timeout. Please try again.');

      case DioExceptionType.receiveTimeout:
        return const ApiError(message: 'Server is taking too long to respond.');

      case DioExceptionType.sendTimeout:
        return const ApiError(message: 'Request timeout. Please try again.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _messageFromStatusCode(statusCode, error.response?.data);
        return ApiError(
          message: message,
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return const ApiError(message: 'Request was cancelled.');

      case DioExceptionType.connectionError:
        return const ApiError(message: 'No internet connection.');

      case DioExceptionType.unknown:
      default:
        return const ApiError(message: 'Something went wrong. Please try again.');
    }
  }

  static String _messageFromStatusCode(int? code, dynamic data) {
    switch (code) {
      case 400:
        return 'Bad request.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access denied.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Unexpected error occurred.';
    }
  }
}