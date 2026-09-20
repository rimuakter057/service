import '../entities/user.dart';

abstract class AuthRepository {
  /// Creates a customer account.
  Future<String> register({
    required String identifier,
    required String fullName,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
    required bool ageConfirmed,
  });

  /// Confirms the registration OTP.
  Future<(User user, String message)> verifyOtp({
    required String identifier,
    required String code,
  });

  /// Logs in a customer with identifier and password.
  Future<(User user, String message)> login({
    required String identifier,
    required String password,
    bool rememberMe = false,
  });

  /// Clears persisted tokens and resets auth session on client and backend.
  Future<void> logout();

  /// Requests a password reset OTP for [identifier].
  Future<String> requestPasswordResetOtp({required String identifier});

  /// Verifies password reset OTP.
  Future<(String verificationToken, String message)> verifyPasswordResetOtp({
    required String identifier,
    required String code,
  });

  /// Resets password using verification token.
  Future<String> resetPassword({
    required String identifier,
    required String verificationToken,
    required String newPassword,
    required String confirmPassword,
  });
}
