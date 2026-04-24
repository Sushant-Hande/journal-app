import 'package:journal_app/data/models/journal_entry.dart';
import 'package:journal_app/data/services/home_api_service.dart';

import '../../network/api_result.dart';

class HomeRepository {
  HomeRepository(this._homeApiService);

  final HomeApiService _homeApiService;


  Future<ApiResult<List<JournalEntry>>> getJournalsFor({required String userName}) {
    return _homeApiService.getJournalsFor(userName: userName);
  }
}
