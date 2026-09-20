import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import '../providers/category_provider.dart';
import 'category_tile.dart';
import 'category_ui_helper.dart';

/// The "Selectable Featured Service" 4-column category grid on Home.
/// Dynamically fetches categories from API, displaying initially 8 tiles
/// (7 categories + 1 View More), and expanding to show all categories upon tap.
class HomeCategoryGrid extends StatelessWidget {
  const HomeCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    if (provider.isLoading && provider.categories.isEmpty) {
      return GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: ResponsiveHelper.spacing(16),
          crossAxisSpacing: ResponsiveHelper.spacing(8),
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: ResponsiveHelper.width(56),
                height: ResponsiveHelper.width(56),
                decoration: BoxDecoration(
                  color: AppColors.borderDefault.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(16),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(8)),
              Container(
                width: ResponsiveHelper.width(48),
                height: ResponsiveHelper.height(10),
                decoration: BoxDecoration(
                  color: AppColors.borderDefault.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(4),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    if (provider.errorMessage != null && provider.categories.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(16)),
          child: Column(
            children: [
              Text(
                provider.errorMessage!,
                style: const TextStyle(color: AppColors.red),
              ),
              SizedBox(height: ResponsiveHelper.spacing(8)),
              TextButton(
                onPressed: () => provider.fetchCategories(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final displayed = provider.homeDisplayedCategories;

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayed.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: ResponsiveHelper.spacing(16),
        crossAxisSpacing: ResponsiveHelper.spacing(8),
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final category = displayed[index];

        if (category.id == CategoryProvider.viewMoreId) {
          return CategoryTile(
            assetPath: AssetsPath.categoryViewMore,
            label: AppText.viewMore,
            bgColor: AppColors.borderDefault,
            iconColor: AppColors.textBlackPrimary,
            onTap: () => provider.toggleExpanded(),
          );
        }

        if (category.id == CategoryProvider.viewLessId) {
          return CategoryTile(
            assetPath: AssetsPath.categoryViewMore,
            label: 'View Less',
            bgColor: AppColors.borderDefault,
            iconColor: AppColors.textBlackPrimary,
            onTap: () => provider.toggleExpanded(),
          );
        }

        return CategoryTile(
          assetPath: CategoryUiHelper.resolveAssetPath(
            category.slug,
            category.name,
          ),
          iconUrl: category.icon,
          label: category.name,
          bgColor: CategoryUiHelper.getBgColor(category.color),
          iconColor: CategoryUiHelper.getIconColor(category.color),
          onTap: () {},
        );
      },
    );
  }
}
