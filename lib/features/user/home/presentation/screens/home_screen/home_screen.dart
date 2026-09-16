import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/common/common_widgets/app_bottom_nav_bar/app_bottom_nav_bar.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_active_booking_list.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_category_grid.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_header.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_popular_providers.dart';
import 'package:nchito/features/user/home/presentation/widgets/section_header.dart';
import 'package:nchito/features/user/notifications/presentation/screens/notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: [
            HomeHeader(
              onNotificationTap: () =>
                  context.push(NotificationsScreen.routeName),
            ),
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
        bottomNavigationBar: const UserBottomNavBar(currentIndex: 0),
      ),
    );
  }
}
