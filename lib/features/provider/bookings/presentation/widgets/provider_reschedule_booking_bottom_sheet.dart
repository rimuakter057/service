import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_confirm_bottom_sheet/app_confirm_bottom_sheet.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Confirmation bottom sheet shown before a provider reschedules a booking.
class ProviderRescheduleBookingBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const ProviderRescheduleBookingBottomSheet({
    super.key,
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
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(16),
          ),
        ),
        child: AppIcon(
          assetPath: AssetsPath.bookingsBookingDetailsIconReschedule,
          size: ResponsiveHelper.iconSize(36),
        ),
      ),
      title: AppText.rescheduleBookingExclaim,
      description: Text(
        AppText.youReAboutToProposeANewDateAndTimeForThisBooking,
        style: context.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.textGrey,
          fontSize: ResponsiveHelper.fontSize(12),
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
      cancelLabel: AppText.cancel,
      confirmLabel: AppText.confirm,
      confirmColor: AppColors.brandPrimary,
      onConfirm: onConfirm,
    );
  }
}
