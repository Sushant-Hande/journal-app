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
    await _secureStorage.write(key: _authTokenKey, value: token);
  }

  Future<String?> getAuthToken() async {
    return _secureStorage.read(key: _authTokenKey);
  }

  Future<void> clearAuthToken() async {
    await _secureStorage.delete(key: _authTokenKey);
  }

  // Convenience for logout
  Future<void> clearAuthSession() async {
    await clearAuthToken();
    await clearNonSensitiveAuthData();
  }
}