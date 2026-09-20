import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';

/// Icon-in-a-circle + label, tappable — used for the "Selectable
/// Featured Service" category grid on Home.
class CategoryTile extends StatelessWidget {
  final String? assetPath;
  final String? iconUrl;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const CategoryTile({
    super.key,
    this.assetPath,
    this.iconUrl,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    this.onTap,
  });

  Widget _buildIcon() {
    final size = ResponsiveHelper.iconSize(24);
    if (iconUrl != null && iconUrl!.startsWith('http')) {
      if (iconUrl!.toLowerCase().endsWith('.svg')) {
        return SvgPicture.network(
          iconUrl!,
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        );
      }
      return Image.network(
        iconUrl!,
        width: size,
        height: size,
        color: iconColor,
        errorBuilder: (_, __, ___) => assetPath != null
            ? AppIcon(assetPath: assetPath!, size: size, color: iconColor)
            : Icon(Icons.category_outlined, size: size, color: iconColor),
      );
    }

    if (assetPath != null) {
      return AppIcon(
        assetPath: assetPath!,
        size: size,
        color: iconColor,
      );
    }

    return Icon(Icons.category_outlined, size: size, color: iconColor);
  }

  @override
  Widget build(BuildContext context) {
    final bgSize = ResponsiveHelper.width(56);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: bgSize,
            height: bgSize,
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: AppColors.iconBorderBg),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(16),
              ),
            ),
            child: Center(child: _buildIcon()),
          ),
          SizedBox(height: ResponsiveHelper.spacing(8)),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.labelSmall.copyWith(
              color: AppColors.textBlackPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
