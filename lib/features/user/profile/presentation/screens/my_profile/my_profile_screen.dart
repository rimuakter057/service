import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/home/presentation/widgets/detail_field.dart';
import 'package:nchito/features/user/profile/presentation/screens/update_profile/update_profile_screen.dart';

/// Shows the signed-in user's profile info (name, email/phone) with an
/// "Update Profile" action. Navigated to from [ProfileScreen]'s
/// "My Profile" menu tile.
class MyProfileScreen extends StatelessWidget {
  static const String routeName = '/my-profile';

  const MyProfileScreen({super.key});

  static final _fieldColor = AppColors.bgOverlay.withValues(alpha: 0.01);
  static final _fieldRadius = ResponsiveHelper.borderRadius(10);
  static final _fieldPadding = EdgeInsets.all(ResponsiveHelper.padding(14));
  static final _fieldGap = ResponsiveHelper.spacing(8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.myProfile),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: ResponsiveHelper.width(100),
                      height: ResponsiveHelper.width(100),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(24),
                        ),
                        border: Border.all(
                          color: AppColors.borderDefault,
                          width: ResponsiveHelper.borderWidth(1),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(23),
                        ),
                        child: Image.asset(
                          AssetsPath.avatarUser,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    DetailField(
                      label: AppText.name,
                      value: AppText.userNameVaughan,
                      color: _fieldColor,
                      radius: _fieldRadius,
                      contentPadding: _fieldPadding,
                      gap: _fieldGap,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    DetailField(
                      label: AppText.emailPhoneNumber,
                      value: AppText.userPhoneVaughan,
                      color: _fieldColor,
                      radius: _fieldRadius,
                      contentPadding: _fieldPadding,
                      gap: _fieldGap,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    AppButton(
                      text: AppText.updateProfile,
                      onPressed: () =>
                          context.push(UpdateProfileScreen.routeName),
                      width: double.infinity,
                      backgroundColor: AppColors.brandPrimary,
                      radius: ResponsiveHelper.borderRadius(12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: ResponsiveHelper.iconSize(14),
                            color: AppColors.white,
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(10)),
                          Text(
                            AppText.updateProfile,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(14),
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
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
