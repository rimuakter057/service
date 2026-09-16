import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';

/// Reusable profile menu tile widget built on top of [AppContainerBg].
/// Used across User and Provider profile and settings screens.
class ProfileMenuTile extends StatelessWidget {
  final IconData? iconData;
  final String? assetPath;
  final Widget? icon;
  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? iconBgColor;
  final Color? tileBgColor;
  final Color? titleColor;
  final bool showChevron;
  final double? radius;
  final EdgeInsetsGeometry? contentPadding;
  final double? iconBoxSize;

  /// Corner radius of the icon box. Defaults to a full circle when null.
  final double? iconBoxRadius;
  final double? chevronSize;

  const ProfileMenuTile({
    super.key,
    this.iconData,
    this.assetPath,
    this.icon,
    required this.title,
    this.onTap,
    this.iconColor,
    this.iconBgColor,
    this.tileBgColor,
    this.titleColor,
    this.showChevron = true,
    this.radius,
    this.contentPadding,
    this.iconBoxSize,
    this.iconBoxRadius,
    this.chevronSize,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconBoxSize = iconBoxSize ?? ResponsiveHelper.width(36);

    return GestureDetector(
      onTap: onTap,
      child: AppContainerBg(
        color: tileBgColor ?? AppColors.bgCard,
        radius: radius ?? ResponsiveHelper.borderRadius(16),
        padding:
            contentPadding ??
            EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.padding(16),
              vertical: ResponsiveHelper.padding(14),
            ),
        child: Row(
          children: [
            Container(
              width: resolvedIconBoxSize,
              height: resolvedIconBoxSize,
              decoration: BoxDecoration(
                color: iconBgColor ?? AppColors.bgApp,
                borderRadius: BorderRadius.circular(
                  iconBoxRadius ?? resolvedIconBoxSize / 2,
                ),
              ),
              child: Center(
                child:
                    icon ??
                    (assetPath != null
                        ? AppIcon(
                            assetPath: assetPath!,
                            size: ResponsiveHelper.iconSize(18),
                            color: iconColor ?? AppColors.brandPrimary,
                          )
                        : Icon(
                            iconData,
                            size: ResponsiveHelper.iconSize(18),
                            color: iconColor ?? AppColors.brandPrimary,
                          )),
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(14)),
            Expanded(
              child: Text(
                title,
                style: context.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: titleColor ?? AppColors.textBlackPrimary,
                ),
              ),
            ),
            if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                size: chevronSize ?? ResponsiveHelper.iconSize(20),
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
