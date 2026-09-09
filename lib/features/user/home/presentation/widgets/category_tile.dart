import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';

/// Icon-in-a-circle + label, tappable — used for the "Selectable
/// Featured Service" category grid on Home.
class CategoryTile extends StatelessWidget {
  final String assetPath;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const CategoryTile({
    super.key,
    required this.assetPath,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BgIcon(
            assetPath: assetPath,
            bgColor: bgColor,
            iconColor: iconColor,
            bgSize: ResponsiveHelper.width(56),
            radius: ResponsiveHelper.borderRadius(16),
          ),
          SizedBox(height: ResponsiveHelper.spacing(8)),
          Text(
            label,
            textAlign: TextAlign.center,
            style: context.labelSmall.copyWith(
              color: AppColors.textBlackPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
