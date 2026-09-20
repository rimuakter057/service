import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login {
  const Login(this._repository);

  final AuthRepository _repository;

  Future<(User user, String message)> call({
    required String identifier,
    required String password,
    bool rememberMe = false,
  }) {
    return _repository.login(
      identifier: identifier,
      password: password,
      rememberMe: rememberMe,
    );
  }
}
