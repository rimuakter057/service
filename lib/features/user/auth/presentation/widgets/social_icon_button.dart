import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';

class SocialIconButton extends StatelessWidget {
  final String assetPath;

  const SocialIconButton({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveHelper.width(52),
      height: ResponsiveHelper.width(52),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Center(
        child: SvgPicture.asset(
          assetPath,
          width: ResponsiveHelper.iconSize(24),
          height: ResponsiveHelper.iconSize(24),
        ),
      ),
    );
  }
}
