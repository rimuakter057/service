import 'package:flutter/material.dart';

import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import '../app_icon/app_icon.dart';

/// Icon-in-box + bold italic title + description + single CTA button, in
/// a light rounded card — used for empty states and blocked/disabled
/// states (e.g. Chat's "blocked provider" card, an empty "My Services"
/// list).
class AppStatusCard extends StatelessWidget {
  final String iconAsset;
  final Color iconBoxColor;
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onButtonTap;

  const AppStatusCard({
    super.key,
    required this.iconAsset,
    required this.iconBoxColor,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
      decoration: BoxDecoration(
        color: AppColors.bgOverlay.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: ResponsiveHelper.width(56),
            height: ResponsiveHelper.width(56),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBoxColor,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(16),
              ),
            ),
            child: AppIcon(
              assetPath: iconAsset,
              size: ResponsiveHelper.iconSize(32),
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(12)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(20),
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: AppColors.textBlackPrimary,
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(12)),
          Text(
            description,
            textAlign: TextAlign.center,
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey,
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(12)),
          GestureDetector(
            onTap: onButtonTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(24),
                vertical: ResponsiveHelper.padding(10),
              ),
              decoration: BoxDecoration(
                color: AppColors.brandPrimary,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(10),
                ),
              ),
              child: Text(
                buttonLabel,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
