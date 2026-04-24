import 'package:flutter/cupertino.dart';
import 'package:journal_app/data/models/journal_entry.dart';
import 'package:journal_app/data/services/local_storage_service.dart';

import '../../data/repositories/home_repository.dart';
import '../../network/api_status.dart';

class HomeViewmodel extends ChangeNotifier {
  HomeViewmodel(this._homeRepository, this._localStorageService);

  final HomeRepository _homeRepository;
  final LocalStorageService _localStorageService;

  ApiStatus _getJournalsApiStatus = ApiStatus.initial;
  ApiStatus get getJournalsApiStatus => _getJournalsApiStatus;

  String? _getJournalErrorMessage = '';
  String? get getJournalErrorMessage => _getJournalErrorMessage;

  List<JournalEntry> _journals = [];
  List<JournalEntry> get journals => List.unmodifiable(_journals);

  Future<bool> getJournals() async {
    _getJournalsApiStatus = ApiStatus.loading;
    notifyListeners();
    _getJournalErrorMessage = null;
    String userName = await _localStorageService.getUserName() ?? '';
    final result = await _homeRepository.getJournalsFor(userName: userName);

    if (result.isSuccess) {
      _journals = result.data ?? [];
      _getJournalsApiStatus = ApiStatus.success;
      notifyListeners();
      return true;
    } else {
      _getJournalsApiStatus = ApiStatus.error;
      _getJournalErrorMessage = result.error?.message;
      notifyListeners();
      return false;
    }
  }
}
