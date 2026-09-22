import 'package:flutter_test/flutter_test.dart';
import 'package:nchito/core/network/api_url.dart';
import 'package:nchito/core/network/token_storage.dart';
import 'package:nchito/features/user/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nchito/features/user/auth/data/repositories/auth_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  Map<String, dynamic> nextLoginResponse = {};

  @override
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
    bool rememberMe = false,
  }) async {
    return nextLoginResponse;
  }

  @override
  Future<Map<String, dynamic>?> logout() async => null;

  @override
  Future<Map<String, dynamic>> register({
    required String identifier,
    required String fullName,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
    required bool ageConfirmed,
  }) async => {};

  @override
  Future<Map<String, dynamic>> requestPasswordResetOtp({
    required String identifier,
  }) async => {};

  @override
  Future<Map<String, dynamic>> resetPassword({
    required String identifier,
    required String verificationToken,
    required String newPassword,
    required String confirmPassword,
  }) async => {};

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String identifier,
    required String code,
  }) async => {};

  @override
  Future<Map<String, dynamic>> verifyPasswordResetOtp({
    required String identifier,
    required String code,
  }) async => {};
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Common Login & Role-Based Routing Tests', () {
    test('ApiUrl common auth endpoints', () {
      expect(ApiUrl.authLogin, '/auth/login/');
      expect(ApiUrl.commonLogin, '/auth/login/');
      expect(ApiUrl.login, '/auth/login/');
    });

    test('Common login with Customer role extracts customer role and persists tokens', () async {
      final fakeDataSource = FakeAuthRemoteDataSource();
      final repository = AuthRepositoryImpl(remoteDataSource: fakeDataSource);

      fakeDataSource.nextLoginResponse = {
        "success": true,
        "message": "Logged in successfully.",
        "data": {
          "user": {
            "id": "6aae24ddea04f420b202918e",
            "public_id": "a5547b6e-9a28-4a19-acf8-c14ee04ec701",
            "email": "customer333@yopmail.com",
            "phone": null,
            "full_name": "Customer",
            "role": "customer",
            "avatar": null,
            "gender": "",
            "date_of_birth": null,
            "bio": "",
            "is_email_verified": true,
            "is_phone_verified": false,
            "is_blocked": false,
            "blocked_reason": "",
            "age_confirmed": true,
            "preferred_language": "en",
            "provider_status": null,
            "created_at": "2026-09-19T07:59:57.389000+02:00"
          },
          "tokens": {
            "access": "customer_jwt_access_token",
            "refresh": "customer_jwt_refresh_token",
            "role": "customer"
          },
          "role": "customer",
          "api_prefix": "/api/v1/customer/"
        }
      };

      final (user, message) = await repository.login(
        identifier: 'customer333@yopmail.com',
        password: 'password123',
      );

      expect(user.id, '6aae24ddea04f420b202918e');
      expect(user.fullName, 'Customer');
      expect(user.role, 'customer');
      expect(message, 'Logged in successfully.');

      final storedToken = await TokenStorage.read();
      final storedRole = await TokenStorage.readRole();
      expect(storedToken, 'customer_jwt_access_token');
      expect(storedRole, 'customer');
    });

    test('Common login with Provider role extracts provider role and persists tokens', () async {
      final fakeDataSource = FakeAuthRemoteDataSource();
      final repository = AuthRepositoryImpl(remoteDataSource: fakeDataSource);

      fakeDataSource.nextLoginResponse = {
        "success": true,
        "message": "Logged in successfully.",
        "data": {
          "user": {
            "id": "provider_id_999",
            "public_id": "provider_pub_999",
            "email": "provider@yopmail.com",
            "full_name": "Provider Pro",
            "role": "provider",
            "is_email_verified": true,
            "is_phone_verified": true,
            "is_blocked": false,
            "age_confirmed": true,
          },
          "tokens": {
            "access": "provider_jwt_access_token",
            "refresh": "provider_jwt_refresh_token",
            "role": "provider"
          },
          "role": "provider",
          "api_prefix": "/api/v1/provider/"
        }
      };

      final (user, message) = await repository.login(
        identifier: 'provider@yopmail.com',
        password: 'password123',
      );

      expect(user.id, 'provider_id_999');
      expect(user.fullName, 'Provider Pro');
      expect(user.role, 'provider');
      expect(message, 'Logged in successfully.');

      final storedToken = await TokenStorage.read();
      final storedRole = await TokenStorage.readRole();
      expect(storedToken, 'provider_jwt_access_token');
      expect(storedRole, 'provider');
    });
  });
}
