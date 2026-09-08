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
    ],
  );
}
