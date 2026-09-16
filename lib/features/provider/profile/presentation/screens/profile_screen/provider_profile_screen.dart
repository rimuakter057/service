import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_bottom_nav_bar/app_bottom_nav_bar.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/features/common/common_widgets/profile_menu_tile/profile_menu_tile.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/common/role_selection/role_selection_screen.dart';
import 'package:nchito/features/provider/profile/presentation/screens/my_profile/provider_my_profile_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/account_settings/account_settings_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/help_support/help_support_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/legal_company_info/legal_company_info_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/privacy_policy/privacy_policy_screen.dart';
import 'package:nchito/features/user/profile/presentation/screens/terms_and_condition/terms_and_condition_screen.dart';
import 'package:nchito/features/user/profile/presentation/widgets/log_out_bottom_sheet.dart';

/// Standalone Provider Profile screen displaying provider avatar, name,
/// options list, and [ProviderBottomNavBar].
class ProviderProfileScreen extends StatelessWidget {
  static const String routeName = '/provider/profile';

  const ProviderProfileScreen({super.key});

  void _onLogOutTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => LogOutBottomSheet(
        onConfirm: () {
          context.go(RoleSelectionScreen.routeName);
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
            const TopAppbar(title: AppText.profile),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  children: [
                    SizedBox(height: ResponsiveHelper.spacing(8)),

                    // Avatar & Name
                    Center(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(24),
                              ),
                              border: Border.all(
                                color: AppColors.borderDefault,
                                width: 1.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(22),
                              ),
                              child: Image.asset(
                                AssetsPath.messagesAvatarRobertsJunior,
                                width: ResponsiveHelper.width(96),
                                height: ResponsiveHelper.width(96),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(12)),
                          Text(
                            AppText.robertsJuniorProviderName,
                            style: context.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textBlackPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),

                    // Group 1: Profile & Preferences
                    ProfileMenuTile(
                      iconData: Icons.person_outline_rounded,
                      title: AppText.myProfile,
                      radius: tileRadius,
                      contentPadding: tilePadding,
                      tileBgColor: tileBgColor,
                      iconBgColor: AppColors.brandSoft,
                      iconBoxSize: iconBoxSize,
                      iconBoxRadius: iconBoxRadius,
                      chevronSize: chevronSize,
                      onTap: () => context.push(ProviderMyProfileScreen.routeName),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    ProfileMenuTile(
                      iconData: Icons.settings_outlined,
                      title: AppText.accountSetting,
                      radius: tileRadius,
                      contentPadding: tilePadding,
                      tileBgColor: tileBgColor,
                      iconBgColor: AppColors.brandSoft,
                      iconBoxSize: iconBoxSize,
                      iconBoxRadius: iconBoxRadius,
                      chevronSize: chevronSize,
                      onTap: () =>
                          context.push(AccountSettingsScreen.routeName),
                    ),

                    SizedBox(height: ResponsiveHelper.spacing(18)),

                    // Section Title: More
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppText.more,
                        style: context.bodySmall.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // Group 2: More Options & Log Out
                    ProfileMenuTile(
                      iconData: Icons.article_outlined,
                      title: AppText.termsAndCondition,
                      radius: tileRadius,
                      contentPadding: tilePadding,
                      tileBgColor: tileBgColor,
                      iconBgColor: AppColors.brandSoft,
                      iconBoxSize: iconBoxSize,
                      iconBoxRadius: iconBoxRadius,
                      chevronSize: chevronSize,
                      onTap: () =>
                          context.push(TermsAndConditionScreen.routeName),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    ProfileMenuTile(
                      iconData: Icons.description_outlined,
                      title: AppText.privacyPolicy,
                      radius: tileRadius,
                      contentPadding: tilePadding,
                      tileBgColor: tileBgColor,
                      iconBgColor: AppColors.brandSoft,
                      iconBoxSize: iconBoxSize,
                      iconBoxRadius: iconBoxRadius,
                      chevronSize: chevronSize,
                      onTap: () =>
                          context.push(PrivacyPolicyScreen.routeName),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    ProfileMenuTile(
                      iconData: Icons.shield_outlined,
                      title: AppText.legalAndCompanyInfo,
                      radius: tileRadius,
                      contentPadding: tilePadding,
                      tileBgColor: tileBgColor,
                      iconBgColor: AppColors.brandSoft,
                      iconBoxSize: iconBoxSize,
                      iconBoxRadius: iconBoxRadius,
                      chevronSize: chevronSize,
                      onTap: () =>
                          context.push(LegalCompanyInfoScreen.routeName),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    ProfileMenuTile(
                      iconData: Icons.headset_mic_outlined,
                      title: AppText.helpAndSupport,
                      radius: tileRadius,
                      contentPadding: tilePadding,
                      tileBgColor: tileBgColor,
                      iconBgColor: AppColors.brandSoft,
                      iconBoxSize: iconBoxSize,
                      iconBoxRadius: iconBoxRadius,
                      chevronSize: chevronSize,
                      onTap: () => context.push(HelpSupportScreen.routeName),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    ProfileMenuTile(
                      iconData: Icons.logout_rounded,
                      title: AppText.logOut,
                      radius: tileRadius,
                      contentPadding: tilePadding,
                      tileBgColor: AppColors.red.withValues(alpha: 0.05),
                      iconBgColor: AppColors.red.withValues(alpha: 0.05),
                      iconColor: AppColors.red400,
                      titleColor: AppColors.red400,
                      iconBoxSize: iconBoxSize,
                      iconBoxRadius: iconBoxRadius,
                      showChevron: false,
                      onTap: () => _onLogOutTap(context),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ProviderBottomNavBar(currentIndex: 4),
    );
  }
}
