import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_bottom_nav_bar/provider_bottom_nav_bar.dart';
import 'package:nchito/features/common/common_widgets/app_calendar/app_calendar.dart';
import 'package:nchito/features/common/common_widgets/app_search_bar/app_search_bar.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/provider/home/presentation/screens/home_screen/provider_home_screen.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/booking_history_tile.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_filter_bottom_sheet.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'provider_booking_details_screen.dart';

class ProviderBookingsScreen extends StatefulWidget {
  static const String routeName = '/provider/bookings';

  const ProviderBookingsScreen({super.key});

  @override
  State<ProviderBookingsScreen> createState() => _ProviderBookingsScreenState();
}

class _ProviderBookingsScreenState extends State<ProviderBookingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedFilter = AppText.allBookings;

  List<BookingHistoryData> get _filteredBookings {
    final query = _query.trim().toLowerCase();
    return myBookingsHistory.where((booking) {
      final matchesQuery = query.isEmpty ||
          booking.providerName.toLowerCase().contains(query) ||
          booking.service.toLowerCase().contains(query);
      final matchesFilter = _selectedFilter == AppText.allBookings ||
          booking.status.toLowerCase() == _selectedFilter.toLowerCase();
      return matchesQuery && matchesFilter;
    }).toList();
  }

  void _onFilterTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookingsFilterBottomSheet(
        currentFilter: _selectedFilter,
        onApply: (filter) {
          setState(() => _selectedFilter = filter);
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookings = _filteredBookings;

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
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(20),
                  vertical: ResponsiveHelper.padding(8),
                ),
                itemCount: bookings.length + 1,
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
                            onChanged: (value) =>
                                setState(() => _query = value),
                            onFilterTap: _onFilterTap,
                          ),
                        ),
                        const AppCalendar(),
                        SizedBox(height: ResponsiveHelper.spacing(14)),
                      ],
                    );
                  }
                  final booking = bookings[index - 1];
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
                      ProviderBookingDetailsScreen.routeName,
                      extra: booking,
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
