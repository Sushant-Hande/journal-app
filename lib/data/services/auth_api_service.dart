import 'package:dio/dio.dart';
import 'package:journal_app/network/api_error.dart';
import 'package:journal_app/network/api_result.dart';
import 'package:journal_app/network/dio_error_mapper.dart';

import '../../network/api_constants.dart';

class AuthApiService {
  AuthApiService(this._dio);

  final Dio _dio;

  Future<ApiResult<bool>> signUp({
    required String userName,
    required String password,
  }) async {
    try {
      await _dio.post(
        ApiConstants.signUp,
        data: {"userName": userName, "password": password},
      );
      return ApiResult.success(true);
    } on DioException catch (e) {
      return ApiResult.failure(DioErrorMapper.map(e));
    } catch (_) {
      return ApiResult.failure(
        ApiError(message: 'Failed to sign up. Please try again.'),
      );
    }
  }

  Future<ApiResult<String>> login({
    required String userName,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {"userName": userName, "password": password},
      );
      final String token = response.data;
      if (token.isEmpty) {
        return ApiResult.failure(
          ApiError(message: "Login succeeded but token not found in response."),
        );
      }
      return ApiResult.success(token);
    } on DioException catch (e) {
      return ApiResult.failure(DioErrorMapper.map(e));
    } catch (_) {
      return ApiResult.failure(
        ApiError(message: 'Failed to login. Please try again.'),
      );
    }
  }
}
