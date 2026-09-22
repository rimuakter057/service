import 'package:nchito/core/errors/exceptions.dart';
import 'package:nchito/core/errors/failures.dart';
import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/token_storage.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource, ApiClient? apiClient})
    : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSourceImpl(),
      _apiClient = apiClient ?? ApiClient();

  final AuthRemoteDataSource _remoteDataSource;
  final ApiClient _apiClient;

  @override
  Future<String> register({
    required String identifier,
    required String fullName,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
    required bool ageConfirmed,
  }) async {
    try {
      final response = await _remoteDataSource.register(
        identifier: identifier,
        fullName: fullName,
        password: password,
        confirmPassword: confirmPassword,
        acceptTerms: acceptTerms,
        ageConfirmed: ageConfirmed,
      );
      return response['message'] as String? ?? 'Registration successful.';
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Something went wrong. Please try again.');
    }
  }

  @override
  Future<(User user, String message)> verifyOtp({
    required String identifier,
    required String code,
  }) async {
    try {
      final response = await _remoteDataSource.verifyOtp(
        identifier: identifier,
        code: code,
      );

      await _extractTokensAndSave(response, defaultRole: 'customer');

      final user = _extractUser(response, identifier, 'customer');
      await TokenStorage.saveRole(user.role.isNotEmpty ? user.role : 'customer');
      final message = response['message'] as String? ?? 'Verified successfully.';
      return (user, message);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Something went wrong. Please try again.');
    }
  }

  @override
  Future<(User user, String message)> login({
    required String identifier,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        identifier: identifier,
        password: password,
        rememberMe: rememberMe,
      );

      // Detect dynamic role from response ('customer' or 'provider')
      String detectedRole = 'customer';
      final dataMap = response['data'];
      if (dataMap is Map<String, dynamic>) {
        if (dataMap['role'] != null && dataMap['role'].toString().isNotEmpty) {
          detectedRole = dataMap['role'].toString();
        } else if (dataMap['tokens'] is Map<String, dynamic> &&
            dataMap['tokens']['role'] != null &&
            dataMap['tokens']['role'].toString().isNotEmpty) {
          detectedRole = dataMap['tokens']['role'].toString();
        } else if (dataMap['user'] is Map<String, dynamic> &&
            dataMap['user']['role'] != null &&
            dataMap['user']['role'].toString().isNotEmpty) {
          detectedRole = dataMap['user']['role'].toString();
        }
      } else if (response['role'] != null && response['role'].toString().isNotEmpty) {
        detectedRole = response['role'].toString();
      }

      await _extractTokensAndSave(response, defaultRole: detectedRole);

      final user = _extractUser(response, identifier, detectedRole);
      final finalRole = user.role.isNotEmpty ? user.role : detectedRole;
      await TokenStorage.saveRole(finalRole);
      final message = response['message'] as String? ?? 'Logged in successfully.';
      return (user, message);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Something went wrong. Please try again.');
    }
  }

  Future<void> _extractTokensAndSave(
    dynamic response, {
    required String defaultRole,
  }) async {
    if (response == null) return;

    Map<String, dynamic>? dataMap;
    if (response is Map<String, dynamic>) {
      if (response['data'] is Map<String, dynamic>) {
        dataMap = response['data'] as Map<String, dynamic>;
      } else {
        dataMap = response;
      }
    }

    String? accessToken;
    String? refreshToken;

    // 1. Check nested 'tokens'
    final tokensObj = dataMap?['tokens'] ??
        (response is Map ? response['tokens'] : null);
    if (tokensObj is Map<String, dynamic>) {
      accessToken = tokensObj['access']?.toString() ??
          tokensObj['access_token']?.toString() ??
          tokensObj['token']?.toString();
      refreshToken = tokensObj['refresh']?.toString() ??
          tokensObj['refresh_token']?.toString();
    }

    // 2. Check direct keys
    accessToken ??= dataMap?['access']?.toString() ??
        dataMap?['access_token']?.toString() ??
        dataMap?['token']?.toString() ??
        (response is Map ? response['access']?.toString() : null) ??
        (response is Map ? response['access_token']?.toString() : null) ??
        (response is Map ? response['token']?.toString() : null);

    refreshToken ??= dataMap?['refresh']?.toString() ??
        dataMap?['refresh_token']?.toString() ??
        (response is Map ? response['refresh']?.toString() : null) ??
        (response is Map ? response['refresh_token']?.toString() : null);

    if (accessToken != null && accessToken.isNotEmpty) {
      await _apiClient.setAuthToken(accessToken);
      await TokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        role: defaultRole,
      );
    }
  }

  UserModel _extractUser(
    dynamic response,
    String identifier,
    String defaultRole,
  ) {
    Map<String, dynamic>? userMap;
    if (response is Map<String, dynamic>) {
      if (response['data'] is Map<String, dynamic> &&
          response['data']['user'] is Map<String, dynamic>) {
        userMap = response['data']['user'] as Map<String, dynamic>;
      } else if (response['user'] is Map<String, dynamic>) {
        userMap = response['user'] as Map<String, dynamic>;
      } else if (response['data'] is Map<String, dynamic>) {
        userMap = response['data'] as Map<String, dynamic>;
      }
    }

    if (userMap != null) {
      try {
        return UserModel.fromJson(userMap);
      } catch (_) {}
    }

    return UserModel(
      id: '',
      publicId: '',
      fullName: identifier,
      role: defaultRole,
      isEmailVerified: true,
      isPhoneVerified: false,
      isBlocked: false,
      ageConfirmed: true,
    );
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
      await _apiClient.setAuthToken(null);
      await TokenStorage.clear();
    } catch (e) {
      throw UnknownFailure('Failed to log out cleanly.');
    }
  }

  @override
  Future<String> requestPasswordResetOtp({required String identifier}) async {
    try {
      final response = await _remoteDataSource.requestPasswordResetOtp(
        identifier: identifier,
      );
      return response['message'] as String? ??
          'Verification code sent successfully.';
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Something went wrong. Please try again.');
    }
  }

  @override
  Future<(String verificationToken, String message)> verifyPasswordResetOtp({
    required String identifier,
    required String code,
  }) async {
    try {
      final response = await _remoteDataSource.verifyPasswordResetOtp(
        identifier: identifier,
        code: code,
      );
      final data = response['data'] as Map<String, dynamic>?;
      final tokens = data?['tokens'] as Map<String, dynamic>?;
      final token = data?['verification_token'] as String? ??
          data?['token'] as String? ??
          tokens?['access'] as String? ??
          '';
      final message =
          response['message'] as String? ?? 'OTP verified successfully.';
      return (token, message);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Something went wrong. Please try again.');
    }
  }

  @override
  Future<String> resetPassword({
    required String identifier,
    required String verificationToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _remoteDataSource.resetPassword(
        identifier: identifier,
        verificationToken: verificationToken,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return response['message'] as String? ?? 'Password reset successfully.';
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Something went wrong. Please try again.');
    }
  }
}
