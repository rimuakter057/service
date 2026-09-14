import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/provider/bookings/presentation/screens/booking_details/provider_bookings_screen.dart';
import '../../../features/provider/home/presentation/screens/home_screen/provider_home_screen.dart';
import '../../../features/provider/messages/presentation/screens/provider_messages_screen.dart';
import '../../../features/provider/profile/presentation/screens/profile_screen/provider_profile_screen.dart';
import '../../../features/provider/services/presentation/screens/my_services/my_services_screen.dart';
import '../../utils/app_colors/app_colors.dart';
import '../../utils/app_text/app_text.dart';
import '../../utils/assets_path/assets_path.dart';
import 'app_bottom_nav_bar.dart';

/// Pre-configured bottom navigation bar for the provider app flow.
///
/// Encapsulates the 5 provider tabs (Home, Bookings, Services, Messages,
/// Profile) — same [AppBottomNavBar] engine as [UserBottomNavBar], with
/// the active pill on every tab just like the user app.
class ProviderBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const ProviderBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  static final List<AppBottomNavItem> defaultItems = [
    const AppBottomNavItem(
      iconAsset: AssetsPath.navHome,
      label: AppText.home,
      activeBackgroundColor: AppColors.brandPrimary,
    ),
    const AppBottomNavItem(
      iconAsset: AssetsPath.navBookings,
      label: AppText.bookings,
      activeBackgroundColor: AppColors.brandPrimary,
    ),
    const AppBottomNavItem(
      iconAsset: AssetsPath.providerHomeIconServices,
      label: AppText.services,
      activeBackgroundColor: AppColors.brandPrimary,
    ),
    const AppBottomNavItem(
      iconAsset: AssetsPath.navMessages,
      label: AppText.messages,
      activeBackgroundColor: AppColors.brandPrimary,
    ),
    const AppBottomNavItem(
      iconAsset: AssetsPath.navProfile,
      label: AppText.profile,
      activeBackgroundColor: AppColors.brandPrimary,
    ),
  ];

  void _defaultOnTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        context.go(ProviderHomeScreen.routeName);
        break;
      case 1:
        context.go(ProviderBookingsScreen.routeName);
        break;
      case 2:
        context.go(MyServicesScreen.routeName);
        break;
      case 3:
        context.go(ProviderMessagesScreen.routeName);
        break;
      case 4:
        context.go(ProviderProfileScreen.routeName);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomNavBar(
      items: defaultItems,
      currentIndex: currentIndex,
      onTap: (index) {
        if (onTap != null) {
          onTap!(index);
        } else {
          _defaultOnTap(context, index);
        }
      },
    );
  }
}
