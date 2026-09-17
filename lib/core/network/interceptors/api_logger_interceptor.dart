import 'package:dio/dio.dart';

import '../../utils/logger/app_logger.dart';

class ApiLoggerInterceptor extends Interceptor {
  static const _startTimeKey = 'x-request-start-time';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.extra[_startTimeKey] = DateTime.now();

    AppLogger.i(
      'REQUEST [${options.method}] ${options.uri}\n'
      'Headers: ${options.headers}\n'
      'Query: ${options.queryParameters}\n'
      'Body: ${_safeBody(options.data)}',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.i(
      'RESPONSE [${response.statusCode}] ${response.requestOptions.uri} '
      '(${_elapsedMs(response.requestOptions)}ms)\n'
      'Data: ${_safeBody(response.data)}',
    );
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    AppLogger.e(
      'ERROR [${err.response?.statusCode ?? err.type}] '
      '${err.requestOptions.uri} (${_elapsedMs(err.requestOptions)}ms)\n'
      'Message: ${err.message}\n'
      'Response: ${_safeBody(err.response?.data)}',
      err,
      err.stackTrace,
    );
    handler.next(err);
  }

  int? _elapsedMs(RequestOptions options) {
    final start = options.extra[_startTimeKey] as DateTime?;
    if (start == null) return null;
    return DateTime.now().difference(start).inMilliseconds;
  }

  /// Keeps huge payloads (file uploads, long lists) from flooding the
  /// console — logs are for spotting integration issues, not dumping data.
  String _safeBody(dynamic data) {
    if (data == null) return 'null';
    final text = data.toString();
    const maxLength = 2000;
    return text.length > maxLength
        ? '${text.substring(0, maxLength)}… (truncated)'
        : text;
  }
}
