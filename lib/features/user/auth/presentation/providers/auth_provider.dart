import 'package:flutter/foundation.dart';

import 'package:nchito/core/errors/failures.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/request_password_reset_otp.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/signup.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../domain/usecases/verify_password_reset_otp.dart';

enum AuthStatus { idle, loading, success, error }

/// Drives the customer auth screens (login, signup, OTP-verification, forgot password).
/// Screens read [isLoading]/[errorMessage] to render themselves and call
/// auth methods in response to user actions.
class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthRepository? repository})
    : _signUp = SignUp(repository ?? AuthRepositoryImpl()),
      _verifyOtp = VerifyOtp(repository ?? AuthRepositoryImpl()),
      _login = Login(repository ?? AuthRepositoryImpl()),
      _logout = Logout(repository ?? AuthRepositoryImpl()),
      _requestPasswordResetOtp =
          RequestPasswordResetOtp(repository ?? AuthRepositoryImpl()),
      _verifyPasswordResetOtp =
          VerifyPasswordResetOtp(repository ?? AuthRepositoryImpl()),
      _resetPassword = ResetPassword(repository ?? AuthRepositoryImpl());

  final SignUp _signUp;
  final VerifyOtp _verifyOtp;
  final Login _login;
  final Logout _logout;
  final RequestPasswordResetOtp _requestPasswordResetOtp;
  final VerifyPasswordResetOtp _verifyPasswordResetOtp;
  final ResetPassword _resetPassword;

  AuthStatus _status = AuthStatus.idle;
  AuthStatus get status => _status;
  bool get isLoading => _status == AuthStatus.loading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// The backend's own success message for the last completed action —
  /// screens show this verbatim on the success snackbar instead of
  /// inventing their own text.
  String? _successMessage;
  String? get successMessage => _successMessage;

  User? _user;
  User? get user => _user;

  Future<bool> register({
    required String identifier,
    required String fullName,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _successMessage = await _signUp(
        identifier: identifier,
        fullName: fullName,
        password: password,
        confirmPassword: confirmPassword,
        acceptTerms: acceptTerms,
        ageConfirmed: true,
      );
      _status = AuthStatus.success;
      notifyListeners();
      return true;
    } on Failure catch (failure) {
      _status = AuthStatus.error;
      _errorMessage = failure.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyRegistrationOtp({
    required String identifier,
    required String code,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final (user, message) = await _verifyOtp(
        identifier: identifier,
        code: code,
      );
      _user = user;
      _successMessage = message;
      _status = AuthStatus.success;
      notifyListeners();
      return true;
    } on Failure catch (failure) {
      _status = AuthStatus.error;
      _errorMessage = failure.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String identifier,
    required String password,
    bool rememberMe = false,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final (user, message) = await _login(
        identifier: identifier,
        password: password,
        rememberMe: rememberMe,
      );
      _user = user;
      _successMessage = message;
      _status = AuthStatus.success;
      notifyListeners();
      return true;
    } on Failure catch (failure) {
      _status = AuthStatus.error;
      _errorMessage = failure.message;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _logout();
    } catch (_) {
    } finally {
      _user = null;
      _status = AuthStatus.idle;
      _errorMessage = null;
      _successMessage = null;
      notifyListeners();
    }
  }

  Future<bool> requestPasswordResetOtp({required String identifier}) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _successMessage = await _requestPasswordResetOtp(identifier: identifier);
      _status = AuthStatus.success;
      notifyListeners();
      return true;
    } on Failure catch (failure) {
      _status = AuthStatus.error;
      _errorMessage = failure.message;
      notifyListeners();
      return false;
    }
  }

  Future<String?> verifyPasswordResetOtp({
    required String identifier,
    required String code,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final (token, message) = await _verifyPasswordResetOtp(
        identifier: identifier,
        code: code,
      );
      _successMessage = message;
      _status = AuthStatus.success;
      notifyListeners();
      return token;
    } on Failure catch (failure) {
      _status = AuthStatus.error;
      _errorMessage = failure.message;
      notifyListeners();
      return null;
    }
  }

  Future<bool> resetPassword({
    required String identifier,
    required String verificationToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _successMessage = await _resetPassword(
        identifier: identifier,
        verificationToken: verificationToken,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      _status = AuthStatus.success;
      notifyListeners();
      return true;
    } on Failure catch (failure) {
      _status = AuthStatus.error;
      _errorMessage = failure.message;
      notifyListeners();
      return false;
    }
  }
}
