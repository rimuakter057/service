import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_bottom_nav_bar/provider_bottom_nav_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/provider/bookings/presentation/providers/provider_bookings_notifier.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/booking_details/provider_booking_details_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/provider_booking_sample_data.dart';
import 'package:nchito/features/provider/home/presentation/widgets/provider_booking_tile.dart';
import 'package:nchito/features/provider/home/presentation/widgets/provider_home_header.dart';
import 'package:nchito/features/provider/home/presentation/widgets/provider_overview_stats.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/booking_tile_shimmer.dart';
import 'package:nchito/features/user/home/presentation/widgets/section_header.dart';
import 'package:nchito/features/user/notifications/presentation/screens/notifications_screen.dart';

/// Provider Home screen — today's overview stats, new booking requests,
/// and today's bookings. Reached from the provider bottom nav's "Home" tab.
///
/// Both sections use the real API:
///  - "New Booking Requests" → `GET /provider/bookings/?group=pending`
///  - "Today's Bookings"     → `GET /provider/bookings/?today=true`
/// Stats (pending / today / upcoming) are derived from the same responses.
class ProviderHomeScreen extends StatefulWidget {
  static const String routeName = '/provider/home';

  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  bool _pendingLoading = false;
  bool _todayLoading = false;

  List<ProviderBookingData> _pendingBookings = [];
  List<ProviderBookingData> _todayBookings = [];
  List<ProviderBookingData> _upcomingBookings = [];

  String? _pendingError;
  String? _todayError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAll());
  }

  Future<void> _loadAll() async {
    await Future.wait([_loadPending(), _loadToday()]);
  }

  /// Fetch pending (new booking requests) via group=pending.
  Future<void> _loadPending() async {
    if (!mounted) return;
    setState(() {
      _pendingLoading = true;
      _pendingError = null;
    });
    try {
      // Use a one-off repository call scoped to pending/upcoming groups.
      final result = await _fetchGroup('pending', pageSize: 10);
      if (!mounted) return;
      setState(() {
        _pendingBookings = result;
        _pendingLoading = false;
      });
      // Also fetch upcoming for the overview stat
      final upcoming = await _fetchGroup('upcoming', pageSize: 10);
      if (!mounted) return;
      setState(() => _upcomingBookings = upcoming);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _pendingError = 'Failed to load requests.';
        _pendingLoading = false;
      });
    }
  }

  /// Fetch today's bookings via today=true.
  Future<void> _loadToday() async {
    if (!mounted) return;
    setState(() {
      _todayLoading = true;
      _todayError = null;
    });
    try {
      final result = await _fetchToday(pageSize: 10);
      if (!mounted) return;
      setState(() {
        _todayBookings = result;
        _todayLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _todayError = 'Failed to load today\'s bookings.';
        _todayLoading = false;
      });
    }
  }

  /// Calls the provider bookings API for a specific group (pending, upcoming…).
  Future<List<ProviderBookingData>> _fetchGroup(
    String group, {
    int pageSize = 10,
  }) async {
    // We create an isolated ProviderBookingsNotifier instance so that
    // loading requests on home screen doesn't mutate or overwrite the
    // main Bookings tab notifier state.
    final tempNotifier = ProviderBookingsNotifier();
    await tempNotifier._fetchGroupDirect(group: group, pageSize: pageSize);
    final data = tempNotifier.bookingEntries;
    tempNotifier.dispose();
    return data;
  }

  Future<List<ProviderBookingData>> _fetchToday({int pageSize = 10}) async {
    final tempNotifier = ProviderBookingsNotifier();
    await tempNotifier._fetchTodayDirect(pageSize: pageSize);
    final data = tempNotifier.bookingEntries;
    tempNotifier.dispose();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ProviderHomeHeader(
            onNotificationTap: () =>
                context.push(NotificationsScreen.routeName),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: RefreshIndicator(
                color: AppColors.brandPrimary,
                onRefresh: _loadAll,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.padding(20),
                    vertical: ResponsiveHelper.padding(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Today's Overview Stats ──────────────────────────
                      SectionHeader(
                        title: AppText.todaysOverview,
                        actionLabel: AppText.viewCalendar,
                        onViewAllTap: () {},
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(16)),
                      ProviderOverviewStats(
                        pendingRequests: _pendingLoading
                            ? '–'
                            : _pendingBookings.length.toString().padLeft(2, '0'),
                        upcomingBookings: _pendingLoading
                            ? '–'
                            : _upcomingBookings.length.toString().padLeft(2, '0'),
                        todaysBookings: _todayLoading
                            ? '–'
                            : _todayBookings.length.toString().padLeft(2, '0'),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(24)),

                      // ── New Booking Requests (pending) ──────────────────
                      SectionHeader(
                        title: AppText.newBookingRequests,
                        onViewAllTap: () {},
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(16)),
                      if (_pendingLoading)
                        ..._shimmerList(3)
                      else if (_pendingError != null)
                        _ErrorRow(message: _pendingError!, onRetry: _loadPending)
                      else if (_pendingBookings.isEmpty)
                        _EmptyRow(label: AppText.noPendingRequestsYet)
                      else
                        for (final booking in _pendingBookings) ...[
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

                      // ── Today's Bookings (today=true) ───────────────────
                      SectionHeader(
                        title: AppText.todaysBookings,
                        onViewAllTap: () {},
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(16)),
                      if (_todayLoading)
                        ..._shimmerList(2)
                      else if (_todayError != null)
                        _ErrorRow(message: _todayError!, onRetry: _loadToday)
                      else if (_todayBookings.isEmpty)
                        _EmptyRow(label: AppText.noBookingsForToday)
                      else
                        for (final booking in _todayBookings) ...[
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

                      SizedBox(height: ResponsiveHelper.spacing(20)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const ProviderBottomNavBar(currentIndex: 0),
    );
  }

  List<Widget> _shimmerList(int count) => List.generate(
        count,
        (_) => Padding(
          padding: EdgeInsets.only(bottom: ResponsiveHelper.spacing(10)),
          child: const BookingTileShimmer(),
        ),
      );
}

// ── Private helpers ─────────────────────────────────────────────────────────

class _ErrorRow extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorRow({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(
              color: AppColors.red,
              fontSize: ResponsiveHelper.fontSize(12),
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(8)),
          GestureDetector(
            onTap: onRetry,
            child: Text(
              'Retry',
              style: TextStyle(
                color: AppColors.brandPrimary,
                fontSize: ResponsiveHelper.fontSize(12),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyRow extends StatelessWidget {
  final String label;

  const _EmptyRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(12)),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: ResponsiveHelper.fontSize(13),
          ),
        ),
      ),
    );
  }
}

/// Extension on [ProviderBookingsNotifier] exposing direct fetch methods
/// used only by the Home screen's private helper — avoids mutating the
/// app-wide notifier state.
extension _ProviderBookingsNotifierHomeExt on ProviderBookingsNotifier {
  Future<void> _fetchGroupDirect({
    required String group,
    int pageSize = 10,
  }) async {
    await applyFilter(group);
  }

  Future<void> _fetchTodayDirect({int pageSize = 10}) async {
    await fetchTodaysBookings();
  }
}
