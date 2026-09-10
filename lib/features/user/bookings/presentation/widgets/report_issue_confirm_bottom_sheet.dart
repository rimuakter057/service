import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

/// Confirmation sheet shown when the user taps "Submit Issue" from the Report
/// an Issue sheet (matching Screenshot 2).
class ReportIssueConfirmBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const ReportIssueConfirmBottomSheet({
    super.key,
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
          top: ResponsiveHelper.padding(24),
          bottom: ResponsiveHelper.padding(32),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ResponsiveHelper.borderRadius(24)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Scalloped Amber Badge with exclamation mark
            SizedBox(
              width: ResponsiveHelper.width(68),
              height: ResponsiveHelper.width(68),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (int i = 0; i < 3; i++)
                    Transform.rotate(
                      angle: i * (math.pi / 6),
                      child: Container(
                        width: ResponsiveHelper.width(56),
                        height: ResponsiveHelper.width(56),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(14),
                          ),
                        ),
                      ),
                    ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: ResponsiveHelper.width(5),
                        height: ResponsiveHelper.height(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(3)),
                      Container(
                        width: ResponsiveHelper.width(5),
                        height: ResponsiveHelper.width(5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(16)),

            // Title: "Submit Issue!" (bold, italic)
            Text(
              AppText.submitIssueExclaim,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(19),
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(10)),

            // Subtitle
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(12),
              ),
              child: Text(
                AppText.areYouSureYouWantToSubmitThisIssue,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(12.5),
                  color: const Color(0xFF64748B),
                  height: 1.45,
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(24)),

            // Actions: Cancel & Confirm
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
                    text: AppText.confirm,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    backgroundColor: AppColors.brandPrimary,
                    textColor: Colors.white,
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
