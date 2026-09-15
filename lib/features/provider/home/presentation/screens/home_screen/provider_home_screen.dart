import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_bottom_nav_bar/provider_bottom_nav_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/booking_details/provider_booking_details_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/provider_booking_sample_data.dart';
import 'package:nchito/features/provider/home/presentation/widgets/provider_booking_tile.dart';
import 'package:nchito/features/provider/home/presentation/widgets/provider_home_header.dart';
import 'package:nchito/features/provider/home/presentation/widgets/provider_overview_stats.dart';
import 'package:nchito/features/user/home/presentation/widgets/section_header.dart';
import 'package:nchito/features/user/notifications/presentation/screens/notifications_screen.dart';

/// Provider Home screen — today's overview stats, new booking requests,
/// and today's bookings. Reached from the provider bottom nav's "Home"
/// tab.
class ProviderHomeScreen extends StatelessWidget {
  static const String routeName = '/provider/home';

  const ProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      body: Column(
        children: [
          ProviderHomeHeader(
            onNotificationTap: () =>
                context.push(NotificationsScreen.routeName),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(20),
                  vertical: ResponsiveHelper.padding(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: AppText.todaysOverview,
                      actionLabel: AppText.viewCalendar,
                      onViewAllTap: () {},
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),
                    const ProviderOverviewStats(
                      pendingRequests: '00',
                      upcomingBookings: '04',
                      todaysBookings: '01',
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),

                    SectionHeader(
                      title: AppText.newBookingRequests,
                      onViewAllTap: () {},
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),
                    for (final booking in providerNewBookingRequests) ...[
                      ProviderBookingTile(
                        customerName: booking.customerName,
                        service: booking.service,
                        price: booking.price,
                        iconAsset: booking.iconAsset,
                        iconBgColor: booking.iconBgColor,
                        day: booking.day,
                        month: booking.month,
                        time: booking.time,
                        onTap: () => context.push(
                          ProviderBookingDetailsScreen.routeName,
                          extra: booking,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(10)),
                    ],
                    SizedBox(height: ResponsiveHelper.spacing(8)),

                    SectionHeader(
                      title: AppText.todaysBookings,
                      onViewAllTap: () {},
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),
                    for (final booking in providerTodaysBookings)
                      ProviderBookingTile(
                        customerName: booking.customerName,
                        service: booking.service,
                        price: booking.price,
                        iconAsset: booking.iconAsset,
                        iconBgColor: booking.iconBgColor,
                        day: booking.day,
                        month: booking.month,
                        time: booking.time,
                        onTap: () => context.push(
                          ProviderBookingDetailsScreen.routeName,
                          extra: booking,
                        ),
                      ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const ProviderBottomNavBar(currentIndex: 0),
    );
  }
}
