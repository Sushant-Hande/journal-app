import 'package:flutter/foundation.dart';
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
      // sort journals by date (newest first) before exposing them
      final fetched = result.data ?? [];
      fetched.sort((a, b) {
        final aEpoch = _epochFromEntry(a);
        final bEpoch = _epochFromEntry(b);
        // newest first
        return bEpoch.compareTo(aEpoch);
      });
      _journals = fetched;
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

  /// Add a single [entry] to the in-memory list and keep journals
  /// sorted (newest first). Not persisted — this assumes the repository
  /// already saved the entry remotely/local when it was created.
  void addJournalEntry(JournalEntry entry) {
    try {
      _journals.add(entry);
      _journals.sort((a, b) {
        final aEpoch = _epochFromEntry(a);
        final bEpoch = _epochFromEntry(b);
        return bEpoch.compareTo(aEpoch);
      });
      _getJournalsApiStatus = ApiStatus.success;
      notifyListeners();
    } catch (_) {
      // ignore errors here — keep existing state if something goes wrong
    }
  }

  // Convert a JournalEntry to an epoch (milliseconds) for reliable comparison.
  // Uses id.timestamp when available, otherwise attempts to parse the `date` string.
  int _epochFromEntry(JournalEntry entry) {
    try {
      final ts = entry.id?.timestamp;
      if (ts != null) {
        // Normalize seconds -> milliseconds when necessary
        if (ts < 1000000000000) {
          return ts * 1000;
        }
        return ts;
      }

      final dateStr = entry.date;
      if (dateStr != null && dateStr.isNotEmpty) {
        final dt = DateTime.tryParse(dateStr);
        if (dt != null) return dt.millisecondsSinceEpoch;

        // If date string is actually a numeric timestamp, try parse and normalize
        final parsedInt = int.tryParse(dateStr);
        if (parsedInt != null) {
          if (parsedInt < 1000000000000) return parsedInt * 1000;
          return parsedInt;
        }
      }
    } catch (_) {
      // ignore and fall through to default
    }

    // Fallback: treat as very old
    return 0;
  }
}
