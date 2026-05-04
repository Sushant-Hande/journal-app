import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService();

  // Secure storage for secrets/tokens.
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // SharedPreferences keys (sensitive)
  static const String _authTokenKey = 'auth_token';

  // SharedPreferences keys (non-sensitive)
  static const String isLoggedInKey = 'is_logged_in';
  static const String userNameKey = 'user_name';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  // ---------- shared_preferences ----------
  Future<void> setIsLoggedIn(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(isLoggedInKey, value);
  }

  Future<bool> getIsLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getBool(isLoggedInKey) ?? false;
  }

  Future<void> setUserName(String value) async {
    final prefs = await _prefs;
    await prefs.setString(userNameKey, value);
  }

  Future<String?> getUserName() async {
    final prefs = await _prefs;
    return prefs.getString(userNameKey);
  }

  Future<void> clearNonSensitiveAuthData() async {
    final prefs = await _prefs;
    await prefs.remove(isLoggedInKey);
    await prefs.remove(userNameKey);
  }

  // ---------- flutter_secure_storage ----------
  Future<void> saveAuthToken(String token) async {
    try {
      await _secureStorage.write(key: _authTokenKey, value: token);
    } catch (e) {
      debugPrint('Warning: Failed to save auth token to secure storage: $e');
      // On web/desktop, secure storage might throw PlatformException
      // Fall back to regular SharedPreferences
      try {
        final prefs = await _prefs;
        await prefs.setString(_authTokenKey, token);
      } catch (fallbackError) {
        debugPrint('Error: Failed to save auth token to SharedPreferences: $fallbackError');
        rethrow;
      }
    }
  }

  Future<String?> getAuthToken() async {
    try {
      final token = await _secureStorage.read(key: _authTokenKey);
      if (token != null && token.isNotEmpty) {
        return token;
      }
    } catch (e) {
      debugPrint('Warning: Failed to retrieve auth token from secure storage: $e');
      // On web/desktop, secure storage might throw PlatformException
      // Fall back to regular SharedPreferences
    }

    // Fallback: try to get from regular SharedPreferences
    try {
      final prefs = await _prefs;
      return prefs.getString(_authTokenKey);
    } catch (e) {
      debugPrint('Error: Failed to retrieve auth token from SharedPreferences: $e');
      return null;
    }
  }

  Future<void> clearAuthToken() async {
    try {
      await _secureStorage.delete(key: _authTokenKey);
    } catch (e) {
      debugPrint('Warning: Failed to clear auth token from secure storage: $e');
    }

    // Also clear from SharedPreferences
    try {
      final prefs = await _prefs;
      await prefs.remove(_authTokenKey);
    } catch (e) {
      debugPrint('Error: Failed to clear auth token from SharedPreferences: $e');
    }
  }

  // Convenience for logout
  Future<void> clearAuthSession() async {
    await clearAuthToken();
    await clearNonSensitiveAuthData();
  }
}