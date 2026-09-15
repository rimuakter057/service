import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';
import '../booking_details/provider_booking_details_screen.dart';

class ProviderBookingConfirmedScreen extends StatelessWidget {
  static const String routeName = '/provider/bookings/booking-confirmed';

  final BookingHistoryData? booking;

  const ProviderBookingConfirmedScreen({super.key, this.booking});

  @override
  Widget build(BuildContext context) {
    final providerName = booking?.providerName ?? 'Roberts Junior';
    final serviceName = booking?.service ?? 'Electrical';
    final locationText = booking?.location ??
        'Plot 245, Kabulonga Road, Lusaka, Zambia';
    final dateTimeText = booking != null
        ? '${booking!.date} - ${booking!.time}'
        : 'Wed, July 5, 2026 - 7:00 p.m';
    final totalCostText =
        booking?.serviceCost ?? booking?.price ?? 'ZMW 525.00';

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F7),
      body: SafeArea(
        child: Column(
          children: [
            TopAppbar(
              title: AppText.bookAService,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(20),
                  vertical: ResponsiveHelper.padding(16),
                ),
                child: Column(
                  children: [
                    SizedBox(height: ResponsiveHelper.spacing(12)),

                    // Blue Scalloped Confirmation Badge
                    Center(
                      child: AppIcon(
                        assetPath: AssetsPath.myBookingsConfirmIcon,
                        size: ResponsiveHelper.iconSize(68),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    // Title
                    Text(
                      AppText.bookingConfirmed,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(22),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(6)),

                    // Subtitle
                    Text(
                      '${AppText.yourSessionWith} $providerName ${AppText.isScheduled}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(13),
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),

                    // Provider Summary Card
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(14),
                        vertical: ResponsiveHelper.padding(10),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1EFEA),
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(14),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(8),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(12)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                providerName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: ResponsiveHelper.fontSize(14),
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(3)),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 15,
                                    color: Color(0xFFF59E0B),
                                  ),
                                  SizedBox(width: ResponsiveHelper.spacing(3)),
                                  Text(
                                    '4.8',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: ResponsiveHelper.fontSize(12),
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    // Booking Details White Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(16),
                        ),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            icon: Icons.bolt_rounded,
                            iconColor: const Color(0xFFF97316),
                            iconBg: const Color(0xFFFFF7ED),
                            label: AppText.serviceType,
                            value: serviceName,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: Icons.location_on_outlined,
                            iconColor: const Color(0xFF059669),
                            iconBg: const Color(0xFFECFDF5),
                            label: AppText.location,
                            value: locationText,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: Icons.calendar_today_outlined,
                            iconColor: const Color(0xFF059669),
                            iconBg: const Color(0xFFECFDF5),
                            label: AppText.dateTime,
                            value: dateTimeText,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: Icons.calendar_month_outlined,
                            iconColor: const Color(0xFF059669),
                            iconBg: const Color(0xFFECFDF5),
                            label: AppText.totalCost,
                            value: totalCostText,
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: Icons.event_available_outlined,
                            iconColor: const Color(0xFF059669),
                            iconBg: const Color(0xFFECFDF5),
                            label: AppText.cancellationPolicy,
                            value: AppText.cancellationPolicyNotice,
                            isMultiLine: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),

                    // "See my bookings" Button
                    AppButton(
                      text: AppText.seeMyBookings,
                      onPressed: () {
                        final scheduledBooking = booking != null
                            ? booking!.copyWith(status: AppText.scheduled)
                            : BookingHistoryData(
                                iconAsset:
                                    AssetsPath.myBookingsServiceIconElectrical,
                                iconBgColor: const Color(0xFFDBEAFE),
                                providerName: 'Roberts Junior',
                                service: 'Electrical Service',
                                price: 'ZMW 525.00',
                                serviceCost: 'ZMW 525.00',
                                day: '23',
                                month: 'Feb',
                                date: '23 February 2026',
                                time: '6:00 PM',
                                status: AppText.scheduled,
                                location: 'Lusaka, Zambia',
                                details:
                                    'Join us for an evening of networking, live music, and curated drinks. Connect with professionals, entrepreneurs, and creatives in a relaxed rooftop setting.',
                                provider: robertJuniorProvider,
                              );
                        context.push(
                          ProviderBookingDetailsScreen.routeName,
                          extra: scheduledBooking,
                        );
                      },
                      width: double.infinity,
                      height: ResponsiveHelper.height(48),
                      radius: ResponsiveHelper.borderRadius(12),
                      backgroundColor: AppColors.brandPrimary,
                      textColor: Colors.white,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(14),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
    bool isMultiLine = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(14),
        vertical: ResponsiveHelper.padding(12),
      ),
      child: Row(
        crossAxisAlignment:
            isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            width: ResponsiveHelper.width(36),
            height: ResponsiveHelper.width(36),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(10),
              ),
            ),
            child: Icon(
              icon,
              size: ResponsiveHelper.iconSize(18),
              color: iconColor,
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(11),
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(2)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(12.5),
                    color: const Color(0xFF0F172A),
                    fontWeight: isMultiLine ? FontWeight.w500 : FontWeight.w700,
                    height: isMultiLine ? 1.35 : 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.8,
      color: Color(0xFFF1F5F9),
      indent: 14,
      endIndent: 14,
    );
  }
}
