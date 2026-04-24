import 'package:dio/dio.dart';

import '../../network/api_constants.dart';
import '../../network/api_error.dart';
import '../../network/api_result.dart';
import '../../network/dio_error_mapper.dart';
import '../models/journal_entry.dart';

class HomeApiService {
  HomeApiService(this._dio);

  final Dio _dio;

  Future<ApiResult<List<JournalEntry>>> getJournalsFor({required String userName}) async {
    try {
      final response = await _dio.get('${ApiConstants.getJournals}/$userName');

      final data = response.data;

      if (data is! List) {
        return ApiResult.failure(
          ApiError(message: 'Invalid response format: expected a list'),
        );
      }

      final journals = data
          .whereType<Map<String, dynamic>>()
          .map((json) => JournalEntry.fromJson(json))
          .toList();

      return ApiResult.success(journals);
    } on DioException catch (e) {
      return ApiResult.failure(DioErrorMapper.map(e));
    } catch (_) {
      return ApiResult.failure(ApiError(message: 'Failed to get Journals'));
    }
  }
}
