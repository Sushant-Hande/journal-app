import 'package:flutter/foundation.dart';
import 'package:journal_app/data/models/journal_entry.dart';
import 'package:journal_app/data/repositories/add_journal_repository.dart';
import 'package:journal_app/data/services/local_storage_service.dart';
import 'package:journal_app/network/api_status.dart';

class AddJournalViewmodel extends ChangeNotifier {
  AddJournalViewmodel(this._addJournalRepository, this._localStorageService);

  final AddJournalRepository _addJournalRepository;
  final LocalStorageService _localStorageService;

  ApiStatus _addJournalApiStatus = ApiStatus.initial;
  ApiStatus get addJournalApiStatus => _addJournalApiStatus;
  bool get isAddJournalApiLoading => _addJournalApiStatus == ApiStatus.loading;

  String? _addJournalErrorMessage;

  String? get addJournalErrorMessage => _addJournalErrorMessage;

  Future<JournalEntry?> addJournal({
    required String title,
    required String content,
  }) async {
    _addJournalApiStatus = ApiStatus.loading;
    notifyListeners();
    _addJournalErrorMessage = null;

    String userName = await _localStorageService.getUserName() ?? '';

    final result = await _addJournalRepository.addJournal(
      title: title,
      content: content,
      userName: userName,
    );

    if (result.isSuccess) {
      _addJournalApiStatus = ApiStatus.success;
      notifyListeners();
      return result.data;
    } else {
      _addJournalApiStatus = ApiStatus.error;
      _addJournalErrorMessage = result.error?.message;
      notifyListeners();
      return null;
    }
  }
}
