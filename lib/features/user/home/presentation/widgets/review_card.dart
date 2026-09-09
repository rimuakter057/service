import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

import 'home_sample_data.dart';

/// One review row — initials avatar, name/rating/date, comment. Built on
/// the common [AppContainerBg] so it matches the rest of the app's cards.
class ReviewCard extends StatelessWidget {
  final ReviewData review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return AppContainerBg(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: ResponsiveHelper.width(20),
            backgroundColor: review.avatarColor,
            child: Text(
              review.initials,
              style: context.labelMedium.copyWith(
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        review.name,
                        style: context.labelMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppIcon(
                      assetPath: AssetsPath.providerDetailsIconStar,
                      size: ResponsiveHelper.iconSize(12),
                    ),
                    SizedBox(width: ResponsiveHelper.spacing(2)),
                    Text(review.rating, style: context.bodySmall),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.spacing(2)),
                Text(
                  review.date,
                  style: context.bodySmall.copyWith(color: AppColors.textGrey),
                ),
                SizedBox(height: ResponsiveHelper.spacing(6)),
                Text(review.comment, style: context.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
