import 'package:flutter/material.dart';

import '../../helper/responsive_helper/responsive_helper.dart';
import '../../utils/app_colors/app_colors.dart';
import 'app_icon.dart';

class BgIcon extends StatelessWidget {
  final String assetPath;
  final double? bgSize;
  final Color bgColor;
  final double? radius;
  final double? iconSize;
  final Color? iconColor;

  const BgIcon({
    super.key,
    required this.assetPath,
    this.bgSize,
    this.bgColor = AppColors.brandSoft,
    this.radius,
    this.iconSize,
    this.iconColor,
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
