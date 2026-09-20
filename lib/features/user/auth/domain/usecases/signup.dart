import '../repositories/auth_repository.dart';

class SignUp {
  const SignUp(this._repository);

  final AuthRepository _repository;

  Future<String> call({
    required String identifier,
    required String fullName,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
    required bool ageConfirmed,
  }) {
    return _repository.register(
      identifier: identifier,
      fullName: fullName,
      password: password,
      confirmPassword: confirmPassword,
      acceptTerms: acceptTerms,
      ageConfirmed: ageConfirmed,
    );
  }
}
