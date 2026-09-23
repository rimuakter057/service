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

  /// Locally tracked selected date so we can reset the calendar when
  /// the user clears the date filter.
  DateTime? _calendarSelectedDate;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    final now = DateTime.now();
    _calendarSelectedDate = DateTime(now.year, now.month, now.day);
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

  /// Called when the user taps a day in the calendar.
  void _onDateSelected(DateTime date) {
    setState(() => _calendarSelectedDate = date);
    context.read<ProviderBookingsNotifier>().fetchBookingsByDate(date);
  }

  /// Called by the "Today" chip — filters with today=true.
  void _onTodayTap(ProviderBookingsNotifier notifier) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    setState(() => _calendarSelectedDate = today);
    notifier.fetchTodaysBookings();
  }

  /// Called by the "Clear" chip — removes date filter.
  void _onClearDate(ProviderBookingsNotifier notifier) {
    final now = DateTime.now();
    setState(() => _calendarSelectedDate = DateTime(now.year, now.month, now.day));
    notifier.clearDateFilter();
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

                  // Item count: 1 (search bar + calendar + date chips) +
                  // [shimmer OR error/empty OR bookings + (loadingMore ? 1 : 0)]
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

                              // Calendar with date-tap integration
                              AppCalendar(
                                initialSelectedDate: _calendarSelectedDate,
                                onDateSelected: _onDateSelected,
                              ),

                              SizedBox(height: ResponsiveHelper.spacing(10)),

                              // Date filter chips
                              Row(
                                children: [
                                  // "Today" shortcut chip
                                  _DateFilterChip(
                                    label: AppText.today,
                                    isActive: notifier.filterToday,
                                    onTap: () => _onTodayTap(notifier),
                                  ),
                                  SizedBox(width: ResponsiveHelper.spacing(8)),

                                  // Show selected date if filtering by date
                                  if (notifier.selectedDate != null)
                                    _DateFilterChip(
                                      label: _formatChipDate(
                                          notifier.selectedDate!),
                                      isActive: true,
                                      onTap: () => _onClearDate(notifier),
                                      showClose: true,
                                    ),

                                  // Clear all date filter
                                  if (notifier.hasDateFilter) ...[
                                    SizedBox(width: ResponsiveHelper.spacing(8)),
                                    _DateFilterChip(
                                      label: 'All Dates',
                                      isActive: false,
                                      onTap: () => _onClearDate(notifier),
                                    ),
                                  ],
                                ],
                              ),

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

  String _formatChipDate(String yyyyMmDd) {
    try {
      final dt = DateTime.parse(yyyyMmDd);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month - 1]}';
    } catch (_) {
      return yyyyMmDd;
    }
  }
}

/// Small pill-chip for the date filter row.
class _DateFilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool showClose;
  final VoidCallback onTap;

  const _DateFilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.showClose = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(12),
          vertical: ResponsiveHelper.padding(6),
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.brandPrimary : AppColors.white,
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(100)),
          border: Border.all(
            color: isActive ? AppColors.brandPrimary : AppColors.borderDefault,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(11),
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.white : AppColors.textSecondary,
              ),
            ),
            if (showClose) ...[
              SizedBox(width: ResponsiveHelper.spacing(4)),
              Icon(
                Icons.close_rounded,
                size: ResponsiveHelper.iconSize(12),
                color: isActive ? AppColors.white : AppColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
