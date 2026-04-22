import 'package:journal_app/data/services/auth_api_service.dart';
import 'package:journal_app/network/api_result.dart';

class AuthRepository {
  AuthRepository(this._authService);

  final AuthApiService _authService;

  Future<ApiResult<bool>> signUp({
    required String userName,
    required String password,
  }) {
    return _authService.signUp(userName: userName, password: password);
  }

  Future<ApiResult<String>> login({
    required String userName,
    required String password,
  }) {
    return _authService.login(userName: userName, password: password);
  }
}
