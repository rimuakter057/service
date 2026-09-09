import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/common_widgets/app_container_bg/app_container_bg.dart';
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

        ///service type=============================================
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${booking.service} ${AppText.service}',
                              style: context.labelMedium,
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(4)),

                            ///status=========================
                            AppContainerBg(
                              color: _statusColor.withValues(alpha: 0.12),
                              radius: 20,
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.padding(10),
                                vertical: ResponsiveHelper.padding(4),
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
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),),

                          ],
                        ),
                      ],
                    ),





                    SizedBox(height: ResponsiveHelper.spacing(20)),
///location========================================
                    DetailField(
                      label: AppText.location,
                      value: booking.location,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(12)),
///date======================================
                    DetailField(label: AppText.date, value: booking.date),
                    SizedBox(height: ResponsiveHelper.spacing(12)),
///time===================================
                    DetailField(label: AppText.time, value: booking.time),
                    SizedBox(height: ResponsiveHelper.spacing(12)),
///details==================================
                    DetailField(
                      label: AppText.details,
                      value: booking.details,
                      emphasizeValue: false,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(12)),
///provider==========================================
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
                          GestureDetector(
                            onTap: () => context.push(
                              ProviderDetailsScreen.routeName,
                              extra: booking.provider,
                            ),
                            child: BgIcon(
                              assetPath: AssetsPath.logInIconEyeToggle,
                              bgColor: const Color(0xFFDCE6F8),
                              iconColor: AppColors.blueStatusInfo,
                              bgSize: ResponsiveHelper.width(36),
                              radius: ResponsiveHelper.borderRadius(10),
                              iconSize: ResponsiveHelper.iconSize(16),
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

            ///cancel button ================================
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(24),
                vertical: ResponsiveHelper.padding(16),
              ),
              child: AppButton(
                text: AppText.cancelBooking,
                onPressed: () {},
                width: double.infinity,
                backgroundColor: AppColors.red,
                textColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
