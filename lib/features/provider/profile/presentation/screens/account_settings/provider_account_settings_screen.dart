import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_confirm_bottom_sheet/app_confirm_bottom_sheet.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/features/common/common_widgets/profile_menu_tile/profile_menu_tile.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/provider/profile/presentation/screens/change_password/provider_change_password_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/linked_payment_account/provider_linked_payment_account_screen.dart';

/// Provider account settings screen with 3 options:
/// 1. Change Password
/// 2. Linked Payment Account
/// 3. Delete account
class ProviderAccountSettingsScreen extends StatelessWidget {
  static const String routeName = '/provider/account-settings';

  const ProviderAccountSettingsScreen({super.key});

  void _onDeleteAccountTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (ctx) => AppConfirmBottomSheet(
        icon: AppIcon(
          assetPath: AssetsPath.updateProfileIconInformation,
          size: ResponsiveHelper.iconSize(72),
        ),
        title: AppText.deleteYourNchitoAccountExclaim,
        description: Text(
          AppText
              .thisActionIsPermanentYourNchitoAccountBookingHistoryServicesMessagesAndSavedActivityWillBePermanentlyRemovedAndCannotBeRecovered,
          textAlign: TextAlign.center,
          style: ctx.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
          ),
        ),
        confirmLabel: AppText.delete,
        confirmColor: AppColors.red,
        onConfirm: () {
          // Account deletion action
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tileRadius = ResponsiveHelper.borderRadius(10);
    final tilePadding = EdgeInsets.all(ResponsiveHelper.padding(10));
    final tileBgColor = AppColors.bgOverlay.withValues(alpha: 0.04);
    final iconBoxSize = ResponsiveHelper.width(30);
    final iconBoxRadius = ResponsiveHelper.borderRadius(8);
    final chevronSize = ResponsiveHelper.iconSize(16);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.accountSetting),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  children: [
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    // 1. Change Password
                    ProfileMenuTile(
                      iconData: Icons.lock_outline_rounded,
                      title: AppText.changePassword,
                      radius: tileRadius,
                      contentPadding: tilePadding,
                      tileBgColor: tileBgColor,
                      iconBgColor: AppColors.brandSoft,
                      iconColor: AppColors.brandPrimary,
                      iconBoxSize: iconBoxSize,
                      iconBoxRadius: iconBoxRadius,
                      chevronSize: chevronSize,
                      onTap: () => context.push(
                        ProviderChangePasswordScreen.routeName,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // 2. Linked Payment Account
                    ProfileMenuTile(
                      iconData: Icons.edit_note_rounded,
                      title: AppText.linkedPaymentAccount,
                      radius: tileRadius,
                      contentPadding: tilePadding,
                      tileBgColor: tileBgColor,
                      iconBgColor: AppColors.brandSoft,
                      iconColor: AppColors.brandPrimary,
                      iconBoxSize: iconBoxSize,
                      iconBoxRadius: iconBoxRadius,
                      chevronSize: chevronSize,
                      onTap: () => context.push(
                        ProviderLinkedPaymentAccountScreen.routeName,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // 3. Delete account
                    ProfileMenuTile(
                      iconData: Icons.person_outline_rounded,
                      title: AppText.deleteAccount,
                      radius: tileRadius,
                      contentPadding: tilePadding,
                      tileBgColor: tileBgColor,
                      iconBgColor: AppColors.red.withValues(alpha: 0.1),
                      iconColor: AppColors.red400,
                      titleColor: AppColors.red400,
                      iconBoxSize: iconBoxSize,
                      iconBoxRadius: iconBoxRadius,
                      chevronSize: chevronSize,
                      onTap: () => _onDeleteAccountTap(context),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
