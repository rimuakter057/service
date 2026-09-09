import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_bottom_nav_bar/app_bottom_nav_bar.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/explore/presentation/screens/explore_provider/explore_provider_screen.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_active_booking_list.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_category_grid.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_header.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_popular_providers.dart';
import 'package:nchito/features/user/home/presentation/widgets/section_header.dart';
import 'package:nchito/features/user/profile/presentation/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  void _onNavTap(int index) {
    if (index == 1) {
      context.push(ExploreProviderScreen.routeName);
      return;
    }
    if (index == 4) {
      context.push(ProfileScreen.routeName);
      return;
    }
    setState(() => _currentNavIndex = index);
  }

  static final List<AppBottomNavItem> _navItems = [
    AppBottomNavItem(iconAsset: AssetsPath.navHome, label: AppText.home),
    AppBottomNavItem(iconAsset: AssetsPath.navExplore, label: AppText.explore),
    AppBottomNavItem(
      iconAsset: AssetsPath.navBookings,
      label: AppText.bookings,
    ),
    AppBottomNavItem(
      iconAsset: AssetsPath.navMessages,
      label: AppText.messages,
    ),
    AppBottomNavItem(iconAsset: AssetsPath.navProfile, label: AppText.profile),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.bgApp,
        body: Column(
          children: [
            const HomeHeader(),
            Expanded(
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.padding(24),
                    vertical: ResponsiveHelper.padding(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppText.selectableFeaturedService,
                        style: context.labelMedium.copyWith(color: AppColors.textBlackPrimary),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(12)),

                      ///service items=====================================
                      const HomeCategoryGrid(),
                      SizedBox(height: ResponsiveHelper.spacing(24)),

                      SectionHeader(
                        title: AppText.popularNearYou,
                        onViewAllTap: () {},
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(12)),
                      ///popular near ====================================
                      const HomePopularProviders(),
                      SizedBox(height: ResponsiveHelper.spacing(24)),

                      SectionHeader(
                        title: AppText.activeBooking,
                        onViewAllTap: () {},
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(12)),
                      ///active booking list==========================
                      const HomeActiveBookingList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: AppBottomNavBar(
          items: _navItems,
          currentIndex: _currentNavIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}
