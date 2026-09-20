import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class VerifyOtp {
  const VerifyOtp(this._repository);

  final AuthRepository _repository;

  Future<(User user, String message)> call({
    required String identifier,
    required String code,
  }) {
    return _repository.verifyOtp(
      identifier: identifier,
      code: code,
    );
  }
}
