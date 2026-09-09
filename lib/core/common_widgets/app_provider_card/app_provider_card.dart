import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// A reusable provider summary card used in both the Home screen
/// ("Popular Near You") and the Explore Provider results grid.
///
/// Pass [badgeIconAsset], [badgeBgColor], and [badgeIconColor] to show a
/// service-category badge in the info row. When omitted the badge is hidden.
class AppProviderCard extends StatelessWidget {
  final String photo;
  final String name;
  final String service;
  final String price;
  final String rating;

  /// Optional badge shown next to the provider name (Explore screen).
  final String? badgeIconAsset;
  final Color? badgeBgColor;
  final Color? badgeIconColor;

  final VoidCallback? onTap;

  const AppProviderCard({
    super.key,
    required this.photo,
    required this.name,
    required this.service,
    required this.price,
    required this.rating,
    this.badgeIconAsset,
    this.badgeBgColor,
    this.badgeIconColor,
    this.onTap,
  });

  bool get _hasBadge =>
      badgeIconAsset != null && badgeBgColor != null && badgeIconColor != null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppContainerBg(
        color: Colors.white,
        padding: EdgeInsets.zero,
        radius: ResponsiveHelper.borderRadius(12),
        border: Border.all(
          color: AppColors.borderDefault.withValues(alpha: 0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Photo ────────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(ResponsiveHelper.borderRadius(12)),
              ),
              child: AppIcon(
                assetPath: photo,
                width: double.infinity,
                height: ResponsiveHelper.height(134),
                fit: BoxFit.cover,
              ),
            ),

            // ── Info ─────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.all(ResponsiveHelper.padding(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name + service row (with optional badge)
                  Row(
                    children: [
                      if (_hasBadge) ...[
                        BgIcon(
                          assetPath: badgeIconAsset!,
                          bgColor: badgeBgColor!,
                          iconColor: badgeIconColor!,
                          bgSize: ResponsiveHelper.width(32),
                          iconSize: ResponsiveHelper.iconSize(14),
                          radius: ResponsiveHelper.borderRadius(9),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(6)),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: context.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBlackPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              service,
                              style: context.bodyMedium.copyWith(
                                fontSize: ResponsiveHelper.fontSize(10),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: ResponsiveHelper.spacing(8)),

                  /// Divider
                  Container(
                    height: 1,
                    color: AppColors.borderDefault.withValues(alpha: 0.5),
                  ),

                  SizedBox(height: ResponsiveHelper.spacing(8)),

                  /// Price | Rating row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _CardLabeledValue(
                          label: AppText.startsFrom,
                          value: price,
                        ),
                      ),
                      Container(
                        width: 0.5,
                        height: ResponsiveHelper.height(24),
                        color: AppColors.borderDefault,
                      ),
                      SizedBox(width: ResponsiveHelper.spacing(8)),
                      Expanded(
                        child: _CardLabeledValue(
                          label: AppText.reviews,
                          valueWidget: Row(
                            children: [
                              AppIcon(
                                assetPath: AssetsPath.iconStar,
                                size: ResponsiveHelper.iconSize(10),
                              ),
                              SizedBox(width: ResponsiveHelper.spacing(2)),
                              Text(
                                rating,
                                style: context.bodySmall.copyWith(
                                  fontSize: ResponsiveHelper.fontSize(10),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlackPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

// ── Internal helper ────────────────────────────────────────────────────────────

class _CardLabeledValue extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? valueWidget;

  const _CardLabeledValue({
    required this.label,
    this.value,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: context.bodySmall.copyWith(
            fontSize: ResponsiveHelper.fontSize(8),
            fontStyle: FontStyle.italic,
            color: AppColors.textGrey,
          ),
        ),
        SizedBox(height: ResponsiveHelper.spacing(2)),
        valueWidget ??
            Text(
              value ?? '',
              overflow: TextOverflow.ellipsis,
              style: context.bodySmall.copyWith(
                fontSize: ResponsiveHelper.fontSize(10),
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackPrimary,
              ),
            ),
      ],
    );
  }
}
