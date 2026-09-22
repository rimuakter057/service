import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/features/common/common_widgets/app_shimmer/app_shimmer.dart';

/// Single booking card shimmer placeholder
class BookingTileShimmer extends StatelessWidget {
  const BookingTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainerBg(
      color: AppColors.white,
      border: Border.all(color: AppColors.bgOverlay.withValues(alpha: 0.04)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
      radius: ResponsiveHelper.borderRadius(14),
      child: Row(
        children: [
          // Icon box placeholder
          ShimmerBox(
            width: ResponsiveHelper.width(58),
            height: ResponsiveHelper.width(58),
            borderRadius: ResponsiveHelper.borderRadius(11),
          ),
          SizedBox(width: ResponsiveHelper.spacing(8)),

          // Info placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShimmerBox(
                  width: ResponsiveHelper.width(130),
                  height: ResponsiveHelper.height(14),
                  borderRadius: 4,
                ),
                SizedBox(height: ResponsiveHelper.spacing(6)),
                ShimmerBox(
                  width: ResponsiveHelper.width(90),
                  height: ResponsiveHelper.height(10),
                  borderRadius: 4,
                ),
                SizedBox(height: ResponsiveHelper.spacing(6)),
                ShimmerBox(
                  width: ResponsiveHelper.width(70),
                  height: ResponsiveHelper.height(10),
                  borderRadius: 4,
                ),
              ],
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(8)),

          // Date badge placeholder
          ShimmerBox(
            width: ResponsiveHelper.width(58),
            height: ResponsiveHelper.width(58),
            borderRadius: ResponsiveHelper.borderRadius(8),
          ),
        ],
      ),
    );
  }
}

/// Full list of booking tile shimmers for initial screen load
class BookingListShimmer extends StatelessWidget {
  final int itemCount;

  const BookingListShimmer({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: itemCount,
        separatorBuilder: (_, __) =>
            SizedBox(height: ResponsiveHelper.spacing(10)),
        itemBuilder: (_, __) => const BookingTileShimmer(),
      ),
    );
  }
}
