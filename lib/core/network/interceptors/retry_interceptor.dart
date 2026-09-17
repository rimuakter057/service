import 'package:dio/dio.dart';

import '../../utils/logger/app_logger.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor(
    this._dio, {
    this.maxRetries = 2,
    this.retryDelay = const Duration(seconds: 1),
  });

  static const _retryCountKey = 'x-retry-count';

  final Dio _dio;
  final int maxRetries;
  final Duration retryDelay;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final retryCount = (options.extra[_retryCountKey] as int?) ?? 0;

    if (!_isRetryable(err) || retryCount >= maxRetries) {
      handler.next(err);
      return;
    }

    final nextAttempt = retryCount + 1;
    options.extra[_retryCountKey] = nextAttempt;

    AppLogger.w(
      'RETRY [$nextAttempt/$maxRetries] ${options.uri} '
      'after ${err.type}',
    );
    await Future.delayed(retryDelay * nextAttempt);

    try {
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _isRetryable(DioException err) {
    final isGet = err.requestOptions.method.toUpperCase() == 'GET';
    final isTransient = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => true,
      _ => false,
    };
    return isGet && isTransient;
  }
}
