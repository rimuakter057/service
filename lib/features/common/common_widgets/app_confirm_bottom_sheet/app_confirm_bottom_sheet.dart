import 'package:flutter/material.dart';

import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import '../app_button/app_button.dart';

/// Reusable "are you sure?" confirmation sheet — icon, italic title,
/// centered description, then a muted Cancel button beside a colored
/// Confirm button. Used for destructive/important confirmations (cancel
/// booking, decline quote, etc.) so every screen gets the same shape.
class AppConfirmBottomSheet extends StatelessWidget {
  final Widget icon;
  final String title;
  final Widget description;
  final String cancelLabel;
  final String confirmLabel;
  final Color confirmColor;
  final VoidCallback onConfirm;

  const AppConfirmBottomSheet({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.cancelLabel = AppText.cancel,
    this.confirmLabel = AppText.confirm,
    this.confirmColor = AppColors.red,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
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
          children: [
            icon,
            SizedBox(height: ResponsiveHelper.spacing(14)),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(20),
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: AppColors.textBlackPrimary,
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(14)),
            description,
            SizedBox(height: ResponsiveHelper.spacing(24)),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: cancelLabel,
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
                    text: confirmLabel,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    backgroundColor: confirmColor,
                    textColor: AppColors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
