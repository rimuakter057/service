import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_bottom_nav_bar/app_bottom_nav_bar.dart';
import 'package:nchito/features/common/common_widgets/app_search_bar/app_search_bar.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/user/bookings/presentation/screens/booking_details/booking_details_screen.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/booking_history_tile.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_filter_bottom_sheet.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';

class BookingsScreen extends StatefulWidget {
  static const String routeName = '/bookings';

  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
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
            const TopAppbar(title: AppText.myBookings),
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
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: ResponsiveHelper.spacing(6),
                      ),
                      child: AppSearchBar(
                        controller: _searchController,
                        onChanged: (value) =>
                            setState(() => _query = value),
                        onFilterTap: _onFilterTap,
                      ),
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
                      BookingDetailsScreen.routeName,
                      extra: booking,
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
