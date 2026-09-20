import '../repositories/auth_repository.dart';

class RequestPasswordResetOtp {
  const RequestPasswordResetOtp(this._repository);

  final AuthRepository _repository;

  Future<String> call({required String identifier}) {
    return _repository.requestPasswordResetOtp(identifier: identifier);
  }
}
