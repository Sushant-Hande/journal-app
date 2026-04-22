import 'package:flutter/widgets.dart';
import 'package:journal_app/data/repositories/auth_repository.dart';
import 'package:journal_app/network/api_status.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._authRepository);

  final AuthRepository _authRepository;

  ApiStatus _signupApiStatus = ApiStatus.initial;

  ApiStatus get signUpApiStatus => _signupApiStatus;

  ApiStatus _loginApiStatus = ApiStatus.initial;

  ApiStatus get loginApiStatus => _loginApiStatus;

  String? _signUpErrorMessage;

  String? get signUpErrorMessage => _signUpErrorMessage;

  String? _loginErrorMessage;

  String? get loginErrorMessage => _loginErrorMessage;

  bool get isSignUpApiLoading => _signupApiStatus == ApiStatus.loading;

  bool get isLoginApiLoading => _loginApiStatus == ApiStatus.loading;

  Future<bool> signUp({
    required String userName,
    required String password,
  }) async {
    _signupApiStatus = ApiStatus.loading;
    notifyListeners();
    _signUpErrorMessage = null;

    final result = await _authRepository.signUp(
      userName: userName,
      password: password,
    );

    if (result.isSuccess) {
      _signupApiStatus = ApiStatus.success;
      notifyListeners();
      return true;
    } else {
      _signupApiStatus = ApiStatus.error;
      _signUpErrorMessage = result.error?.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String userName,
    required String password,
  }) async {
    _loginApiStatus = ApiStatus.loading;
    notifyListeners();
    _loginErrorMessage = null;

    final result = await _authRepository.login(
      userName: userName,
      password: password,
    );

    if (result.isSuccess) {
      print('Received token: ${result.data}');
      _loginApiStatus = ApiStatus.success;
      notifyListeners();
      return true;
    } else {
      _loginApiStatus = ApiStatus.error;
      _loginErrorMessage = result.error?.message;
      notifyListeners();
      return false;
    }
  }
}
