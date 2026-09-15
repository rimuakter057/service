import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_text_field/app_text_field.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/profile/presentation/widgets/save_profile_changes_bottom_sheet.dart';

/// Lets the user edit their name and phone number. Email stays locked
/// (shown as a notice) since it is tied to the account. Navigated to from
/// [MyProfileScreen]'s "Update Profile" button.
class UpdateProfileScreen extends StatefulWidget {
  static const String routeName = '/update-profile';

  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late final _nameController = TextEditingController(
    text: AppText.userNameVaughan,
  );
  late final _phoneController = TextEditingController(
    text: AppText.userPhoneVaughan,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSaveChanges() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => SaveProfileChangesBottomSheet(
        onConfirm: () {
          // TODO(backend): call the update-profile API here once the
          // backend is available.
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.updateProfile),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  children: [
                    // Avatar with photo-edit badge
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
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
                          Positioned(
                            bottom: ResponsiveHelper.spacing(4),
                            right: ResponsiveHelper.spacing(4),
                            child: Container(
                              padding: EdgeInsets.all(
                                ResponsiveHelper.padding(3),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.borderRadius(4),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColors.brandGradientStart,
                                    AppColors.brandGradientEnd,
                                  ],
                                ),
                              ),
                              child: AppIcon(
                                assetPath: AssetsPath.updateProfileIconCamera,
                                size: ResponsiveHelper.iconSize(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),

                    AppTextField(
                      label: AppText.fullName,
                      hint: AppText.enterYourFullName,
                      controller: _nameController,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),
                    AppTextField(
                      label: AppText.phoneNumber,
                      hint: AppText.enterYourPhoneNumber,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    AppButton(
                      text: AppText.saveTheChanges,
                      onPressed: _onSaveChanges,
                      width: double.infinity,
                      backgroundColor: AppColors.brandPrimary,
                      textColor: AppColors.white,
                      radius: ResponsiveHelper.borderRadius(10),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    // Email locked notice
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: ResponsiveHelper.width(44),
                          height: ResponsiveHelper.width(44),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.red.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(10),
                            ),
                          ),
                          child: AppIcon(
                            assetPath: AssetsPath.updateProfileIconEmailLocked,
                            size: ResponsiveHelper.iconSize(20),
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(6)),
                        Expanded(
                          child: Text(
                            AppText
                                .yourEmailAddressIsLinkedToYourNchitoAccountAndIsUsedForImportantAccountAndSecurityUpdatesSoItCannotBeChangedAtThisTime,
                            style: context.bodySmall.copyWith(
                              fontSize: ResponsiveHelper.fontSize(10),
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ),
                      ],
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
