import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/api_url.dart';

abstract class AuthRemoteDataSource {
  /// Returns the full response body — `{success, message, data}` — so the
  /// repository can surface the backend's own [message] on the snackbar
  /// instead of a hardcoded string.
  Future<Map<String, dynamic>> register({
    required String identifier,
    required String fullName,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
    required bool ageConfirmed,
  });

  /// Returns the full response body — `{success, message, data}}`, where
  /// `data` is `{'user': {...}, 'tokens': {'access': ..., 'refresh': ..., 'role': ...}}`.
  Future<Map<String, dynamic>> verifyOtp({
    required String identifier,
    required String code,
  });

  /// Logs in a user with credentials. Returns `{success, message, data}`.
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
    bool rememberMe = false,
  });

  /// Logs out a customer on the backend.
  Future<Map<String, dynamic>?> logout();

  /// Requests a password reset OTP for [identifier].
  Future<Map<String, dynamic>> requestPasswordResetOtp({
    required String identifier,
  });

  /// Verifies the password reset OTP for [identifier].
  Future<Map<String, dynamic>> verifyPasswordResetOtp({
    required String identifier,
    required String code,
  });

  /// Resets the user password with verification token.
  Future<Map<String, dynamic>> resetPassword({
    required String identifier,
    required String verificationToken,
    required String newPassword,
    required String confirmPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  @override
  Future<Map<String, dynamic>> register({
    required String identifier,
    required String fullName,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
    required bool ageConfirmed,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.customerRegister,
      data: {
        'identifier': identifier,
        'full_name': fullName,
        'password': password,
        'confirm_password': confirmPassword,
        'role': 'customer',
        'accept_terms': acceptTerms,
        'age_confirmed': ageConfirmed,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String identifier,
    required String code,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.customerOtpVerify,
      data: {'identifier': identifier, 'code': code},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
    bool rememberMe = false,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.customerLogin,
      data: {
        'identifier': identifier,
        'password': password,
        'remember_me': rememberMe,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>?> logout() async {
    try {
      final response = await _apiClient.post(ApiUrl.customerLogout);
      return response.data as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> requestPasswordResetOtp({
    required String identifier,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.customerOtpRequest,
      data: {'identifier': identifier},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> verifyPasswordResetOtp({
    required String identifier,
    required String code,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.customerOtpVerify,
      data: {'identifier': identifier, 'code': code},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> resetPassword({
    required String identifier,
    required String verificationToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.customerPasswordReset,
      data: {
        'identifier': identifier,
        'verification_token': verificationToken,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );
    return response.data as Map<String, dynamic>;
  }
}

