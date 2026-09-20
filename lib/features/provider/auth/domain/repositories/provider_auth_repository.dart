import 'package:nchito/features/user/auth/domain/entities/user.dart';

abstract class ProviderAuthRepository {
  /// Creates a provider account.
  Future<String> register({
    required String identifier,
    required String fullName,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
    required bool ageConfirmed,
  });

  /// Confirms provider registration OTP.
  Future<(User user, String message)> verifyOtp({
    required String identifier,
    required String code,
  });

  /// Logs in a provider with identifier and password.
  Future<(User user, String message)> login({
    required String identifier,
    required String password,
    bool rememberMe = false,
  });

  /// Clears persisted tokens and logs out on backend.
  Future<void> logout();

  /// Requests a password reset OTP for provider.
  Future<String> requestPasswordResetOtp({required String identifier});

  /// Verifies password reset OTP for provider.
  Future<(String verificationToken, String message)> verifyPasswordResetOtp({
    required String identifier,
    required String code,
  });

  /// Resets provider password using verification token.
  Future<String> resetPassword({
    required String identifier,
    required String verificationToken,
    required String newPassword,
    required String confirmPassword,
  });

  /// Submits provider KYC identity documents.
  Future<String> submitIdentityDocuments({
    required String documentType,
    required List<String> filePaths,
  });
}
