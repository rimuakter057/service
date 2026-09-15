import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:nchito/features/user/bookings/presentation/screens/bookings_screen.dart';
import 'package:nchito/features/user/explore/presentation/screens/explore_provider/explore_provider_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/home_screen/home_screen.dart';
import 'package:nchito/features/user/messages/presentation/screens/messages_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/profile_screen.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'app_bottom_nav_bar.dart';

/// Pre-configured bottom navigation bar for the user app flow.
///
/// Encapsulates the 5 user tabs (Home, Explore, Bookings, Messages, Profile),
/// their icons, labels, active pill styling, and default navigation routing.
class UserBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const UserBottomNavBar({
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
      iconAsset: AssetsPath.navExplore,
      label: AppText.explore,
      activeBackgroundColor: AppColors.brandPrimary,
    ),
    const AppBottomNavItem(
      iconAsset: AssetsPath.navBookings,
      label: AppText.bookings,
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
        context.go(HomeScreen.routeName);
        break;
      case 1:
        context.push(ExploreProviderScreen.routeName);
        break;
      case 2:
        context.push(BookingsScreen.routeName);
        break;
      case 3:
        context.push(MessagesScreen.routeName);
        break;
      case 4:
        context.push(ProfileScreen.routeName);
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
