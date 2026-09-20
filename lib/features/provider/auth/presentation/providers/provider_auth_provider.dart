import 'package:flutter/foundation.dart';
import 'package:nchito/core/errors/failures.dart';
import 'package:nchito/features/user/auth/domain/entities/user.dart';

import '../../data/repositories/provider_auth_repository_impl.dart';
import '../../domain/repositories/provider_auth_repository.dart';

enum ProviderAuthStatus { idle, loading, success, error }

/// Drives the provider auth screens (login, signup, OTP-verification, KYC, forgot password).
class ProviderAuthProvider extends ChangeNotifier {
  ProviderAuthProvider({ProviderAuthRepository? repository})
      : _repository = repository ?? ProviderAuthRepositoryImpl();

  final ProviderAuthRepository _repository;

  ProviderAuthStatus _status = ProviderAuthStatus.idle;
  ProviderAuthStatus get status => _status;
  bool get isLoading => _status == ProviderAuthStatus.loading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

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
    _status = ProviderAuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _successMessage = await _repository.register(
        identifier: identifier,
        fullName: fullName,
        password: password,
        confirmPassword: confirmPassword,
        acceptTerms: acceptTerms,
        ageConfirmed: true,
      );
      _status = ProviderAuthStatus.success;
      notifyListeners();
      return true;
    } on Failure catch (failure) {
      _status = ProviderAuthStatus.error;
      _errorMessage = failure.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyRegistrationOtp({
    required String identifier,
    required String code,
  }) async {
    _status = ProviderAuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final (user, message) = await _repository.verifyOtp(
        identifier: identifier,
        code: code,
      );
      _user = user;
      _successMessage = message;
      _status = ProviderAuthStatus.success;
      notifyListeners();
      return true;
    } on Failure catch (failure) {
      _status = ProviderAuthStatus.error;
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
    _status = ProviderAuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final (user, message) = await _repository.login(
        identifier: identifier,
        password: password,
        rememberMe: rememberMe,
      );
      _user = user;
      _successMessage = message;
      _status = ProviderAuthStatus.success;
      notifyListeners();
      return true;
    } on Failure catch (failure) {
      _status = ProviderAuthStatus.error;
      _errorMessage = failure.message;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } catch (_) {
    } finally {
      _user = null;
      _status = ProviderAuthStatus.idle;
      _errorMessage = null;
      _successMessage = null;
      notifyListeners();
    }
  }

  Future<bool> requestPasswordResetOtp({required String identifier}) async {
    _status = ProviderAuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _successMessage =
          await _repository.requestPasswordResetOtp(identifier: identifier);
      _status = ProviderAuthStatus.success;
      notifyListeners();
      return true;
    } on Failure catch (failure) {
      _status = ProviderAuthStatus.error;
      _errorMessage = failure.message;
      notifyListeners();
      return false;
    }
  }

  Future<String?> verifyPasswordResetOtp({
    required String identifier,
    required String code,
  }) async {
    _status = ProviderAuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final (token, message) = await _repository.verifyPasswordResetOtp(
        identifier: identifier,
        code: code,
      );
      _successMessage = message;
      _status = ProviderAuthStatus.success;
      notifyListeners();
      return token;
    } on Failure catch (failure) {
      _status = ProviderAuthStatus.error;
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
    _status = ProviderAuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _successMessage = await _repository.resetPassword(
        identifier: identifier,
        verificationToken: verificationToken,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      _status = ProviderAuthStatus.success;
      notifyListeners();
      return true;
    } on Failure catch (failure) {
      _status = ProviderAuthStatus.error;
      _errorMessage = failure.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitIdentityDocuments({
    required String documentType,
    required List<String> filePaths,
  }) async {
    _status = ProviderAuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _successMessage = await _repository.submitIdentityDocuments(
        documentType: documentType,
        filePaths: filePaths,
      );
      _status = ProviderAuthStatus.success;
      notifyListeners();
      return true;
    } on Failure catch (failure) {
      _status = ProviderAuthStatus.error;
      _errorMessage = failure.message;
      notifyListeners();
      return false;
    }
  }
}
