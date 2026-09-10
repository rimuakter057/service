import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_confirm_bottom_sheet/app_confirm_bottom_sheet.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Confirmation sheet shown before declining an accepted quote — reached
/// from the Booking Details screen's "Decline Quote" button.
class DeclineQuoteBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeclineQuoteBottomSheet({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AppConfirmBottomSheet(
      icon: AppIcon(
        assetPath: AssetsPath.bookingsBookingDetailsIconDeclineWarning,
        size: ResponsiveHelper.iconSize(72),
      ),
      title: AppText.declineQuoteExclaim,
      description: Text(
        AppText
            .areYouSureYouWantToDeclineThisQuoteTheBookingWillBeMarkedAsCancelledAndYouWontBeAbleToProceedWithThisQuote,
        textAlign: TextAlign.center,
        style: context.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.textGrey,
        ),
      ),
      onConfirm: onConfirm,
    );
  }
}
