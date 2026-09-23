import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nchito/features/common/common_widgets/app_bottom_nav_bar/app_bottom_nav_bar.dart';
import 'package:nchito/features/common/common_widgets/app_search_bar/app_search_bar.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/user/bookings/presentation/providers/customer_bookings_notifier.dart';
import 'package:nchito/features/user/bookings/presentation/screens/booking_details/booking_details_screen.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/booking_history_tile.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/booking_tile_shimmer.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_filter_bottom_sheet.dart';

class BookingsScreen extends StatefulWidget {
  static const String routeName = '/bookings';

  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = context.read<CustomerBookingsNotifier>();
      notifier.fetchBookings();
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CustomerBookingsNotifier>().loadMoreBookings();
    }
  }

  void _onFilterTap() {
    final notifier = context.read<CustomerBookingsNotifier>();
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
            const TopAppbar(title: AppText.myBookings),
            Expanded(
              child: Consumer<CustomerBookingsNotifier>(
                builder: (context, notifier, child) {
                  final bookings = notifier.bookingEntries;
                  final isLoadingInitial =
                      notifier.isLoading && notifier.bookings.isEmpty;
                  final hasError =
                      notifier.errorMessage != null && notifier.bookings.isEmpty;
                  final isEmpty = notifier.isEmpty;

                  final showPaginationFooter =
                      notifier.isLoadingMore || notifier.loadMoreErrorMessage != null;
                  int totalItems = 1;
                  if (isLoadingInitial) {
                    totalItems += 6; // 6 shimmer items
                  } else if (hasError || isEmpty) {
                    totalItems += 1; // error or empty message widget
                  } else {
                    totalItems += bookings.length + (showPaginationFooter ? 1 : 0);
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
                        // Index 0: Search Bar (Exact 100% match with original design)
                        if (index == 0) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: ResponsiveHelper.spacing(6),
                            ),
                            child: AppSearchBar(
                              controller: _searchController,
                              onChanged: notifier.onSearchChanged,
                              onFilterTap: _onFilterTap,
                            ),
                          );
                        }

                        // State 1: Shimmer while initial loading
                        if (isLoadingInitial) {
                          return const BookingTileShimmer();
                        }

                        // State 2: Error view
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
                                  SizedBox(
                                    height: ResponsiveHelper.spacing(12),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.brandPrimary,
                                    ),
                                    onPressed: () => notifier.fetchBookings(
                                      refresh: true,
                                    ),
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

                        // State 3: Empty bookings view
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

                        // State 4: Load more pagination shimmer or error retry at the end
                        final bookingIndex = index - 1;
                        if (bookingIndex >= bookings.length) {
                          if (notifier.isLoadingMore) {
                            return const BookingTileShimmer();
                          }
                          if (notifier.loadMoreErrorMessage != null) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveHelper.padding(12),
                              ),
                              child: Center(
                                child: TextButton(
                                  onPressed: () =>
                                      notifier.loadMoreBookings(),
                                  child: Text(
                                    '${notifier.loadMoreErrorMessage!} Tap to retry',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(12),
                                      color: AppColors.red,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }

                        // State 5: Real Booking Tile (100% exact design)
                        final booking = bookings[bookingIndex];
                        return BookingHistoryTile(
                          iconAsset: booking.iconAsset,
                          iconBgColor: booking.iconBgColor,
                          providerName: booking.providerName,
                          service: booking.service,
                          price: booking.price,
                          day: booking.day,
                          month: booking.month,
                          time: booking.time,
                          onTap: () => context.push(
                            BookingDetailsScreen.routeName,
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
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 2),
    );
  }
}
