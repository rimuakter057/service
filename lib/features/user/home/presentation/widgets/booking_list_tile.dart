import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/features/common/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';

/// One row in an "Active Booking" list — service icon, provider/service
/// name, price, and a date/time badge on the right.
class BookingListTile extends StatelessWidget {
  final String iconAsset;
  final Color iconBgColor;
  final Color iconColor;
  final String providerName;
  final String service;
  final String price;
  final String date;
  final String time;
  final VoidCallback? onTap;

  const BookingListTile({
    super.key,
    required this.iconAsset,
    required this.iconBgColor,
    required this.iconColor,
    required this.providerName,
    required this.service,
    required this.price,
    required this.date,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppContainerBg(
        color: AppColors.white,
        border: Border.all(color: AppColors.borderDefault),
        child: Row(
          children: [
            BgIcon(
              assetPath: iconAsset,
              bgColor: iconBgColor,
              iconColor: iconColor,
              bgSize: ResponsiveHelper.width(44),
              radius: ResponsiveHelper.borderRadius(12),
            ),
            SizedBox(width: ResponsiveHelper.spacing(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(providerName, style: context.labelMedium),
                  SizedBox(height: ResponsiveHelper.spacing(2)),
                  Text(service, style: context.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.fontSize(10),
                    color: AppColors.textSecondary

                  )),
                  SizedBox(height: ResponsiveHelper.spacing(2)),
                  Text(price, style: context.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: ResponsiveHelper.fontSize(10),
                      color: AppColors.textBlackPrimary

                  )),

                ],
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(8)),
            _DateBadge(date: date, time: time),
          ],
        ),
      ),
    );
  }
}

/// Compact date+time badge shown on the right of a [BookingListTile].
/// Expects [date] in the format "DD MMM YYYY" (e.g. "25 Aug 2026").
class _DateBadge extends StatelessWidget {
  final String date;
  final String time;

  const _DateBadge({required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    // Split "25 Aug 2026" → day="25", monthYear="Aug 2026"
    final parts = date.split(' ');
    final day = parts.isNotEmpty ? parts[0] : date;
    final monthYear = parts.length >= 3
        ? '${parts[1]} ${parts[2]}'
        : parts.length == 2
            ? parts[1]
            : '';

    return AppContainerBg(
      border: Border.all(color: AppColors.borderDefault),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(10),
        vertical: ResponsiveHelper.padding(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: context.labelMedium.copyWith(
              fontSize: ResponsiveHelper.fontSize(13),
              fontWeight: FontWeight.w700,
              color: AppColors.textBlackPrimary,
              height: 1.0,
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(2)),
          Text(
            monthYear,
            style: context.bodySmall.copyWith(
              fontSize: ResponsiveHelper.fontSize(12),
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(2)),
          Text(
            time,
            style: context.bodySmall.copyWith(
              fontSize: ResponsiveHelper.fontSize(10),
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
