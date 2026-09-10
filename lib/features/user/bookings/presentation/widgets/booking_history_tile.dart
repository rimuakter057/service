import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';

/// One row in the My Bookings list — service icon, provider/service name,
/// price, and a day/month/time badge on the right.
class BookingHistoryTile extends StatelessWidget {
  final String iconAsset;
  final Color iconBgColor;
  final String providerName;
  final String service;
  final String price;
  final String day;
  final String month;
  final String time;
  final VoidCallback? onTap;

  const BookingHistoryTile({
    super.key,
    required this.iconAsset,
    required this.iconBgColor,
    required this.providerName,
    required this.service,
    required this.price,
    required this.day,
    required this.month,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppContainerBg(
        color: AppColors.white,
        border: Border.all(color: AppColors.bgOverlay.withValues(alpha: 0.04)),
        padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
        radius: ResponsiveHelper.borderRadius(14),
        child: Row(
          children: [
            Container(
              width: ResponsiveHelper.width(58),
              height: ResponsiveHelper.width(58),
              padding: EdgeInsets.all(ResponsiveHelper.padding(10)),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(11),
                ),
              ),
              child: AppIcon(assetPath: iconAsset, fit: BoxFit.contain),
            ),
            SizedBox(width: ResponsiveHelper.spacing(8)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    providerName,
                    style: context.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.fontSize(14),
                      color: AppColors.textBlackPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(4)),
                  Text(
                    service,
                    style: context.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.fontSize(10),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(4)),
                  Text(
                    price,
                    style: context.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: ResponsiveHelper.fontSize(10),
                      color: AppColors.textBlackPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(8)),
            _DateBadge(day: day, month: month, time: time),
          ],
        ),
      ),
    );
  }
}

/// Compact day/month/time badge shown on the right of a [BookingHistoryTile].
class _DateBadge extends StatelessWidget {
  final String day;
  final String month;
  final String time;

  const _DateBadge({required this.day, required this.month, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveHelper.width(58),
      height: ResponsiveHelper.width(58),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.bgOverlay.withValues(alpha: 0.04),
        border: Border.all(color: AppColors.textSecondary),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: context.bodySmall.copyWith(
              fontSize: ResponsiveHelper.fontSize(13),
              fontWeight: FontWeight.w700,
              color: AppColors.textBlackPrimary,
              height: 1.2,
            ),
          ),
          Text(
            month,
            style: context.bodySmall.copyWith(
              fontSize: ResponsiveHelper.fontSize(12),
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              height: 1.2,
            ),
          ),
          Text(
            time,
            style: context.bodySmall.copyWith(
              fontSize: ResponsiveHelper.fontSize(10),
              fontWeight: FontWeight.w700,
              color: AppColors.textGrey,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
