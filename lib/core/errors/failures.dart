import 'exceptions.dart';

sealed class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;

  factory Failure.fromException(AppException exception) {
    return switch (exception) {
      BadRequestException() => ValidationFailure(exception.message),
      ValidationException() => ValidationFailure(
        exception.message,
        fieldErrors: exception.fieldErrors,
      ),
      UnauthorizedException() => AuthFailure(exception.message),
      ForbiddenException() => PermissionFailure(exception.message),
      NotFoundException() => NotFoundFailure(exception.message),
      ConflictException() => ConflictFailure(exception.message),
      TimeoutException() => NetworkFailure(exception.message),
      NoInternetException() => NetworkFailure(exception.message),
      RequestCancelledException() => NetworkFailure(exception.message),
      ServerException() => ServerFailure(exception.message),
      CacheException() => CacheFailure(exception.message),
      UnknownException() => UnknownFailure(exception.message),
    };
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure(super.message, {this.fieldErrors});
}

class ConflictFailure extends Failure {
  const ConflictFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}