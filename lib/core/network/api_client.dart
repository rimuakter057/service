import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import 'interceptors/api_logger_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'network_info.dart';

class ApiClient {
  ApiClient._internal({NetworkInfo? networkInfo})
    : _networkInfo = networkInfo ?? NetworkInfoImpl() {
    _dio.options
      ..baseUrl = ApiConstants.baseUrl
      ..connectTimeout = ApiConstants.connectTimeout
      ..receiveTimeout = ApiConstants.receiveTimeout
      ..sendTimeout = ApiConstants.sendTimeout
      ..headers = {'Content-Type': 'application/json'};

    _dio.interceptors.addAll([
      ApiLoggerInterceptor(),
      RetryInterceptor(_dio),
    ]);
  }

  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  final Dio _dio = Dio();
  final NetworkInfo _networkInfo;

  Dio get dio => _dio;


  void setAuthToken(String? token) {
    if (token == null) {
      _dio.options.headers.remove('Authorization');
    } else {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _guard(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _guard(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _guard(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _guard(
      () => _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _guard(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }


  Future<Response<dynamic>> upload(
    String path, {
    required FormData formData,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) {
    return _guard(
      () => _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<dynamic>> _guard(
    Future<Response<dynamic>> Function() request,
  ) async {
    if (!await _networkInfo.isConnected) {
      throw const NoInternetException(
        'No internet connection. Please check your network and try again.',
      );
    }

    try {
      return await request();
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    }
  }
}
