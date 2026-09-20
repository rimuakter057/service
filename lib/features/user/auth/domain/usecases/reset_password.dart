import '../repositories/auth_repository.dart';

class ResetPassword {
  const ResetPassword(this._repository);

  final AuthRepository _repository;

  Future<String> call({
    required String identifier,
    required String verificationToken,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _repository.resetPassword(
      identifier: identifier,
      verificationToken: verificationToken,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
