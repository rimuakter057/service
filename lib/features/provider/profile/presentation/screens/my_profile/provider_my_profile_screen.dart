import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_detail_field/app_detail_field.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/provider/profile/presentation/screens/update_profile/provider_update_profile_screen.dart';

/// Shows the signed-in provider's profile info (name, email, service types, jobs completed)
/// with an "Update Profile" action. Navigated to from [ProviderProfileScreen]'s "My Profile" tile.
class ProviderMyProfileScreen extends StatelessWidget {
  static const String routeName = '/provider/my-profile';

  const ProviderMyProfileScreen({super.key});

  static final _fieldColor = AppColors.bgOverlay.withValues(alpha: 0.04);
  static final _fieldRadius = ResponsiveHelper.borderRadius(10);
  static final _fieldPadding = EdgeInsets.all(ResponsiveHelper.padding(14));
  static final _fieldGap = ResponsiveHelper.spacing(8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    SizedBox(height: ResponsiveHelper.spacing(12)),

                    // Avatar with verified badge
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
                            bottom: -2,
                            right: -2,
                            child: AppIcon(
                              assetPath:
                                  AssetsPath.providerDetailsIconVerifiedBadge,
                              size: ResponsiveHelper.iconSize(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),

                    // Name
                    AppDetailField(
                      label: AppText.name,
                      value: AppText.robertsJuniorProviderName,
                      color: _fieldColor,
                      radius: _fieldRadius,
                      contentPadding: _fieldPadding,
                      gap: _fieldGap,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // Email / Phone Number
                    AppDetailField(
                      label: AppText.emailPhoneNumber,
                      value: AppText.robertJuniorEmail,
                      color: _fieldColor,
                      radius: _fieldRadius,
                      contentPadding: _fieldPadding,
                      gap: _fieldGap,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // Service Type
                    AppDetailField(
                      label: AppText.serviceType,
                      color: _fieldColor,
                      radius: _fieldRadius,
                      contentPadding: _fieldPadding,
                      gap: _fieldGap,
                      child: Wrap(
                        spacing: ResponsiveHelper.spacing(8),
                        runSpacing: ResponsiveHelper.spacing(6),
                        children: [
                          _ServiceTag(
                            icon: Icon(
                              Icons.bolt,
                              size: ResponsiveHelper.iconSize(14),
                              color: const Color(0xFFFFA726),
                            ),
                            label: AppText.electrical,
                          ),
                          _ServiceTag(
                            icon: Container(
                              width: ResponsiveHelper.iconSize(14),
                              height: ResponsiveHelper.iconSize(14),
                              decoration: const BoxDecoration(
                                color: Color(0xFF4DD0E1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.water_drop,
                                size: ResponsiveHelper.iconSize(10),
                                color: Colors.white,
                              ),
                            ),
                            label: AppText.moving,
                          ),
                          _ServiceTag(
                            icon: Container(
                              width: ResponsiveHelper.iconSize(14),
                              height: ResponsiveHelper.iconSize(14),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8F5E9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                size: ResponsiveHelper.iconSize(10),
                                color: const Color(0xFF2E7D32),
                              ),
                            ),
                            label: AppText.painting,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // Total Jobs Completed
                    AppDetailField(
                      label: AppText.totalJobsCompleted,
                      value: AppText.providerTotalJobsCount,
                      color: _fieldColor,
                      radius: _fieldRadius,
                      contentPadding: _fieldPadding,
                      gap: _fieldGap,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),

                    // Update Profile Button
                    AppButton(
                      text: AppText.updateProfile,
                      onPressed: () =>
                          context.push(ProviderUpdateProfileScreen.routeName),
                      width: double.infinity,
                      backgroundColor: const Color(0xFF0F3E2E),
                      radius: ResponsiveHelper.borderRadius(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: ResponsiveHelper.iconSize(16),
                            color: AppColors.white,
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(8)),
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

class _ServiceTag extends StatelessWidget {
  final Widget icon;
  final String label;

  const _ServiceTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(10),
        vertical: ResponsiveHelper.padding(5),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: ResponsiveHelper.spacing(5)),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(12),
              fontWeight: FontWeight.w600,
              color: AppColors.textBlackPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
