
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

  // ===== Common / Unified Auth =====
  static const String authLogin = '/auth/login/';
  static const String commonLogin = authLogin;

  // Legacy aliases for backward compatibility
  static const String login = authLogin;
  static const String customerVerifyOtp = customerOtpVerify;
  static const String forgetPassOtp = customerOtpRequest;
  static const String verifyForgetOtp = customerOtpVerify;
  static const String resetPass = customerPasswordReset;
  static const String refreshToken = customerTokenRefresh;

  // ===== KYC / Identity =====
  static const String providerIdentity = '/provider/kyc/requests/';

  // ===== Catalog / Categories =====
  static const String categories = '/customer/catalog/categories/';
  static const String catalogSearch = '/customer/catalog/search/';

  // ===== Customer Providers =====
  static const String customerProviders = '/customer/providers/';
  static const String customerProviderFilters = '/customer/providers/filters/';
  static String customerProviderDetails(String id) => '/customer/providers/$id/';
  static String customerProviderMonthAvailability(String id) =>
      '/customer/providers/$id/availability/month/';
  static String customerProviderDayAvailability(String id) =>
      '/customer/providers/$id/availability/day/';
  static String customerProviderBookingForm(String id) =>
      '/customer/providers/$id/booking-form/';
  static const String customerProviderFavorites =
      '/customer/providers/favorites/';
  static String customerProviderFavoriteDetails(String id) =>
      '/customer/providers/favorites/$id/';
  static String customerProviderFavoriteToggle(String id) =>
      '/customer/providers/$id/favorite/';

  // ===== Customer Bookings =====
  static const String customerBookings = '/customer/bookings/';
  static String customerBookingDetails(String id) => '/customer/bookings/$id/';
  static String customerBookingAccept(String id) =>
      '/customer/bookings/$id/accept/';
  static String customerBookingCancel(String id) =>
      '/customer/bookings/$id/cancel/';
  static String customerBookingComplete(String id) =>
      '/customer/bookings/$id/complete/';
  static String customerBookingDeclineQuote(String id) =>
      '/customer/bookings/$id/decline-quote/';
  static String customerBookingReject(String id) =>
      '/customer/bookings/$id/reject/';
  static String customerBookingReschedule(String id) =>
      '/customer/bookings/$id/reschedule/';
  static String customerBookingRescheduleRespond(String id) =>
      '/customer/bookings/$id/reschedule/respond/';
  static String customerBookingResendCompletionCode(String id) =>
      '/customer/bookings/$id/resend-completion-code/';
  static String customerBookingStart(String id) =>
      '/customer/bookings/$id/start/';
  static String customerBookingVerifyCompletion(String id) =>
      '/customer/bookings/$id/verify-completion/';

  // ===== Customer Disputes =====
  static const String customerDisputes = '/customer/disputes/';
  static String customerDisputeDetails(String id) =>
      '/customer/disputes/$id/';
  static String customerDisputeCancel(String id) =>
      '/customer/disputes/$id/cancel/';
  static String customerDisputeRespond(String id) =>
      '/customer/disputes/$id/respond/';

  // ===== Provider Bookings =====
  static const String providerBookings = '/provider/bookings/';
  static const String providerBookingFilters = '/provider/bookings/filters/';
  static String providerBookingDetails(String id) => '/provider/bookings/$id/';
  static String providerBookingAccept(String id) =>
      '/provider/bookings/$id/accept/';
  static String providerBookingCancel(String id) =>
      '/provider/bookings/$id/cancel/';
  static String providerBookingComplete(String id) =>
      '/provider/bookings/$id/complete/';
  static String providerBookingDeclineQuote(String id) =>
      '/provider/bookings/$id/decline-quote/';
  static String providerBookingReject(String id) =>
      '/provider/bookings/$id/reject/';
  static String providerBookingReschedule(String id) =>
      '/provider/bookings/$id/reschedule/';
  static String providerBookingRescheduleRespond(String id) =>
      '/provider/bookings/$id/reschedule/respond/';
  static String providerBookingResendCompletionCode(String id) =>
      '/provider/bookings/$id/resend-completion-code/';
  static String providerBookingStart(String id) =>
      '/provider/bookings/$id/start/';
  static String providerBookingVerifyCompletion(String id) =>
      '/provider/bookings/$id/verify-completion/';

  // ===== Provider Disputes =====
  static const String providerDisputes = '/provider/disputes/';
  static String providerDisputeDetails(String id) =>
      '/provider/disputes/$id/';
  static String providerDisputeCancel(String id) =>
      '/provider/disputes/$id/cancel/';
  static String providerDisputeRespond(String id) =>
      '/provider/disputes/$id/respond/';

  // ===== Provider Reviews =====
  // `?provider=<id>` is required on list/breakdown — confirmed against the
  // live API (breakdown 400s without it).
  static const String providerReviews = '/provider/reviews/';
  static const String providerReviewsBreakdown = '/provider/reviews/breakdown/';
  static String providerReviewDetails(String id) => '/provider/reviews/$id/';
  static String providerReviewReply(String id) => '/provider/reviews/$id/reply/';
  static String providerReviewReport(String id) => '/provider/reviews/$id/report/';

  // ===== Customer Reviews (viewing a provider's public reviews) =====
  static const String customerReviews = '/customer/reviews/';
  static const String customerReviewsBreakdown = '/customer/reviews/breakdown/';
  static String customerReviewDetails(String id) => '/customer/reviews/$id/';

  // ===== Chat (Customer + Provider — identical shape, `role` prefix only) =====
  static const String customerChatConversations = '/customer/chat/conversations/';
  static const String customerChatUnreadCount =
      '/customer/chat/conversations/unread-count/';
  static String customerChatConversationDetails(String id) =>
      '/customer/chat/conversations/$id/';
  static String customerChatConversationArchive(String id) =>
      '/customer/chat/conversations/$id/archive/';
  static String customerChatConversationBlock(String id) =>
      '/customer/chat/conversations/$id/block/';
  static String customerChatConversationUnblock(String id) =>
      '/customer/chat/conversations/$id/unblock/';
  static String customerChatConversationRead(String id) =>
      '/customer/chat/conversations/$id/read/';
  static String customerChatMessages(String id) =>
      '/customer/chat/conversations/$id/messages/';
  static const String customerChatBlocked = '/customer/chat/blocked/';

  static const String providerChatConversations = '/provider/chat/conversations/';
  static const String providerChatUnreadCount =
      '/provider/chat/conversations/unread-count/';
  static String providerChatConversationDetails(String id) =>
      '/provider/chat/conversations/$id/';
  static String providerChatConversationArchive(String id) =>
      '/provider/chat/conversations/$id/archive/';
  static String providerChatConversationBlock(String id) =>
      '/provider/chat/conversations/$id/block/';
  static String providerChatConversationUnblock(String id) =>
      '/provider/chat/conversations/$id/unblock/';
  static String providerChatConversationRead(String id) =>
      '/provider/chat/conversations/$id/read/';
  static String providerChatMessages(String id) =>
      '/provider/chat/conversations/$id/messages/';
  static const String providerChatBlocked = '/provider/chat/blocked/';

  // ===== CMS / Company Info =====
  static const String customerCompany = '/customer/cms/company/';
  static const String providerCompany = '/provider/cms/company/';

  // ===== Support / FAQs =====
  static const String customerFaqs = '/customer/support/faqs/';
  static const String providerFaqs = '/provider/support/faqs/';
}


