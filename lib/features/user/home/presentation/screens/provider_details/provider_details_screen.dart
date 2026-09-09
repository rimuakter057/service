import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/core/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/home/presentation/screens/all_reviews/all_reviews_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_availability/provider_availability_screen.dart';
import 'package:nchito/features/user/home/presentation/widgets/detail_field.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';


/// Full provider profile — reached by tapping a provider card on Home.
class ProviderDetailsScreen extends StatefulWidget {
  static const String routeName = '/provider-details';

  final HomeProviderData provider;

  const ProviderDetailsScreen({super.key, required this.provider});

  @override
  State<ProviderDetailsScreen> createState() => _ProviderDetailsScreenState();
}

class _ProviderDetailsScreenState extends State<ProviderDetailsScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;

    return Scaffold(
      backgroundColor: AppColors.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            TopAppbar(
              title: AppText.providerDetails,
              trailing: GestureDetector(
                onTap: () => setState(() => _isFavorite = !_isFavorite),
                child: BgIcon(
                  assetPath: AssetsPath.exploreProviderDetailsIconFavoriteOutline,
                  bgColor: AppColors.brandSoft,
                  iconColor: _isFavorite ? AppColors.red400 : AppColors.textGrey,
                  bgSize: ResponsiveHelper.width(40),
                  radius: ResponsiveHelper.width(20),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(16),
                          ),
                          child: AppIcon(
                            assetPath: provider.photo,
                            size: ResponsiveHelper.width(72),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: AppIcon(
                            assetPath:
                                AssetsPath.providerDetailsIconVerifiedBadge,
                            size: ResponsiveHelper.iconSize(18),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),
///name===================
                    DetailField(label: AppText.name, value: provider.name),
                    SizedBox(height: ResponsiveHelper.spacing(12)),
///email===============
                    DetailField(label: AppText.email, value: provider.email),
                    SizedBox(height: ResponsiveHelper.spacing(12)),
///contact=======================
                    DetailField(
                      label: AppText.contactPhone,
                      value: provider.phone,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(12)),
///service area===================
                    DetailField(
                      label: AppText.serviceArea,
                      value: provider.area,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(12)),
///service type=====================================
                    DetailField(
                      label: AppText.serviceType,
                      child: Wrap(
                        spacing: ResponsiveHelper.spacing(8),
                        runSpacing: ResponsiveHelper.spacing(8),
                        children: provider.tags
                            .map((tag) => _ServiceTagChip(tag: tag))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(12)),
///description==================================
                    DetailField(
                      label: AppText.serviceDescription,
                      value: provider.description,
                      emphasizeValue: false,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(12)),
///reviews==============================
                    DetailField(
                      label: AppText.reviews,
                      trailing: GestureDetector(
                        onTap: () => context.push(
                          AllReviewsScreen.routeName,
                          extra: provider.reviewCount,
                        ),
                        child: BgIcon(
                          assetPath: AssetsPath.logInIconEyeToggle,
                          bgColor: const Color(0xFFDCE6F8),
                          iconColor: AppColors.blueStatusInfo,
                          bgSize: ResponsiveHelper.width(36),
                          radius: ResponsiveHelper.borderRadius(10),
                          iconSize: ResponsiveHelper.iconSize(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppIcon(
                            assetPath: AssetsPath.providerDetailsIconStar,
                            size: ResponsiveHelper.iconSize(16),
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(6)),
                          Text.rich(
                            TextSpan(
                              text: '${provider.rating} ',
                              style: context.labelMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlackPrimary,
                              ),
                              children: [
                                TextSpan(
                                  text: '(${provider.reviewCount})',
                                  style: context.labelMedium.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(12)),
///complete count===============================
                    DetailField(
                      label: AppText.totalJobsCompleted,
                      value: provider.totalJobsCompleted,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(24),
                vertical: ResponsiveHelper.padding(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: AppText.sendMessage,
                      onPressed: () {},
                      borderColor: AppColors.brandPrimary,
                      textColor: AppColors.brandPrimary,
                      child: _ButtonContent(
                        iconAsset: AssetsPath.providerDetailsIconMessage,
                        text: AppText.sendMessage,
                        color: AppColors.brandPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(12)),
                  Expanded(
                    child: AppButton(
                      text: AppText.seeAvailability,
                      onPressed: () =>
                          context.push(ProviderAvailabilityScreen.routeName),
                      backgroundColor: AppColors.brandPrimary,
                      textColor: AppColors.textOnPrimary,
                      child: _ButtonContent(
                        iconAsset: AssetsPath.providerDetailsIconCalendar,
                        text: AppText.seeAvailability,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
///service=================================
class _ServiceTagChip extends StatelessWidget {
  final ProviderTag tag;

  const _ServiceTagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(10),
        vertical: ResponsiveHelper.padding(6),
      ),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(20)),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(
            assetPath: tag.iconAsset,
            size: ResponsiveHelper.iconSize(14),
          ),
          SizedBox(width: ResponsiveHelper.spacing(4)),
          Text(tag.label, style: context.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final String iconAsset;
  final String text;
  final Color color;

  const _ButtonContent({
    required this.iconAsset,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppIcon(
          assetPath: iconAsset,
          size: ResponsiveHelper.iconSize(16),
          color: color,
        ),
        SizedBox(width: ResponsiveHelper.spacing(6)),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
