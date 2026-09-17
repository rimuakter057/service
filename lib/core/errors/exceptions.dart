import 'package:dio/dio.dart';

sealed class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => message;

  factory AppException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutException(
          'The connection timed out. Please try again.',
        );

      case DioExceptionType.connectionError:
        return const NoInternetException(
          'No internet connection. Please check your network and try again.',
        );

      case DioExceptionType.cancel:
        return const RequestCancelledException('Request was cancelled.');

      case DioExceptionType.badCertificate:
        return const ServerException(
          'A secure connection could not be established.',
        );

      case DioExceptionType.badResponse:
        return AppException._fromStatusCode(
          error.response?.statusCode,
          _extractMessage(error.response?.data),
        );

      case DioExceptionType.unknown:
        return const UnknownException(
          'Something went wrong. Please try again.',
        );
    }
  }

  static AppException _fromStatusCode(int? statusCode, String? serverMessage) {
    final isServerError = statusCode != null && statusCode >= 500;
    final message =
        (isServerError ? null : serverMessage) ?? _defaultMessageFor(statusCode);

    switch (statusCode) {
      case 400:
        return BadRequestException(message);
      case 401:
        return UnauthorizedException(message);
      case 403:
        return ForbiddenException(message);
      case 404:
        return NotFoundException(message);
      case 409:
        return ConflictException(message);
      case 422:
        return ValidationException(message);
      default:
        if (isServerError) {
          return ServerException(message, statusCode: statusCode);
        }
        return UnknownException(message, statusCode: statusCode);
    }
  }

  static String _defaultMessageFor(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Your session has expired. Please log in again.';
      case 403:
        return 'You do not have permission to do that.';
      case 404:
        return 'The requested resource was not found.';
      case 409:
        return 'This request conflicts with existing data.';
      case 422:
        return 'Some fields are invalid. Please review and try again.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. The server is unreachable right now.';
      case 503:
        return 'The service is temporarily unavailable. Please try again later.';
      case 504:
        return 'The server took too long to respond. Please try again.';
      default:
        if (statusCode != null && statusCode >= 500) {
          return 'A server error occurred. Please try again later.';
        }
        return 'Something went wrong. Please try again.';
    }
  }

  static String? _extractMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final value = responseData['message'] ?? responseData['error'];
      if (value is String && value.trim().isNotEmpty) return value;
    }
    return null;
  }
}

class BadRequestException extends AppException {
  const BadRequestException(super.message) : super(statusCode: 400);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message) : super(statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException(super.message) : super(statusCode: 403);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message) : super(statusCode: 404);
}

class ConflictException extends AppException {
  const ConflictException(super.message) : super(statusCode: 409);
}

/// Thrown on HTTP 422, optionally carrying per-field validation errors
/// (e.g. `{"email": ["already taken"]}`) so forms can highlight them.
class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException(super.message, {this.fieldErrors})
      : super(statusCode: 422);
}

class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}

class TimeoutException extends AppException {
  const TimeoutException(super.message);
}

class NoInternetException extends AppException {
  const NoInternetException(super.message);
}

class RequestCancelledException extends AppException {
  const RequestCancelledException(super.message);
}

class CacheException extends AppException {
  const CacheException(super.message);
}

class UnknownException extends AppException {
  const UnknownException(super.message, {super.statusCode});
}