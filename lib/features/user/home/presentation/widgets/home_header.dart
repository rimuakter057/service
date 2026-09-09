import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/core/common_widgets/app_search_field/app_search_field.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + ResponsiveHelper.padding(12),
        left: ResponsiveHelper.padding(20),
        right: ResponsiveHelper.padding(20),
        bottom: ResponsiveHelper.padding(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(14)),
                child: AppIcon(
                  assetPath: AssetsPath.avatarUser,
                  size: ResponsiveHelper.width(48),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: ResponsiveHelper.spacing(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello Vaughan Geth...',
                      overflow: TextOverflow.ellipsis,
                      style: context.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveHelper.fontSize(17),
                        color: AppColors.textBlackPrimary
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(4)),
                    Row(
                      children: [
                        AppIcon(
                          assetPath: AssetsPath.iconLocation,
                          size: ResponsiveHelper.iconSize(14),

                        ),
                        SizedBox(width: ResponsiveHelper.spacing(4)),
                        Text(
                          'Lusaka, Zambia',
                          style: context.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(2)),
                        AppIcon(
                          assetPath: AssetsPath.dropDown,
                          size: ResponsiveHelper.iconSize(14),

                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BgIcon(
                assetPath: AssetsPath.iconNotification,
                bgColor: AppColors.brandSoft,
                iconColor: AppColors.brandPrimary,
                bgSize: ResponsiveHelper.width(44),
                radius: ResponsiveHelper.width(22),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.spacing(16)),

          // Green Action Box
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.padding(12),
              vertical: ResponsiveHelper.padding(12),
            ),
            decoration: BoxDecoration(
              color: AppColors.brandPrimary,
              borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What do you need help with !',
                  style: context.titleMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(6)),
                AppSearchField(
                  hint: 'Search for a service....',
                  searchIconAsset: AssetsPath.iconSearch,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}