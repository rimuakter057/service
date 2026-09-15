import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/app_theme/app_theme.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Second-step account-deletion sheet — asks for the password before the
/// destructive action is carried out. Reached from
/// [DeleteAccountBottomSheet]'s "Confirm" button.
class ConfirmAccountDeletionBottomSheet extends StatefulWidget {
  final VoidCallback onConfirm;

  const ConfirmAccountDeletionBottomSheet({super.key, required this.onConfirm});

  @override
  State<ConfirmAccountDeletionBottomSheet> createState() =>
      _ConfirmAccountDeletionBottomSheetState();
}

class _ConfirmAccountDeletionBottomSheetState
    extends State<ConfirmAccountDeletionBottomSheet> {
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: ResponsiveHelper.padding(20),
            right: ResponsiveHelper.padding(20),
            top: ResponsiveHelper.padding(20),
            bottom: ResponsiveHelper.padding(44),
          ),
          decoration: BoxDecoration(
            color: AppColors.bgApp,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(ResponsiveHelper.borderRadius(24)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppText.confirmAccountDeletion,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlackPrimary,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: AppIcon(
                      assetPath: AssetsPath.accountSettingsIconClose,
                      size: ResponsiveHelper.iconSize(22),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.spacing(16)),

              Text(AppText.enterYourPassword, style: context.labelLarge),
              SizedBox(height: ResponsiveHelper.spacing(8)),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: context.bodyMedium,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: AppIcon(
                      assetPath: AssetsPath.logInIconEyeToggle,
                      size: ResponsiveHelper.iconSize(16),
                      color: AppTheme.inputIconColor,
                    ),
                    onPressed: () => setState(
                      () => _obscurePassword = !_obscurePassword,
                    ),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(16)),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: ResponsiveHelper.width(24),
                    height: ResponsiveHelper.width(24),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(4),
                      ),
                    ),
                    child: Icon(
                      Icons.error_outline_rounded,
                      size: ResponsiveHelper.iconSize(14),
                      color: AppColors.red,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(6)),
                  Expanded(
                    child: Text(
                      AppText
                          .forSecurityReasonsWeNeedYourPasswordToContinueOnceDeletedYourAccountAndAssociatedDataCannotBeRestored,
                      style: context.bodySmall.copyWith(
                        fontSize: ResponsiveHelper.fontSize(12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.spacing(24)),

              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: AppText.cancel,
                      onPressed: () => Navigator.of(context).pop(),
                      backgroundColor: AppColors.bgOverlay.withValues(
                        alpha: 0.04,
                      ),
                      borderColor: AppColors.textDisabled,
                      textColor: AppColors.textDisabled,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(14)),
                  Expanded(
                    child: AppButton(
                      text: AppText.confirmAndDelete,
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onConfirm();
                      },
                      backgroundColor: AppColors.red,
                      textColor: AppColors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
