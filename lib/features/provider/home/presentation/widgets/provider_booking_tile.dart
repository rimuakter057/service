import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';

/// Booking row on the Provider Home screen — customer, service, price on
/// the left, and a date/time chip on the right. Used for both "New
/// Booking Requests" and "Today's Bookings".
class ProviderBookingTile extends StatelessWidget {
  final String customerName;
  final String service;
  final String price;
  final String iconAsset;
  final Color iconBgColor;
  final String day;
  final String month;
  final String time;
  final VoidCallback? onTap;

  const ProviderBookingTile({
    super.key,
    required this.customerName,
    required this.service,
    required this.price,
    required this.iconAsset,
    required this.iconBgColor,
    required this.day,
    required this.month,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.bgOverlay.withValues(alpha: 0.04)),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(14),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveHelper.width(58),
              height: ResponsiveHelper.width(58),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(11),
                ),
              ),
              child: AppIcon(
                assetPath: iconAsset,
                size: ResponsiveHelper.iconSize(26),
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(8)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    customerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlackPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(4)),
                  Text(
                    service,
                    style: context.bodySmall.copyWith(
                      fontSize: ResponsiveHelper.fontSize(10),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(4)),
                  Text(
                    price,
                    style: context.bodySmall.copyWith(
                      fontSize: ResponsiveHelper.fontSize(10),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlackPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: ResponsiveHelper.width(58),
              height: ResponsiveHelper.width(58),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.bgOverlay.withValues(alpha: 0.04),
                border: Border.all(color: AppColors.textSecondary),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(8),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    day,
                    style: context.bodySmall.copyWith(
                      fontSize: ResponsiveHelper.fontSize(13),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlackPrimary,
                    ),
                  ),
                  Text(
                    month,
                    style: context.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    time,
                    style: context.bodySmall.copyWith(
                      fontSize: ResponsiveHelper.fontSize(10),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
