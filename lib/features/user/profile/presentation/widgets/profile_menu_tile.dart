import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';

/// Reusable profile menu tile widget built on top of [AppContainerBg].
/// Call this from the screen by passing the icon and text data.
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
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppContainerBg(
        color: tileBgColor ?? AppColors.bgCard,
        radius: ResponsiveHelper.borderRadius(16),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(16),
          vertical: ResponsiveHelper.padding(14),
        ),
        child: Row(
          children: [
            icon ??
                Container(
                  width: ResponsiveHelper.width(36),
                  height: ResponsiveHelper.width(36),
                  decoration: BoxDecoration(
                    color: iconBgColor ?? AppColors.brandSoft,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: assetPath != null
                      ? AppIcon(
                          assetPath: assetPath!,
                          size: ResponsiveHelper.iconSize(18),
                          color: iconColor ?? AppColors.brandPrimary,
                        )
                      : Icon(
                          iconData,
                          size: ResponsiveHelper.iconSize(18),
                          color: iconColor ?? AppColors.brandPrimary,
                        ),
                ),
            SizedBox(width: ResponsiveHelper.spacing(14)),
            Expanded(
              child: Text(
                title,
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: titleColor ?? AppColors.textBlackPrimary,
                ),
              ),
            ),
            if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                size: ResponsiveHelper.iconSize(20),
                color: AppColors.textBlackPrimary,
              ),
          ],
        ),
      ),
    );
  }
}
