import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nchito/features/common/common_widgets/app_bottom_nav_bar/provider_bottom_nav_bar.dart';
import 'package:nchito/features/common/common_widgets/app_calendar/app_calendar.dart';
import 'package:nchito/features/common/common_widgets/app_search_bar/app_search_bar.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/provider/bookings/presentation/providers/provider_bookings_notifier.dart';
import 'package:nchito/features/provider/home/presentation/screens/home_screen/provider_home_screen.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/booking_history_tile.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/booking_tile_shimmer.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_filter_bottom_sheet.dart';
import 'provider_booking_details_screen.dart';

class ProviderBookingsScreen extends StatefulWidget {
  static const String routeName = '/provider/bookings';

  const ProviderBookingsScreen({super.key});

  @override
  State<ProviderBookingsScreen> createState() => _ProviderBookingsScreenState();
}

class _ProviderBookingsScreenState extends State<ProviderBookingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProviderBookingsNotifier>().fetchBookings();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProviderBookingsNotifier>().loadMoreBookings();
    }
  }

  void _onFilterTap() {
    final notifier = context.read<ProviderBookingsNotifier>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookingsFilterBottomSheet(
        currentFilter: notifier.selectedGroup,
        onApply: (filter) {
          notifier.applyFilter(filter);
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopAppbar(
              title: AppText.myBookings,
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(ProviderHomeScreen.routeName);
                }
              },
            ),
            Expanded(
              child: Consumer<ProviderBookingsNotifier>(
                builder: (context, notifier, child) {
                  final bookings = notifier.bookingEntries;
                  final isLoadingInitial =
                      notifier.isLoading && notifier.bookings.isEmpty;
                  final hasError =
                      notifier.errorMessage != null && notifier.bookings.isEmpty;
                  final isEmpty = notifier.isEmpty;

                  // Item count: 1 (search bar + calendar) + [shimmer OR
                  // error/empty OR bookings + (loadingMore ? 1 : 0)]
                  int totalItems = 1;
                  if (isLoadingInitial) {
                    totalItems += 6;
                  } else if (hasError || isEmpty) {
                    totalItems += 1;
                  } else {
                    totalItems += bookings.length + (notifier.isLoadingMore ? 1 : 0);
                  }

                  return RefreshIndicator(
                    color: AppColors.brandPrimary,
                    onRefresh: () async {
                      await notifier.fetchBookings(refresh: true);
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(20),
                        vertical: ResponsiveHelper.padding(8),
                      ),
                      itemCount: totalItems,
                      separatorBuilder: (_, index) =>
                          SizedBox(height: ResponsiveHelper.spacing(10)),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: ResponsiveHelper.spacing(12),
                                ),
                                child: AppSearchBar(
                                  controller: _searchController,
                                  onChanged: notifier.onSearchChanged,
                                  onFilterTap: _onFilterTap,
                                ),
                              ),
                              const AppCalendar(),
                              SizedBox(height: ResponsiveHelper.spacing(14)),
                            ],
                          );
                        }

                        if (isLoadingInitial) {
                          return const BookingTileShimmer();
                        }

                        if (hasError) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.padding(40),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    notifier.errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.red,
                                      fontSize: ResponsiveHelper.fontSize(14),
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveHelper.spacing(12)),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.brandPrimary,
                                    ),
                                    onPressed: () =>
                                        notifier.fetchBookings(refresh: true),
                                    child: const Text(
                                      'Retry',
                                      style: TextStyle(color: AppColors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.padding(40),
                            ),
                            child: Center(
                              child: Text(
                                notifier.emptyMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(14),
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        }

                        final bookingIndex = index - 1;
                        if (bookingIndex >= bookings.length) {
                          return const BookingTileShimmer();
                        }

                        final booking = bookings[bookingIndex];
                        return BookingHistoryTile(
                          iconAsset: booking.iconAsset,
                          iconBgColor: booking.iconBgColor,
                          providerName: booking.customerName,
                          service: booking.service,
                          price: booking.price,
                          day: booking.day,
                          month: booking.month,
                          time: booking.time,
                          onTap: () => context.push(
                            ProviderBookingDetailsScreen.routeName,
                            extra: booking,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ProviderBottomNavBar(currentIndex: 1),
    );
  }
}
