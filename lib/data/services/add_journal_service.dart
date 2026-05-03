import 'package:dio/dio.dart';
import 'package:journal_app/data/models/journal_entry.dart';

import '../../network/api_constants.dart';
import '../../network/api_error.dart';
import '../../network/api_result.dart';
import '../../network/dio_error_mapper.dart';

class AddJournalService {
  AddJournalService(this._dio);

  final Dio _dio;

  Future<ApiResult<JournalEntry>> addJournal({
    required String title,
    required String content,
    required String userName
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.addJournal}/$userName',
        data: {"title": title, "content": content},
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        return ApiResult.failure(
          ApiError(message: 'Error while adding Journal'),
        );
      }

      final journalEntry = JournalEntry.fromJson(data);

      return ApiResult.success(journalEntry);
    } on DioException catch (e) {
      return ApiResult.failure(DioErrorMapper.map(e));
    } catch (_) {
      return ApiResult.failure(
        ApiError(message: 'Failed to Add Journal. Please try again.'),
      );
    }
  }
}
