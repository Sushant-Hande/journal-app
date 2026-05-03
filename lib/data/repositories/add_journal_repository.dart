import 'package:journal_app/data/services/add_journal_service.dart';
import '../../network/api_result.dart';
import '../models/journal_entry.dart';

class AddJournalRepository {
  AddJournalRepository(this._addJournalService);

  final AddJournalService _addJournalService;

  Future<ApiResult<JournalEntry>> addJournal({
    required String title,
    required String content,
    required String userName
  }) {
    return _addJournalService.addJournal(title: title, content: content, userName: userName);
  }
}
