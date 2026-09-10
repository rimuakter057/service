import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_bottom_nav_bar/app_bottom_nav_bar.dart';
import 'package:nchito/core/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/profile/presentation/widgets/profile_menu_tile.dart';

/// User profile screen displaying user avatar, name, and options list.
class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
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
                                AssetsPath.avatarUser,
                                width: ResponsiveHelper.width(96),
                                height: ResponsiveHelper.width(96),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(12)),
                          Text(
                            AppText.userNameVaughan,
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
                      onTap: () {},
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    ProfileMenuTile(
                      iconData: Icons.settings_outlined,
                      title: AppText.accountSetting,
                      onTap: () {},
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    ProfileMenuTile(
                      iconData: Icons.favorite_border_rounded,
                      title: AppText.favoriteProviders,
                      onTap: () {},
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
                      onTap: () {},
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    ProfileMenuTile(
                      iconData: Icons.description_outlined,
                      title: AppText.privacyPolicy,
                      onTap: () {},
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    ProfileMenuTile(
                      iconData: Icons.shield_outlined,
                      title: AppText.legalAndCompanyInfo,
                      onTap: () {},
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    ProfileMenuTile(
                      iconData: Icons.headset_mic_outlined,
                      title: AppText.helpAndSupport,
                      onTap: () {},
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    ProfileMenuTile(
                      iconData: Icons.logout_rounded,
                      title: AppText.logOut,
                      tileBgColor: AppColors.red50,
                      iconBgColor: AppColors.red50,
                      iconColor: AppColors.red400,
                      titleColor: AppColors.red400,
                      showChevron: false,
                      onTap: () {},
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 4),
    );
  }
}
