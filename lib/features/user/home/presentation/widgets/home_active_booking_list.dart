import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/user/home/presentation/providers/ongoing_bookings_notifier.dart';
import 'package:nchito/features/user/bookings/presentation/screens/booking_details/booking_details_screen.dart';

import 'booking_list_tile.dart';
import 'home_sample_data.dart';

/// The "Active Booking" list on Home with pagination.
/// Fetches ongoing bookings from `/api/v1/customer/bookings/?group=ongoing`.
class HomeActiveBookingList extends StatefulWidget {
  const HomeActiveBookingList({super.key});

  @override
  State<HomeActiveBookingList> createState() => _HomeActiveBookingListState();
}

class _HomeActiveBookingListState extends State<HomeActiveBookingList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = context.read<OngoingBookingsNotifier>();
      if (notifier.rawBookings.isEmpty && !notifier.isLoading) {
        notifier.fetchOngoingBookings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OngoingBookingsNotifier>(
      builder: (context, notifier, _) {
        // Initial loading state
        if (notifier.isLoading && notifier.rawBookings.isEmpty) {
          return Column(
            children: List.generate(
              3,
              (_) => Padding(
                padding: EdgeInsets.only(bottom: ResponsiveHelper.spacing(12)),
                child: _buildSkeletonTile(),
              ),
            ),
          );
        }

        // Error state when no bookings loaded
        if (notifier.errorMessage != null && notifier.rawBookings.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(16)),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    notifier.errorMessage!,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(12),
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(8)),
                  TextButton(
                    onPressed: () =>
                        notifier.fetchOngoingBookings(refresh: true),
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(12),
                        fontWeight: FontWeight.w600,
                        color: AppColors.brandPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Use real bookings if available, otherwise sample data fallback
        final bookings = notifier.homeBookings.isNotEmpty
            ? notifier.homeBookings
            : homeActiveBookings;

        final rawBookings = notifier.rawBookings;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < bookings.length; i++) ...[
              Padding(
                padding: EdgeInsets.only(bottom: ResponsiveHelper.spacing(12)),
                child: BookingListTile(
                  iconAsset: bookings[i].iconAsset,
                  iconBgColor: bookings[i].iconBgColor,
                  iconColor: bookings[i].iconColor,
                  providerName: bookings[i].providerName,
                  service: bookings[i].service,
                  price: bookings[i].price,
                  date: bookings[i].date,
                  time: bookings[i].time,
                  onTap: () {
                    final bookingHistory = i < rawBookings.length
                        ? rawBookings[i].toBookingHistoryData()
                        : null;
                    if (bookingHistory != null) {
                      context.push(
                        BookingDetailsScreen.routeName,
                        extra: bookingHistory,
                      );
                    } else if (bookings[i].id != null &&
                        bookings[i].id!.isNotEmpty) {
                      context.push(
                        BookingDetailsScreen.routeName,
                        extra: bookings[i].id,
                      );
                    }
                  },
                ),
              ),
            ],

            // Pagination: Show loading spinner automatically on scroll
            if (notifier.isLoadingMore) ...[
              SizedBox(height: ResponsiveHelper.spacing(8)),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveHelper.padding(8),
                  ),
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.brandPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ] else if (notifier.loadMoreErrorMessage != null) ...[
              SizedBox(height: ResponsiveHelper.spacing(4)),
              Center(
                child: TextButton(
                  onPressed: () => notifier.loadMore(),
                  child: Text(
                    '${notifier.loadMoreErrorMessage!} Tap to retry',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(11),
                      color: AppColors.red,
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSkeletonTile() {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
        border: Border.all(
          color: AppColors.borderDefault.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveHelper.width(44),
            height: ResponsiveHelper.width(44),
            decoration: BoxDecoration(
              color: AppColors.borderDefault.withValues(alpha: 0.3),
              borderRadius:
                  BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: ResponsiveHelper.width(120),
                  height: ResponsiveHelper.height(14),
                  decoration: BoxDecoration(
                    color: AppColors.borderDefault.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(6)),
                Container(
                  width: ResponsiveHelper.width(80),
                  height: ResponsiveHelper.height(10),
                  decoration: BoxDecoration(
                    color: AppColors.borderDefault.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(6)),
                Container(
                  width: ResponsiveHelper.width(60),
                  height: ResponsiveHelper.height(10),
                  decoration: BoxDecoration(
                    color: AppColors.borderDefault.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(8)),
          Container(
            width: ResponsiveHelper.width(64),
            height: ResponsiveHelper.height(48),
            decoration: BoxDecoration(
              color: AppColors.borderDefault.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.borderDefault.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
