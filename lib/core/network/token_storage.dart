import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger/app_logger.dart';

/// Persists the auth token, refresh token, and user role on-device (SharedPreferences)
/// so [ApiClient] can restore it on app start without asking the user to log in again.
class TokenStorage {
  const TokenStorage._();

  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _roleKey = 'auth_role';

  /// Reads the stored access token
  static Future<String?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token;
  }

  /// Saves the access token
  static Future<void> save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    AppLogger.i('TokenStorage: Access token saved to SharedPreferences');
  }

  /// Saves all auth tokens and role together atomically
  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    String? role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await prefs.setString(_refreshTokenKey, refreshToken);
    }
    if (role != null && role.isNotEmpty) {
      await prefs.setString(_roleKey, role);
    }
    AppLogger.i('TokenStorage: Tokens and role ($role) successfully saved');
  }

  /// Checks if an active token exists
  static Future<bool> hasToken() async {
    final token = await read();
    return token != null && token.trim().isNotEmpty;
  }

  /// Clears all authentication credentials from SharedPreferences
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_roleKey);
    AppLogger.i('TokenStorage: All auth credentials cleared from SharedPreferences');
  }

  /// Reads the refresh token
  static Future<String?> readRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// Saves the refresh token
  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
    AppLogger.i('TokenStorage: Refresh token saved to SharedPreferences');
  }

  /// Reads the user's role ('customer' or 'provider')
  static Future<String?> readRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  /// Saves the user's role ('customer' or 'provider')
  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
    AppLogger.i('TokenStorage: Role ($role) saved to SharedPreferences');
  }
}
