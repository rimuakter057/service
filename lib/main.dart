import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'core/network/session_events.dart';
import 'core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'core/router/app_router.dart';
import 'core/utils/app_theme/app_theme.dart';
import 'features/provider/auth/presentation/providers/provider_auth_provider.dart';
import 'features/user/auth/presentation/providers/auth_provider.dart';
import 'features/user/auth/presentation/screens/login/login_screen.dart';
import 'features/user/explore/presentation/providers/explore_provider.dart';
import 'features/user/home/presentation/providers/provider_detail_provider.dart';
import 'features/user/home/presentation/providers/provider_availability_provider.dart';
import 'features/user/home/presentation/providers/near_providers_notifier.dart';
import 'features/user/home/presentation/providers/ongoing_bookings_notifier.dart';
import 'features/user/home/presentation/providers/home_search_notifier.dart';
import 'features/user/bookings/presentation/providers/booking_notifier.dart';
import 'features/common/cms_support/presentation/providers/company_notifier.dart';
import 'features/common/cms_support/presentation/providers/faq_notifier.dart';
import 'features/user/bookings/presentation/providers/customer_bookings_notifier.dart';
import 'features/user/bookings/presentation/providers/customer_booking_detail_notifier.dart';
import 'features/user/bookings/presentation/providers/customer_dispute_notifier.dart';
import 'features/user/profile/presentation/providers/user_profile_notifier.dart';
import 'features/user/profile/presentation/providers/favorite_providers_notifier.dart';
import 'features/provider/bookings/presentation/providers/provider_bookings_notifier.dart';
import 'features/provider/bookings/presentation/providers/provider_booking_detail_notifier.dart';
import 'features/provider/bookings/presentation/providers/provider_dispute_notifier.dart';
import 'features/provider/reviews/presentation/providers/provider_review_notifier.dart';
import 'features/user/reviews/presentation/providers/customer_review_notifier.dart';
import 'features/common/chat/presentation/providers/conversations_notifier.dart';
import 'features/common/chat/presentation/providers/chat_thread_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient().restoreSavedToken();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProviderAuthProvider()),
        ChangeNotifierProvider(create: (_) => ExploreProviderNotifier()),
        ChangeNotifierProvider(create: (_) => ProviderDetailNotifier()),
        ChangeNotifierProvider(create: (_) => ProviderAvailabilityNotifier()),
        ChangeNotifierProvider(create: (_) => BookingNotifier()),
        ChangeNotifierProvider(create: (_) => CustomerBookingsNotifier()),
        ChangeNotifierProvider(create: (_) => CustomerBookingDetailNotifier()),
        ChangeNotifierProvider(create: (_) => CustomerDisputeNotifier()),
        ChangeNotifierProvider(create: (_) => NearProvidersNotifier()),
        ChangeNotifierProvider(create: (_) => OngoingBookingsNotifier()),
        ChangeNotifierProvider(create: (_) => HomeSearchNotifier()),
        ChangeNotifierProvider(create: (_) => CompanyNotifier()),
        ChangeNotifierProvider(create: (_) => ProviderCompanyNotifier()),
        ChangeNotifierProvider(create: (_) => FaqNotifier()),
        ChangeNotifierProvider(create: (_) => ProviderFaqNotifier()),
        ChangeNotifierProvider(create: (_) => UserProfileNotifier()),
        ChangeNotifierProvider(create: (_) => FavoriteProvidersNotifier()),
        ChangeNotifierProvider(create: (_) => ProviderBookingsNotifier()),
        ChangeNotifierProvider(create: (_) => ProviderBookingDetailNotifier()),
        ChangeNotifierProvider(create: (_) => ProviderDisputeNotifier()),
        ChangeNotifierProvider(create: (_) => ProviderReviewNotifier()),
        ChangeNotifierProvider(create: (_) => CustomerReviewNotifier()),
        ChangeNotifierProvider(create: (_) => CustomerConversationsNotifier()),
        ChangeNotifierProvider(create: (_) => ProviderConversationsNotifier()),
        ChangeNotifierProvider(create: (_) => CustomerChatThreadNotifier()),
        ChangeNotifierProvider(create: (_) => ProviderChatThreadNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<void>? _sessionExpiredSubscription;

  @override
  void initState() {
    super.initState();
    // The refresh token was invalid/expired too — the session is really
    // over, so send the user back to login regardless of where they are.
    _sessionExpiredSubscription = SessionEvents.onSessionExpired.listen((_) {
      AppRouter.router.go(LoginScreen.routeName);
    });
  }

  @override
  void dispose() {
    _sessionExpiredSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      builder: (context, child) => ResponsiveWrapper(child: child!),
      routerConfig: AppRouter.router,
    );
  }
}
