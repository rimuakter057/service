import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nchito/features/common/role_selection/role_selection_screen.dart';
import 'package:nchito/features/user/home/presentation/providers/category_provider.dart';
import 'package:nchito/features/common/splash/presentation/screens/splash_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/age_confirmation/provider_age_confirmation_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/connect_payments/connect_payments_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/forgot_password/provider_forgot_password_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/forgot_password_verify_otp/provider_forgot_password_verify_otp_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/link_payment_account/link_payment_account_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/login/provider_login_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/onboarding/provider_onboarding_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/set_new_password/provider_set_new_password_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/signup/provider_signup_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/verify_identity/verify_identity_screen.dart';
import 'package:nchito/features/provider/auth/presentation/screens/verify_otp/provider_verify_otp_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/booking_confirmed/provider_booking_confirmed_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/booking_details/provider_booking_details_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/customer_details/customer_details_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/dispute_details/provider_dispute_details_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/provider_availability/provider_manage_availability_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/dpo_checkout/provider_dpo_checkout_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/booking_details/provider_bookings_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/provider_booking_sample_data.dart';
import 'package:nchito/features/provider/home/presentation/screens/home_screen/provider_home_screen.dart';
import 'package:nchito/features/provider/messages/presentation/screens/provider_chat_screen.dart';
import 'package:nchito/features/provider/messages/presentation/screens/provider_messages_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/account_settings/provider_account_settings_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/availability/provider_profile_availability_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/change_password/provider_change_password_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/earnings/provider_earnings_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/help_support/provider_help_support_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/legal_company_info/provider_legal_company_info_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/linked_payment_account/provider_linked_payment_account_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/my_profile/provider_my_profile_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/privacy_policy/provider_privacy_policy_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/profile_screen/provider_profile_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/set_availability/provider_set_availability_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/terms_and_condition/provider_terms_and_condition_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/update_profile/provider_update_profile_screen.dart';
import 'package:nchito/features/provider/services/presentation/screens/add_service/provider_add_service_screen.dart';
import 'package:nchito/features/provider/services/presentation/screens/edit_service/provider_edit_service_screen.dart';
import 'package:nchito/features/provider/services/presentation/screens/my_services/my_services_screen.dart';
import 'package:nchito/features/provider/services/presentation/screens/service_details/provider_service_details_screen.dart';
import 'package:nchito/features/provider/services/presentation/widgets/provider_services_sample_data.dart';
import 'package:nchito/features/user/auth/presentation/screens/age_confirmation/age_confirmation_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/forgot_password_verify_otp/forgot_password_verify_otp_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/login/login_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/set_new_password/set_new_password_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/signup/signup_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/verify_otp/verify_otp_screen.dart';
import 'package:nchito/features/user/bookings/presentation/screens/booking_confirmed/booking_confirmed_screen.dart';
import 'package:nchito/features/user/bookings/presentation/screens/booking_details/booking_details_screen.dart';
import 'package:nchito/features/user/bookings/presentation/screens/bookings_screen.dart';
import 'package:nchito/features/user/bookings/presentation/screens/dispute_details/dispute_details_screen.dart';
import 'package:nchito/features/user/bookings/presentation/screens/dpo_checkout/dpo_checkout_screen.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/explore/presentation/screens/book_a_service/book_a_service_screen.dart';
import 'package:nchito/features/user/explore/presentation/screens/explore_provider/explore_provider_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/all_reviews/all_reviews_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/booking_details/home_booking_details_screen.dart';
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
import 'package:nchito/features/user/profile/presentation/screens/privacy_policy/privacy_policy_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/profile_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/terms_and_condition/terms_and_condition_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/update_profile/update_profile_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: SplashScreen.routeName,
    routes: [

      ///============= splash section common ============
      GoRoute(
        path: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),



      ///============= role selection section ============
      GoRoute(
        path: RoleSelectionScreen.routeName,
        builder: (context, state) => const RoleSelectionScreen(),
      ),

      ///================ Provider all screens ====================================

      ///============= auth section provider ============
      GoRoute(
        path: ProviderLoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
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
        path: ProviderForgotPasswordVerifyOtpScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ProviderForgotPasswordVerifyOtpScreen(
            identifier: extra?['identifier'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: ProviderVerifyOtpScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ProviderVerifyOtpScreen(
            identifier: extra?['identifier'] as String? ?? '',
            nextRouteName:
                extra?['nextRouteName'] as String? ??
                VerifyIdentityScreen.routeName,
          );
        },
      ),
      GoRoute(
        path: ProviderSetNewPasswordScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ProviderSetNewPasswordScreen(
            identifier: extra?['identifier'] as String? ?? '',
            verificationToken:
                extra?['verification_token'] as String? ?? '',
          );
        },
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
        path: ProviderOnboardingScreen.routeName,
        builder: (context, state) => const ProviderOnboardingScreen(),
      ),
      GoRoute(
        path: LinkPaymentAccountScreen.routeName,
        builder: (context, state) => const LinkPaymentAccountScreen(),
      ),

      ///============= home section provider ============
      GoRoute(
        path: ProviderHomeScreen.routeName,
        builder: (context, state) => const ProviderHomeScreen(),
      ),

      ///============= messages section provider ============
      GoRoute(
        path: ProviderMessagesScreen.routeName,
        builder: (context, state) => const ProviderMessagesScreen(),
      ),
      GoRoute(
        path: ProviderChatScreen.routeName,
        builder: (context, state) => ProviderChatScreen(
          conversation: state.extra as MessageData,
        ),
      ),

      ///============= profile section provider ============
      GoRoute(
        path: ProviderProfileScreen.routeName,
        builder: (context, state) => const ProviderProfileScreen(),
      ),
      GoRoute(
        path: ProviderMyProfileScreen.routeName,
        builder: (context, state) => const ProviderMyProfileScreen(),
      ),
      GoRoute(
        path: ProviderUpdateProfileScreen.routeName,
        builder: (context, state) => const ProviderUpdateProfileScreen(),
      ),
      GoRoute(
        path: ProviderAccountSettingsScreen.routeName,
        builder: (context, state) => const ProviderAccountSettingsScreen(),
      ),
      GoRoute(
        path: ProviderChangePasswordScreen.routeName,
        builder: (context, state) => const ProviderChangePasswordScreen(),
      ),
      GoRoute(
        path: ProviderLegalCompanyInfoScreen.routeName,
        builder: (context, state) => const ProviderLegalCompanyInfoScreen(),
      ),
      GoRoute(
        path: ProviderHelpSupportScreen.routeName,
        builder: (context, state) => const ProviderHelpSupportScreen(),
      ),
      GoRoute(
        path: ProviderTermsAndConditionScreen.routeName,
        builder: (context, state) => const ProviderTermsAndConditionScreen(),
      ),
      GoRoute(
        path: ProviderPrivacyPolicyScreen.routeName,
        builder: (context, state) => const ProviderPrivacyPolicyScreen(),
      ),
      GoRoute(
        path: ProviderLinkedPaymentAccountScreen.routeName,
        builder: (context, state) =>
            const ProviderLinkedPaymentAccountScreen(),
      ),
      GoRoute(
        path: ProviderProfileAvailabilityScreen.routeName,
        builder: (context, state) =>
            const ProviderProfileAvailabilityScreen(),
      ),
      GoRoute(
        path: ProviderSetAvailabilityScreen.routeName,
        builder: (context, state) =>
            const ProviderSetAvailabilityScreen(),
      ),
      GoRoute(
        path: ProviderEarningsScreen.routeName,
        builder: (context, state) => const ProviderEarningsScreen(),
      ),

      ///============= services section provider ============
      GoRoute(
        path: MyServicesScreen.routeName,
        builder: (context, state) => const MyServicesScreen(),
      ),
      GoRoute(
        path: ProviderServiceDetailsScreen.routeName,
        builder: (context, state) {
          final service = state.extra as ProviderServiceData? ??
              sampleProviderServices.first;
          return ProviderServiceDetailsScreen(service: service);
        },
      ),
      GoRoute(
        path: ProviderAddServiceScreen.routeName,
        builder: (context, state) => const ProviderAddServiceScreen(),
      ),
      GoRoute(
        path: ProviderEditServiceScreen.routeName,
        builder: (context, state) {
          final service = state.extra as ProviderServiceData? ??
              sampleProviderServices.first;
          return ProviderEditServiceScreen(service: service);
        },
      ),

      ///============= bookings section provider ============
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


      ///============= availability section provider (reschedule) ============
      GoRoute(
        path: ProviderManageAvailabilityScreen.routeName,
        builder: (context, state) => ProviderManageAvailabilityScreen(
          booking: state.extra,
        ),
      ),


      ///============= dispute section provider ============
      GoRoute(
        path: ProviderDisputeDetailsScreen.routeName,
        builder: (context, state) => ProviderDisputeDetailsScreen(
          booking: state.extra,
        ),
      ),


      ///======================User all screens====================================================


      ///============= auth section user ============
      GoRoute(
        path: OnboardingScreen.routeName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AgeConfirmationScreen.routeName,
        builder: (context, state) => const AgeConfirmationScreen(),
      ),
      GoRoute(
        path: SignUpScreen.routeName,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: VerifyOtpScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return VerifyOtpScreen(
            identifier: extra?['identifier'] as String? ?? '',
            nextRouteName:
                extra?['nextRouteName'] as String? ??
                OnboardingScreen.routeName,
          );
        },
      ),
      GoRoute(
        path: ForgotPasswordScreen.routeName,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: ForgotPasswordVerifyOtpScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ForgotPasswordVerifyOtpScreen(
            identifier: extra?['identifier'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: SetNewPasswordScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return SetNewPasswordScreen(
            identifier: extra?['identifier'] as String? ?? '',
            verificationToken: extra?['verification_token'] as String? ?? '',
          );
        },
      ),

      ///============= home section user ============
      GoRoute(
        path: HomeScreen.routeName,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => CategoryProvider()..fetchCategories(),
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: NotificationsScreen.routeName,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: ServiceCategoriesScreen.routeName,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => CategoryProvider()..fetchCategories(),
          child: const ServiceCategoriesScreen(),
        ),
      ),
      GoRoute(
        path: ProviderDetailsScreen.routeName, // user viewing a provider
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
          final providerId = extra is HomeProviderData ? extra.id : null;
          return AllReviewsScreen(
            reviewCount: reviewCount,
            providerId: providerId,
          );
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
              providerId: extra['providerId'] as String?,
              provider: extra['provider'],
            );
          } else if (extra is String) {
            return ProviderAvailabilityScreen(
              providerId: extra,
            );
          }
          return const ProviderAvailabilityScreen();
        },
      ),

      ///============= explore section user ============
      GoRoute(
        path: HomeBookingDetailsScreen.routeName,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is HomeBookingData) {
            return BookingDetailsScreen(bookingId: extra.id);
          } else if (extra is BookingHistoryData) {
            return BookingDetailsScreen(booking: extra, bookingId: extra.id);
          } else if (extra is String) {
            return BookingDetailsScreen(bookingId: extra);
          }
          return const BookingDetailsScreen();
        },
      ),
      GoRoute(
        path: ExploreProviderScreen.routeName,
        builder: (context, state) => const ExploreProviderScreen(),
      ),
      GoRoute(
        path: BookAServiceScreen.routeName,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is HomeProviderData) {
            return BookAServiceScreen(provider: extra);
          } else if (extra is Map<String, dynamic>) {
            return BookAServiceScreen(
              provider: extra['provider'] as HomeProviderData?,
              selectedDate: extra['date'] as String?,
              selectedSlot: extra['slot'] as String?,
              selectedTime: extra['time'] as String?,
              providerId: extra['providerId'] as String?,
            );
          }
          return const BookAServiceScreen();
        },
      ),

      ///============= profile section user ============
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

      ///============= messages section user ============
      GoRoute(
        path: MessagesScreen.routeName,
        builder: (context, state) => const MessagesScreen(),
      ),
      GoRoute(
        path: ChatScreen.routeName,
        builder: (context, state) =>
            ChatScreen(conversation: state.extra as MessageData),
      ),

      ///============= bookings section user ============
      GoRoute(
        path: BookingsScreen.routeName,
        builder: (context, state) => const BookingsScreen(),
      ),
      GoRoute(
        path: BookingDetailsScreen.routeName,
        builder: (context, state) {
          if (state.extra is BookingHistoryData) {
            final data = state.extra as BookingHistoryData;
            return BookingDetailsScreen(
              booking: data,
              bookingId: data.id,
            );
          } else if (state.extra is HomeBookingData) {
            final data = state.extra as HomeBookingData;
            return BookingDetailsScreen(
              bookingId: data.id,
            );
          } else if (state.extra is String) {
            return BookingDetailsScreen(
              bookingId: state.extra as String,
            );
          } else if (state.extra is Map<String, dynamic>) {
            final map = state.extra as Map<String, dynamic>;
            return BookingDetailsScreen(
              booking: map['booking'] as BookingHistoryData?,
              bookingId: map['id']?.toString() ??
                  (map['booking'] as BookingHistoryData?)?.id,
            );
          }
          return const BookingDetailsScreen();
        },
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
      GoRoute(
        path: DisputeDetailsScreen.routeName,
        builder: (context, state) {
          if (state.extra is BookingHistoryData) {
            final data = state.extra as BookingHistoryData;
            return DisputeDetailsScreen(
              booking: data,
              bookingId: data.id,
            );
          } else if (state.extra is String) {
            return DisputeDetailsScreen(disputeId: state.extra as String);
          } else if (state.extra is Map<String, dynamic>) {
            final map = state.extra as Map<String, dynamic>;
            return DisputeDetailsScreen(
              booking: map['booking'] as BookingHistoryData?,
              disputeId: map['disputeId'] as String?,
              bookingId: map['bookingId'] as String? ?? (map['booking'] as BookingHistoryData?)?.id,
            );
          }
          return const DisputeDetailsScreen();
        },
      ),



      ///============= legal section user ============
      GoRoute(
        path: TermsAndConditionScreen.routeName,
        builder: (context, state) => const TermsAndConditionScreen(),
      ),
      GoRoute(
        path: PrivacyPolicyScreen.routeName,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),

    ],
  );
}
