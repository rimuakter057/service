import 'package:go_router/go_router.dart';
import 'package:nchito/core/constants/user_role.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/provider/auth/presentation/screens/age_confirmation/provider_age_confirmation_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/connect_payments/connect_payments_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/forgot_password/provider_forgot_password_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/link_payment_account/link_payment_account_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/login/provider_login_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/set_new_password/provider_set_new_password_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/signup/provider_signup_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/verify_identity/verify_identity_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/verify_otp/provider_verify_otp_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/booking_confirmed/provider_booking_confirmed_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/booking_details/provider_booking_details_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/customer_details/customer_details_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/dpo_checkout/provider_dpo_checkout_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/booking_details/provider_bookings_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/provider_booking_sample_data.dart';
import 'package:nchito/features/provider/home/presentation/screens/home_screen/provider_home_screen.dart';
import 'package:nchito/features/provider/messages/presentation/screens/provider_messages_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/profile_screen/provider_profile_screen.dart';
import 'package:nchito/features/provider/services/presentation/screens/my_services/my_services_screen.dart';
import 'package:nchito/features/demo/presentation/screens/demo_role_selection_screen.dart';
import 'package:nchito/features/splash/presentation/screens/splash_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/age_confirmation/age_confirmation_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/login/login_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/role_selection/role_selection_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/set_new_password/set_new_password_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/signup/signup_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/verify_otp/verify_otp_screen.dart';
import 'package:nchito/features/user/bookings/presentation/screens/booking_confirmed/booking_confirmed_screen.dart';
import 'package:nchito/features/user/bookings/presentation/screens/booking_details/booking_details_screen.dart'
    as bookings;
