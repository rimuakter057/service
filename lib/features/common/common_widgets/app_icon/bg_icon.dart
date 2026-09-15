import 'package:flutter/material.dart';

import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'app_icon.dart';

class BgIcon extends StatelessWidget {
  final String assetPath;
  final double? bgSize;
  final Color bgColor;
  final double? radius;
  final double? iconSize;
  final Color? iconColor;
  final bool showBorder;

  const BgIcon({
    super.key,
    required this.assetPath,
    this.bgSize,
    this.bgColor = AppColors.brandSoft,
    this.radius,
    this.iconSize,
    this.iconColor,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final containerBgHeight = bgSize ?? ResponsiveHelper.width(56);
    final containerBgWeight = bgSize ?? ResponsiveHelper.width(56);

    return Container(
      width: containerBgHeight,
      height: containerBgWeight,
      decoration: BoxDecoration(
        color: bgColor,
        border: showBorder
            ? Border.all(color: AppColors.iconBorderBg)
            : null,
        borderRadius: BorderRadius.circular(
          radius ?? ResponsiveHelper.borderRadius(16),
        ),
      ),
      child: Center(
        child: AppIcon(
          assetPath: assetPath,
          size: iconSize ?? ResponsiveHelper.iconSize(24),
          color: iconColor,
        ),
      ),
    );
  }
}
