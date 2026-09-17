import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// App-wide console logger. Used by [ApiLoggerInterceptor] to print every
/// request/response/error, but any layer (provider, repository, use case)
/// can use it too instead of raw `print()`.
///
/// Every call is a no-op in release builds, so nothing leaks into
/// production logs and there is no need to strip calls before shipping.
class AppLogger {
  const AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 6,
      lineLength: 100,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void d(String message) {
    if (kDebugMode) _logger.d(message);
  }

  static void i(String message) {
    if (kDebugMode) _logger.i(message);
  }

  static void w(String message) {
    if (kDebugMode) _logger.w(message);
  }

  static void e(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }
}
