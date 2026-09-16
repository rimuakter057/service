import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_confirm_bottom_sheet/app_confirm_bottom_sheet.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_text_field/app_text_field.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Provider-specific update profile screen.
/// Matches the design with only Full Name editable, dark green button,
/// email/phone locked notice card, and confirmation bottom sheet.
class ProviderUpdateProfileScreen extends StatefulWidget {
  static const String routeName = '/provider/update-profile';

  const ProviderUpdateProfileScreen({super.key});

  @override
  State<ProviderUpdateProfileScreen> createState() =>
      _ProviderUpdateProfileScreenState();
}

class _ProviderUpdateProfileScreenState
    extends State<ProviderUpdateProfileScreen> {
  late final _nameController = TextEditingController(
    text: AppText.robertsJuniorProviderName,
  );

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSaveChanges() {
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
        title: AppText.saveProfileChangesExclaim,
        description: Text(
          AppText
              .areYouSureYouWantToSaveYourProfileChangesYourUpdatedInformationWillBeAppliedToYourAccount,
          textAlign: TextAlign.center,
          style: ctx.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
          ),
        ),
        confirmLabel: AppText.confirm,
        confirmColor: const Color(0xFF0F3E2E),
        onConfirm: () {
          // Profile changes saved
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ResponsiveHelper.spacing(12)),

                    // Avatar with camera badge
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
                                width: 1.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(22),
                              ),
                              child: Image.asset(
                                AssetsPath.messagesAvatarRobertsJunior,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: ResponsiveHelper.spacing(2),
                            right: ResponsiveHelper.spacing(2),
                            child: Container(
                              padding: EdgeInsets.all(
                                ResponsiveHelper.padding(5),
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F3E2E),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.borderRadius(6),
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: ResponsiveHelper.iconSize(14),
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(28)),

                    // Full Name
                    AppTextField(
                      label: AppText.fullName,
                      hint: AppText.enterYourFullName,
                      controller: _nameController,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),

                    // Save the changes Button
                    AppButton(
                      text: AppText.saveTheChanges,
                      onPressed: _onSaveChanges,
                      width: double.infinity,
                      backgroundColor: const Color(0xFF0F3E2E),
                      textColor: AppColors.white,
                      radius: ResponsiveHelper.borderRadius(10),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    // Notice: Email Address / Phone Number is linked
                    Container(
                      padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
                      decoration: BoxDecoration(
                        color: AppColors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(10),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: ResponsiveHelper.width(36),
                            height: ResponsiveHelper.width(36),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.red.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(8),
                              ),
                            ),
                            child: AppIcon(
                              assetPath: AssetsPath.updateProfileIconEmailLocked,
                              size: ResponsiveHelper.iconSize(18),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(10)),
                          Expanded(
                            child: Text(
                              AppText
                                  .yourEmailAddressOrPhoneNumberIsLinkedToYourNchitoAccount,
                              style: context.bodySmall.copyWith(
                                fontSize: ResponsiveHelper.fontSize(11),
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                                color: AppColors.textGrey,
                              ),
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