import 'package:nchito/features/user/bookings/presentation/screens/bookings_screen.dart';
import 'package:nchito/features/user/bookings/presentation/screens/dpo_checkout/dpo_checkout_screen.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/explore/presentation/screens/explore_provider/explore_provider_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/all_reviews/all_reviews_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/booking_details/booking_details_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/home_screen/home_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_availability/provider_availability_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_details/provider_details_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/service_categories/service_categories_screen.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';
import 'package:nchito/features/user/messages/presentation/screens/chat_screen.dart';
import 'package:nchito/features/user/messages/presentation/screens/messages_screen.dart';
import 'package:nchito/features/user/messages/presentation/widgets/message_sample_data.dart';
import 'package:nchito/features/user/notifications/presentation/screens/notifications_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/account_settings/account_settings_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/favorite_providers/favorite_providers_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/help_support/help_support_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/legal_company_info/legal_company_info_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/change_password/change_password_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/my_profile/my_profile_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/profile_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/update_profile/update_profile_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: SplashScreen.routeName,
    routes: [
      GoRoute(
        path: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: DemoRoleSelectionScreen.routeName,
        builder: (context, state) => const DemoRoleSelectionScreen(),
      ),
      GoRoute(
        path: OnboardingScreen.routeName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: LoginScreen.routeName,
        builder: (context, state) {
          final role = state.extra is UserRole
              ? state.extra as UserRole
              : UserRole.user;
          return LoginScreen(role: role);
        },
      ),
      GoRoute(
        path: SignUpScreen.routeName,
        builder: (context, state) =>
            SignUpScreen(role: state.extra as UserRole? ?? UserRole.user),
      ),
      GoRoute(
        path: VerifyOtpScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return VerifyOtpScreen(
            subtitle:
                extra?['subtitle'] as String? ??
                AppText.enterThe6DigitVerificationCodeSentToYourEmailAddress,
            nextRouteName: extra?['nextRouteName'] as String?,
          );
        },
      ),
      GoRoute(
        path: ForgotPasswordScreen.routeName,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: SetNewPasswordScreen.routeName,
        builder: (context, state) => const SetNewPasswordScreen(),
      ),
      GoRoute(
        path: RoleSelectionScreen.routeName,
        builder: (context, state) => const RoleSelectionScreen(),
      ),

      // ==========================================================
      // PROVIDER AUTHENTICATION ROUTES
      // ==========================================================
      GoRoute(
        path: ProviderLoginScreen.routeName,
        builder: (context, state) => const ProviderLoginScreen(),
      ),
      GoRoute(
        path: ProviderAgeConfirmationScreen.routeName,
        builder: (context, state) => const ProviderAgeConfirmationScreen(),
      ),
      GoRoute(
        path: ProviderSignUpScreen.routeName,
        builder: (context, state) => const ProviderSignUpScreen(),
      ),
      GoRoute(
        path: ProviderForgotPasswordScreen.routeName,
        builder: (context, state) => const ProviderForgotPasswordScreen(),
      ),
      GoRoute(
        path: ProviderVerifyOtpScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ProviderVerifyOtpScreen(
            subtitle:
                extra?['subtitle'] as String? ??
                AppText.enterThe6DigitVerificationCodeSentToYourEmailAddress,
            nextRouteName: extra?['nextRouteName'] as String?,
          );
        },
      ),
      GoRoute(
        path: ProviderSetNewPasswordScreen.routeName,
        builder: (context, state) => const ProviderSetNewPasswordScreen(),
      ),
      GoRoute(
        path: VerifyIdentityScreen.routeName,
        builder: (context, state) => const VerifyIdentityScreen(),
      ),
      GoRoute(
        path: ConnectPaymentsScreen.routeName,
        builder: (context, state) => const ConnectPaymentsScreen(),
      ),
      GoRoute(
        path: LinkPaymentAccountScreen.routeName,
        builder: (context, state) => const LinkPaymentAccountScreen(),
      ),
      GoRoute(
        path: ProviderHomeScreen.routeName,
        builder: (context, state) => const ProviderHomeScreen(),
      ),
      GoRoute(
        path: MyServicesScreen.routeName,
        builder: (context, state) => const MyServicesScreen(),
      ),
      GoRoute(
        path: ProviderMessagesScreen.routeName,
        builder: (context, state) => const ProviderMessagesScreen(),
      ),
      GoRoute(
        path: ProviderProfileScreen.routeName,
        builder: (context, state) => const ProviderProfileScreen(),
      ),
      GoRoute(
        path: ProviderBookingDetailsScreen.routeName,
        builder: (context, state) => ProviderBookingDetailsScreen(
          booking: state.extra,
        ),
      ),
      GoRoute(
        path: CustomerDetailsScreen.routeName,
        builder: (context, state) {
          final booking = state.extra as ProviderBookingData;
          return CustomerDetailsScreen(
            customerName: booking.customerName,
            customerEmailOrPhone: booking.customerEmailOrPhone,
            customerPhoto: booking.customerPhoto,
          );
        },
      ),
      GoRoute(
        path: ProviderBookingsScreen.routeName,
        builder: (context, state) => const ProviderBookingsScreen(),
      ),
      GoRoute(
        path: ProviderDpoCheckoutScreen.routeName,
        builder: (context, state) => ProviderDpoCheckoutScreen(
          booking: state.extra as BookingHistoryData,
        ),
      ),
      GoRoute(
        path: ProviderBookingConfirmedScreen.routeName,
        builder: (context, state) => ProviderBookingConfirmedScreen(
          booking: state.extra as BookingHistoryData?,
        ),
      ),
      GoRoute(
        path: AgeConfirmationScreen.routeName,
        builder: (context, state) {
          final role = state.extra is UserRole
              ? state.extra as UserRole
              : UserRole.provider;
          return AgeConfirmationScreen(role: role);
        },
      ),
      GoRoute(
        path: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: NotificationsScreen.routeName,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: ServiceCategoriesScreen.routeName,
        builder: (context, state) => const ServiceCategoriesScreen(),
      ),
      GoRoute(
        path: ProviderDetailsScreen.routeName,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, dynamic>) {
            return ProviderDetailsScreen(
              provider: extra['provider'] as HomeProviderData,
              initialFavorite: extra['isFavorite'] as bool? ?? false,
            );
          }
          return ProviderDetailsScreen(provider: extra as HomeProviderData);
        },
      ),
      GoRoute(
        path: AllReviewsScreen.routeName,
        builder: (context, state) {
          final extra = state.extra;
          final reviewCount = extra is String
              ? extra
              : (extra is HomeProviderData
                    ? extra.reviewCount
                    : (extra != null ? extra.toString() : '0'));
          return AllReviewsScreen(reviewCount: reviewCount);
        },
      ),
      GoRoute(
        path: ProviderAvailabilityScreen.routeName,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is BookingHistoryData) {
            return ProviderAvailabilityScreen(
              isRescheduling: true,
              booking: extra,
            );
          } else if (extra is Map<String, dynamic>) {
            return ProviderAvailabilityScreen(
              isRescheduling: extra['isRescheduling'] as bool? ?? false,
              booking: extra['booking'],
            );
          }
          return const ProviderAvailabilityScreen();
        },
      ),
      GoRoute(
        path: BookingDetailsScreen.routeName,
        builder: (context, state) =>
            BookingDetailsScreen(booking: state.extra as HomeBookingData),
      ),
      GoRoute(
        path: ExploreProviderScreen.routeName,
        builder: (context, state) => const ExploreProviderScreen(),
      ),
      GoRoute(
        path: ProfileScreen.routeName,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: MyProfileScreen.routeName,
        builder: (context, state) => const MyProfileScreen(),
      ),
      GoRoute(
        path: AccountSettingsScreen.routeName,
        builder: (context, state) => const AccountSettingsScreen(),
      ),
      GoRoute(
        path: ChangePasswordScreen.routeName,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: FavoriteProvidersScreen.routeName,
        builder: (context, state) => const FavoriteProvidersScreen(),
      ),
      GoRoute(
        path: LegalCompanyInfoScreen.routeName,
        builder: (context, state) => const LegalCompanyInfoScreen(),
      ),
      GoRoute(
        path: HelpSupportScreen.routeName,
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: UpdateProfileScreen.routeName,
        builder: (context, state) => const UpdateProfileScreen(),
      ),
      GoRoute(
        path: MessagesScreen.routeName,
        builder: (context, state) => const MessagesScreen(),
      ),
      GoRoute(
        path: ChatScreen.routeName,
        builder: (context, state) =>
            ChatScreen(conversation: state.extra as MessageData),
      ),
      GoRoute(
        path: BookingsScreen.routeName,
        builder: (context, state) => const BookingsScreen(),
      ),
      GoRoute(
        path: bookings.BookingDetailsScreen.routeName,
        builder: (context, state) => bookings.BookingDetailsScreen(
          booking: state.extra as BookingHistoryData,
        ),
      ),
      GoRoute(
        path: DpoCheckoutScreen.routeName,
        builder: (context, state) => DpoCheckoutScreen(
          booking: state.extra as BookingHistoryData,
        ),
      ),
      GoRoute(
        path: BookingConfirmedScreen.routeName,
        builder: (context, state) => BookingConfirmedScreen(
          booking: state.extra as BookingHistoryData?,
        ),
      ),
    ],
  );
}
