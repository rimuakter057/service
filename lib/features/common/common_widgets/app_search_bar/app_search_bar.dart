import 'package:flutter/material.dart';

import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import '../app_button/app_button.dart';
import '../app_icon/app_icon.dart';

/// Reusable search bar with an optional adjacent filter button.
///
/// Used across Explore, Bookings, and other screens needing a unified
/// search input + filter action row.
class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final String searchIconAsset;
  final String filterIconAsset;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool showFilter;

  const AppSearchBar({
    super.key,
    this.controller,
    this.hint,
    this.searchIconAsset = AssetsPath.exploreProviderIconSearch,
    this.filterIconAsset = AssetsPath.myBookingsIconFilter,
    this.onChanged,
    this.onFilterTap,
    this.onTap,
    this.readOnly = false,
    this.showFilter = true,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = ResponsiveHelper.borderRadius(12);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: ResponsiveHelper.height(48),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: AppColors.borderDefault.withValues(alpha: 0.5),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.padding(14),
            ),
            child: Row(
              children: [
                AppIcon(
                  assetPath: searchIconAsset,
                  size: ResponsiveHelper.iconSize(18),
                  color: AppColors.textGrey,
                ),
                SizedBox(width: ResponsiveHelper.spacing(10)),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    onTap: onTap,
                    readOnly: readOnly,
                    style: context.bodyMedium.copyWith(
                      color: AppColors.textBlackPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: hint ?? AppText.search,
                      hintStyle: context.bodyMedium.copyWith(
                        color: AppColors.textGrey,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showFilter && onFilterTap != null) ...[
          SizedBox(width: ResponsiveHelper.spacing(8)),
          AppButton(
            text: AppText.filter,
            onPressed: onFilterTap,
            width: ResponsiveHelper.width(48),
            height: ResponsiveHelper.height(48),
            backgroundColor: AppColors.brandPrimary,
            radius: radius,
            child: AppIcon(
              assetPath: filterIconAsset,
              size: ResponsiveHelper.iconSize(18),
              color: AppColors.textOnPrimary,
            ),
          ),
        ],
      ],
    );
  }
}
