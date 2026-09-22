import 'package:flutter_test/flutter_test.dart';
import 'package:nchito/core/network/api_url.dart';

void main() {
  group('ApiUrl separated endpoints', () {
    test('Customer endpoints are defined correctly', () {
      expect(ApiUrl.customerRegister, '/customer/auth/register/');
      expect(ApiUrl.customerLogin, '/customer/auth/login/');
      expect(ApiUrl.customerOtpRequest, '/customer/auth/otp/request/');
      expect(ApiUrl.customerOtpVerify, '/customer/auth/otp/verify/');
      expect(ApiUrl.customerPasswordReset, '/customer/auth/password/reset/');
      expect(ApiUrl.customerPasswordChange, '/customer/auth/password/change/');
      expect(ApiUrl.customerTokenRefresh, '/customer/auth/token/refresh/');
      expect(ApiUrl.customerTokenVerify, '/customer/auth/token/verify/');
      expect(ApiUrl.customerLogout, '/customer/auth/logout/');
      expect(ApiUrl.customerMe, '/customer/auth/me/');
      expect(ApiUrl.customerDeletionStatus, '/customer/auth/me/deletion-status/');
      expect(ApiUrl.customerRoles, '/customer/auth/roles/');
      expect(ApiUrl.customerProviders, '/customer/providers/');
      expect(ApiUrl.customerProviderDetails('123'), '/customer/providers/123/');
      expect(
        ApiUrl.customerProviderDayAvailability('123'),
        '/customer/providers/123/availability/day/',
      );
      expect(
        ApiUrl.customerProviderBookingForm('123'),
        '/customer/providers/123/booking-form/',
      );
      expect(ApiUrl.customerBookings, '/customer/bookings/');
    });

    test('Provider endpoints are defined correctly', () {
      expect(ApiUrl.providerRegister, '/provider/auth/register/');
      expect(ApiUrl.providerLogin, '/provider/auth/login/');
      expect(ApiUrl.providerOtpRequest, '/provider/auth/otp/request/');
      expect(ApiUrl.providerOtpVerify, '/provider/auth/otp/verify/');
      expect(ApiUrl.providerPasswordReset, '/provider/auth/password/reset/');
      expect(ApiUrl.providerPasswordChange, '/provider/auth/password/change/');
      expect(ApiUrl.providerTokenRefresh, '/provider/auth/token/refresh/');
      expect(ApiUrl.providerTokenVerify, '/provider/auth/token/verify/');
      expect(ApiUrl.providerLogout, '/provider/auth/logout/');
      expect(ApiUrl.providerMe, '/provider/auth/me/');
      expect(ApiUrl.providerDeletionStatus, '/provider/auth/me/deletion-status/');
      expect(ApiUrl.providerRoles, '/provider/auth/roles/');
    });

    test('Common auth endpoints are defined correctly', () {
      expect(ApiUrl.authLogin, '/auth/login/');
      expect(ApiUrl.commonLogin, '/auth/login/');
      expect(ApiUrl.login, '/auth/login/');
    });
  });
}

