import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/profile/presentation/screens/change_password/change_password_screen.dart';
import 'package:nchito/features/user/profile/presentation/widgets/confirm_account_deletion_bottom_sheet.dart';
import 'package:nchito/features/user/profile/presentation/widgets/delete_account_bottom_sheet.dart';
import 'package:nchito/features/user/profile/presentation/widgets/profile_menu_tile.dart';

/// Account settings screen with "Change Password" and "Delete account"
/// actions. Navigated to from [ProfileScreen]'s "Account Setting" menu tile.
class AccountSettingsScreen extends StatelessWidget {
  static const String routeName = '/account-settings';

  const AccountSettingsScreen({super.key});

  void _onDeleteAccountTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => DeleteAccountBottomSheet(
        onConfirm: () => _onConfirmAccountDeletionTap(context),
      ),
    );
  }

  void _onConfirmAccountDeletionTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => ConfirmAccountDeletionBottomSheet(
        onConfirm: () {
          // TODO(backend): call the delete-account API here once the
          // backend is available.
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
      backgroundColor: AppColors.bgApp,
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
                    ProfileMenuTile(
                      assetPath: AssetsPath.accountSettingsIconChangePassword,
                      title: AppText.changePassword,
                      radius: tileRadius,
                      contentPadding: tilePadding,
                      tileBgColor: tileBgColor,
                      iconBgColor: AppColors.brandSoft,
                      iconBoxSize: iconBoxSize,
                      iconBoxRadius: iconBoxRadius,
                      chevronSize: chevronSize,
                      onTap: () =>
                          context.push(ChangePasswordScreen.routeName),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    ProfileMenuTile(
                      assetPath: AssetsPath.accountSettingsIconDeleteAccount,
                      title: AppText.deleteAccount,
                      radius: tileRadius,
                      contentPadding: tilePadding,
                      tileBgColor: tileBgColor,
                      iconBgColor: AppColors.red.withValues(alpha: 0.14),
                      iconColor: AppColors.red,
                      titleColor: AppColors.red,
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
