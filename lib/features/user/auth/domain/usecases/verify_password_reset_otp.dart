import '../repositories/auth_repository.dart';

class VerifyPasswordResetOtp {
  const VerifyPasswordResetOtp(this._repository);

  final AuthRepository _repository;

  Future<(String verificationToken, String message)> call({
    required String identifier,
    required String code,
  }) {
    return _repository.verifyPasswordResetOtp(
      identifier: identifier,
      code: code,
    );
  }
}
