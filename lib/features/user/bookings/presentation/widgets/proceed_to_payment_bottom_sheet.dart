import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_confirm_bottom_sheet/app_confirm_bottom_sheet.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Confirmation sheet shown before paying for an accepted quote — reached
/// from the Booking Details screen's "Proceed to Pay" button.
class ProceedToPaymentBottomSheet extends StatelessWidget {
  final String serviceCost;
  final VoidCallback onConfirm;

  const ProceedToPaymentBottomSheet({
    super.key,
    required this.serviceCost,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AppConfirmBottomSheet(
      icon: Container(
        width: ResponsiveHelper.width(64),
        height: ResponsiveHelper.width(64),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.brandSoft,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(16),
          ),
        ),
        child: AppIcon(
          assetPath: AssetsPath.bookingsBookingDetailsIconProceedToPayment,
          size: ResponsiveHelper.iconSize(50),
        ),
      ),
      title: AppText.proceedToPaymentExclaim,
      description: Text.rich(
        TextSpan(
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
          ),
          children: [
            TextSpan(text: AppText.youReAboutToConfirmThisQuoteFor),
            TextSpan(
              text: serviceCost,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textBlackPrimary,
              ),
            ),
            TextSpan(
              text: AppText
                  .onceThePaymentIsCompletedTheAgreedPriceWillBeConfirmedForThisBooking,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      confirmColor: AppColors.brandPrimary,
      onConfirm: onConfirm,
    );
  }
}
