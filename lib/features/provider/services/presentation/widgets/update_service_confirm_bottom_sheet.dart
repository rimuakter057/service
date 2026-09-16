import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_confirm_bottom_sheet/app_confirm_bottom_sheet.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';

/// Confirmation bottom sheet when updating/saving changes to a service.
class UpdateServiceConfirmBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const UpdateServiceConfirmBottomSheet({
    super.key,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (_) => UpdateServiceConfirmBottomSheet(
        onConfirm: onConfirm,
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
      title: AppText.updateServiceExclaim,
      description: Text(
        AppText.areYouSureYouWantToSaveTheseChanges,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: ResponsiveHelper.fontSize(13),
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
