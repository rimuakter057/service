import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ResponsiveHelper.width(40),
                height: ResponsiveHelper.width(40),
                decoration: BoxDecoration(
                  color: AppColors.brandSoft,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.brandPrimary,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  review.initials,
                  style: context.labelMedium.copyWith(
                    color: AppColors.brandPrimary,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.spacing(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: context.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(4)),
                    Row(
                      children: [
                        AppIcon(
                          assetPath: AssetsPath.providerDetailsIconStar,
                          size: ResponsiveHelper.iconSize(12),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(3)),
                        Text(
                          review.rating.contains('/5.0')
                              ? review.rating
                              : '${review.rating}/5.0',
                          style: context.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                review.date,
                style: context.bodySmall.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.spacing(12)),
          Text(
            review.comment,
            style: context.bodyMedium,
          ),
        ],
      ),
    );
  }
}
