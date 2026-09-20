import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nchito/core/network/token_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('TokenStorage Persistence', () {
    test('save and read access token', () async {
      expect(await TokenStorage.read(), isNull);
      expect(await TokenStorage.hasToken(), isFalse);

      await TokenStorage.save('mock_access_token');
      expect(await TokenStorage.read(), 'mock_access_token');
      expect(await TokenStorage.hasToken(), isTrue);
    });

    test('saveTokens saves access token, refresh token and role', () async {
      await TokenStorage.saveTokens(
        accessToken: 'access_123',
        refreshToken: 'refresh_456',
        role: 'customer',
      );

      expect(await TokenStorage.read(), 'access_123');
      expect(await TokenStorage.readRefreshToken(), 'refresh_456');
      expect(await TokenStorage.readRole(), 'customer');
      expect(await TokenStorage.hasToken(), isTrue);
    });

    test('clear wipes all stored tokens and role', () async {
      await TokenStorage.saveTokens(
        accessToken: 'access_123',
        refreshToken: 'refresh_456',
        role: 'provider',
      );

      expect(await TokenStorage.hasToken(), isTrue);
      await TokenStorage.clear();

      expect(await TokenStorage.read(), isNull);
      expect(await TokenStorage.readRefreshToken(), isNull);
      expect(await TokenStorage.readRole(), isNull);
      expect(await TokenStorage.hasToken(), isFalse);
    });

    test('retained after restart simulation (mock initial values)', () async {
      // First session: token is saved
      SharedPreferences.setMockInitialValues({
        'auth_token': 'persisted_jwt_token',
        'refresh_token': 'persisted_refresh_token',
        'auth_role': 'provider',
      });

      // App restart simulation:
      expect(await TokenStorage.read(), 'persisted_jwt_token');
      expect(await TokenStorage.readRefreshToken(), 'persisted_refresh_token');
      expect(await TokenStorage.readRole(), 'provider');
      expect(await TokenStorage.hasToken(), isTrue);
    });
  });
}
