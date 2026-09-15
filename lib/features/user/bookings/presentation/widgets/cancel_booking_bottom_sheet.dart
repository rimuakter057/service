import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_confirm_bottom_sheet/app_confirm_bottom_sheet.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Confirmation sheet shown before cancelling a booking — reached from the
/// Booking Details screen's "Cancel Booking" button.
class CancelBookingBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const CancelBookingBottomSheet({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AppConfirmBottomSheet(
      icon: Container(
        width: ResponsiveHelper.width(64),
        height: ResponsiveHelper.width(64),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.red.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(16),
          ),
        ),
        child: AppIcon(
          assetPath: AssetsPath.bookingsBookingDetailsIconCancelBooking,
          size: ResponsiveHelper.iconSize(38),
        ),
      ),
      title: AppText.cancelBookingExclaim,
      description: Text.rich(
        TextSpan(
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
          ),
          children: [
            TextSpan(
              text: AppText
                  .areYouSureYouWantToCancelThisBookingYourEligibleBookingAmountWillBeRefundedToYourAccountWithin,
            ),
            TextSpan(
              text: AppText.oneBusinessDay,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            TextSpan(text: AppText.afterTheCancellationIsProcessed),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      onConfirm: onConfirm,
    );
  }
}
