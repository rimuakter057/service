import 'package:dio/dio.dart';

import '../../utils/logger/app_logger.dart';
import '../api_url.dart';
import '../session_events.dart';
import '../token_storage.dart';

/// On a 401 (expired access token), transparently swaps in a fresh access
/// token using the stored refresh token and retries the original request —
/// so a logged-in user is never bounced to the login screen just because
/// their access token expired while the app was open.
///
/// If the refresh token itself is invalid/expired (HTTP 401/403), the session really is
/// over: tokens are cleared and [SessionEvents.notifySessionExpired] fires
/// so the app can send the user back to login.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio);

  final Dio _dio;

  /// Coalesces concurrent 401s (e.g. several requests in flight at once)
  /// into a single refresh call instead of racing multiple refreshes.
  Future<String?>? _refreshFuture;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldAttemptRefresh(err)) {
      handler.next(err);
      return;
    }

    final newAccessToken = await (_refreshFuture ??= _refreshAccessToken());
    _refreshFuture = null;

    if (newAccessToken == null) {
      // If unauthorized and refresh failed, check if it was rejected by the server
      final isDefiniteAuthFailure = err.response?.statusCode == 401;
      if (isDefiniteAuthFailure) {
        await TokenStorage.clear();
        _dio.options.headers.remove('Authorization');
        SessionEvents.notifySessionExpired();
      }
      handler.next(err);
      return;
    }

    try {
      final retryOptions = err.requestOptions
        ..headers['Authorization'] = 'Bearer $newAccessToken';
      final response = await _dio.fetch<dynamic>(retryOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _shouldAttemptRefresh(DioException err) {
    final isUnauthorized = err.response?.statusCode == 401;
    final path = err.requestOptions.path;
    final isRefreshCallItself =
        path == ApiUrl.customerTokenRefresh ||
        path == ApiUrl.providerTokenRefresh;
    final wasAuthenticated = err.requestOptions.headers.containsKey(
      'Authorization',
    );
    return isUnauthorized && !isRefreshCallItself && wasAuthenticated;
  }

  /// Uses a bare [Dio] (no interceptors) so this call can never recurse
  /// back into [onError] or get caught up in [RetryInterceptor].
  Future<String?> _refreshAccessToken() async {
    final refreshToken = await TokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.trim().isEmpty) return null;

    final role = await TokenStorage.readRole() ?? 'customer';
    final refreshPath = role.toLowerCase() == 'provider'
        ? ApiUrl.providerTokenRefresh
        : ApiUrl.customerTokenRefresh;

    try {
      final response = await Dio(
        BaseOptions(baseUrl: _dio.options.baseUrl),
      ).post(refreshPath, data: {'refresh': refreshToken});

      final dynamic body = response.data;
      String? newAccessToken;

      if (body is Map<String, dynamic>) {
        if (body['data'] is String) {
          newAccessToken = body['data'] as String;
        } else if (body['data'] is Map<String, dynamic>) {
          final dataMap = body['data'] as Map<String, dynamic>;
          newAccessToken = dataMap['access']?.toString() ??
              dataMap['access_token']?.toString() ??
              dataMap['token']?.toString() ??
              (dataMap['tokens'] is Map ? dataMap['tokens']['access']?.toString() : null);
        } else {
          newAccessToken = body['access']?.toString() ??
              body['access_token']?.toString() ??
              body['token']?.toString();
        }

        // Check if rotated refresh token was returned
        final newRefreshToken = (body['data'] is Map
                ? (body['data'] as Map<String, dynamic>)['refresh']?.toString()
                : null) ??
            body['refresh']?.toString();
        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          await TokenStorage.saveRefreshToken(newRefreshToken);
        }
      }

      if (newAccessToken == null || newAccessToken.isEmpty) return null;

      _dio.options.headers['Authorization'] = 'Bearer $newAccessToken';
      await TokenStorage.save(newAccessToken);
      AppLogger.i('AuthInterceptor: Access token refreshed ($role)');
      return newAccessToken;
    } catch (e) {
      AppLogger.w('AuthInterceptor: Token refresh failed: $e');
      return null;
    }
  }
}
