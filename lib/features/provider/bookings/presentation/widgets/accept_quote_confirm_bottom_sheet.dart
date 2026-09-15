import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_confirm_bottom_sheet/app_confirm_bottom_sheet.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Confirmation sheet shown when a provider confirms accepting and sending a pricing quote.
class AcceptQuoteConfirmBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const AcceptQuoteConfirmBottomSheet({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AppConfirmBottomSheet(
      icon: AppIcon(
        assetPath: AssetsPath.bookServiceIconInformationLarge,
        size: ResponsiveHelper.iconSize(72),
      ),
      title: AppText.acceptAndSendPricingQuoteExclaim,
      description: Text(
        AppText
            .areYouSureYouWantToAcceptThisBookingRequestAndSendAPricingQuoteToTheCustomer,
        textAlign: TextAlign.center,
        style: context.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.textGrey,
          height: 1.4,
        ),
      ),
      confirmColor: AppColors.brandPrimary,
      onConfirm: onConfirm,
    );
  }
}
