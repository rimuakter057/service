import 'package:go_router/go_router.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/splash/presentation/screens/splash_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/age_confirmation/age_confirmation_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/login/login_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/role_selection/role_selection_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/set_new_password/set_new_password_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/signup/signup_screen.dart';
import 'package:nchito/features/user/auth/presentation/screens/verify_otp/verify_otp_screen.dart';
import 'package:nchito/features/user/bookings/presentation/screens/booking_details/booking_details_screen.dart'
    as bookings;
import 'package:nchito/features/user/bookings/presentation/screens/bookings_screen.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/explore/presentation/screens/explore_provider/explore_provider_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/all_reviews/all_reviews_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/booking_details/booking_details_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/home_screen/home_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_availability/provider_availability_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_details/provider_details_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/service_categories/service_categories_screen.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';
import 'package:nchito/features/user/messages/presentation/screens/messages_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/profile_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: BookingsScreen.routeName, // TEMP: preview only
    routes: [
      GoRoute(
        path: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: OnboardingScreen.routeName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
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
      GoRoute(
        path: AgeConfirmationScreen.routeName,
        builder: (context, state) => const AgeConfirmationScreen(),
      ),
      GoRoute(
        path: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: ServiceCategoriesScreen.routeName,
        builder: (context, state) => const ServiceCategoriesScreen(),
      ),
      GoRoute(
        path: ProviderDetailsScreen.routeName,
        builder: (context, state) =>
            ProviderDetailsScreen(provider: state.extra as HomeProviderData),
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
        builder: (context, state) => const ProviderAvailabilityScreen(),
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
        path: MessagesScreen.routeName,
        builder: (context, state) => const MessagesScreen(),
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
    ],
  );
}
