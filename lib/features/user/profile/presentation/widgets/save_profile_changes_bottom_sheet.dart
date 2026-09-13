import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_confirm_bottom_sheet/app_confirm_bottom_sheet.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Confirmation sheet shown before saving profile changes — reached from
/// the Update Profile screen's "Save the changes" button.
class SaveProfileChangesBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const SaveProfileChangesBottomSheet({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AppConfirmBottomSheet(
      icon: AppIcon(
        assetPath: AssetsPath.updateProfileIconInformation,
        size: ResponsiveHelper.iconSize(72),
      ),
      title: AppText.saveProfileChangesExclaim,
      description: Text(
        AppText
            .areYouSureYouWantToSaveYourProfileChangesYourUpdatedInformationWillBeAppliedToYourAccount,
        textAlign: TextAlign.center,
        style: context.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.textGrey,
        ),
      ),
      confirmColor: AppColors.brandPrimary,
      onConfirm: onConfirm,
    );
  }
}
