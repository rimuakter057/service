import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/core/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_details/provider_details_screen.dart';
import 'package:nchito/features/user/home/presentation/widgets/detail_field.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

/// Single booking — reached by tapping an item in Home's "Active Booking"
/// list.
class BookingDetailsScreen extends StatelessWidget {
  static const String routeName = '/booking-details';

  final HomeBookingData booking;

  const BookingDetailsScreen({super.key, required this.booking});

  Color get _statusColor {
    switch (booking.status) {
      case 'Confirmed':
        return AppColors.emerald400;
      case 'Cancelled':
        return AppColors.red400;
      default:
        return AppColors.orange400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.bookingDetails),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        BgIcon(
                          assetPath: booking.iconAsset,
                          bgColor: booking.iconBgColor,
                          iconColor: booking.iconColor,
                          bgSize: ResponsiveHelper.width(36),
                          radius: ResponsiveHelper.borderRadius(10),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(10)),
                        Text(
                          '${booking.service} ${AppText.service}',
                          style: context.labelMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(8)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(10),
                        vertical: ResponsiveHelper.padding(4),
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppIcon(
                            assetPath: AssetsPath.bookingDetailsIconDot,
                            size: ResponsiveHelper.iconSize(8),
                            color: _statusColor,
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(4)),
                          Text(
                            booking.status,
                            style: context.bodySmall.copyWith(
                              color: _statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),

                    DetailField(
                      label: AppText.location,
                      value: booking.location,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(12)),

                    DetailField(label: AppText.date, value: booking.date),
                    SizedBox(height: ResponsiveHelper.spacing(12)),

                    DetailField(label: AppText.time, value: booking.time),
                    SizedBox(height: ResponsiveHelper.spacing(12)),

                    DetailField(
                      label: AppText.details,
                      value: booking.details,
                      emphasizeValue: false,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(12)),

                    DetailField(
                      label: AppText.provider,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(8),
                            ),
                            child: AppIcon(
                              assetPath: booking.provider.photo,
                              size: ResponsiveHelper.width(28),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(8)),
                          Expanded(
                            child: Text(
                              booking.provider.name,
                              style: context.labelMedium.copyWith(
                                color: AppColors.textBlackPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.push(
                              ProviderDetailsScreen.routeName,
                              extra: booking.provider,
                            ),
                            icon: AppIcon(
                              assetPath: AssetsPath.logInIconEyeToggle,
                              size: ResponsiveHelper.iconSize(18),
                              color: AppColors.blueStatusInfo,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(24),
                vertical: ResponsiveHelper.padding(16),
              ),
              child: AppButton(
                text: AppText.cancelBooking,
                onPressed: () {},
                width: double.infinity,
                backgroundColor: AppColors.red400,
                textColor: AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
