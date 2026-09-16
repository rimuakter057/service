import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_confirm_bottom_sheet/app_confirm_bottom_sheet.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';

/// Bottom sheet dialog prompting the provider to complete all setup steps
/// (verification, availability, payments) before adding their first service.
class CompleteSetupFirstBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const CompleteSetupFirstBottomSheet({
    super.key,
    required this.onConfirm,
  });

  /// Static helper to display this bottom sheet from any widget with a clean 1-liner call.
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (_) => CompleteSetupFirstBottomSheet(
        onConfirm: onConfirm ?? () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppConfirmBottomSheet(
      icon: AppIcon(
        assetPath: AssetsPath.updateProfileIconInformation,
        size: ResponsiveHelper.iconSize(72),
      ),
      title: AppText.completeYourSetupFirst,
      description: Text(
        AppText
            .beforeCreatingYourFirstServicePleaseCompleteAllRequiredProviderSetupSteps,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: ResponsiveHelper.fontSize(12.5),
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.4,
        ),
      ),
      confirmLabel: AppText.confirm,
      confirmColor: const Color(0xFF0F3E2E),
      onConfirm: onConfirm,
    );
  }
}
