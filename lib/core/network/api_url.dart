/// All API endpoint paths in one place, appended to [ApiConstants.baseUrl].
/// Keeping every path here means a backend route change only ever touches
/// this one file — data sources never hardcode a path string.
class ApiUrl {
  const ApiUrl._();

  // ===== Customer — Auth =====
  static const String customerRoles = '/customer/auth/roles/';
  static const String customerOtpRequest = '/customer/auth/otp/request/';
  static const String customerOtpVerify = '/customer/auth/otp/verify/';
  static const String customerRegister = '/customer/auth/register/';
  static const String customerLogin = '/customer/auth/login/';
  static const String customerLogout = '/customer/auth/logout/';
  static const String customerTokenRefresh = '/customer/auth/token/refresh/';
  static const String customerTokenVerify = '/customer/auth/token/verify/';
  static const String customerPasswordReset = '/customer/auth/password/reset/';
  static const String customerPasswordChange = '/customer/auth/password/change/';
  static const String customerMe = '/customer/auth/me/';
  static const String customerDeletionStatus =
      '/customer/auth/me/deletion-status/';

  // ===== Provider — Auth =====
  static const String providerRoles = '/provider/auth/roles/';
  static const String providerOtpRequest = '/provider/auth/otp/request/';
  static const String providerOtpVerify = '/provider/auth/otp/verify/';
  static const String providerRegister = '/provider/auth/register/';
  static const String providerLogin = '/provider/auth/login/';
  static const String providerLogout = '/provider/auth/logout/';
  static const String providerTokenRefresh = '/provider/auth/token/refresh/';
  static const String providerTokenVerify = '/provider/auth/token/verify/';
  static const String providerPasswordReset = '/provider/auth/password/reset/';
  static const String providerPasswordChange = '/provider/auth/password/change/';
  static const String providerMe = '/provider/auth/me/';
  static const String providerDeletionStatus =
      '/provider/auth/me/deletion-status/';

  // Legacy aliases for backward compatibility
  static const String login = customerLogin;
  static const String customerVerifyOtp = customerOtpVerify;
  static const String forgetPassOtp = customerOtpRequest;
  static const String verifyForgetOtp = customerOtpVerify;
  static const String resetPass = customerPasswordReset;
  static const String refreshToken = customerTokenRefresh;

  // ===== KYC / Identity =====
  static const String providerIdentity = '/kyc/requests/';

  // ===== Catalog / Categories =====
  static const String categories = '/customer/catalog/categories/';

  // ===== Customer Providers =====
  static const String customerProviders = '/customer/providers/';
  static String customerProviderDetails(String id) => '/customer/providers/$id/';
  static String customerProviderDayAvailability(String id) =>
      '/customer/providers/$id/availability/day/';
  static String customerProviderBookingForm(String id) =>
      '/customer/providers/$id/booking-form/';

  // ===== Customer Bookings =====
  static const String customerBookings = '/customer/bookings/';
}


