import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/user/home/presentation/screens/service_categories/service_categories_screen.dart';

import 'category_tile.dart';
import 'home_sample_data.dart';

/// The "Selectable Featured Service" 4-column category grid on Home.
class HomeCategoryGrid extends StatelessWidget {
  const HomeCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: homeCategories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: ResponsiveHelper.spacing(16),
        crossAxisSpacing: ResponsiveHelper.spacing(8),
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final category = homeCategories[index];
        final isViewMore = category.label == AppText.viewMore;
        return CategoryTile(
          assetPath: category.assetPath,
          label: category.label,
          bgColor: category.bgColor,
          iconColor: category.iconColor,
          onTap: isViewMore
              ? () => context.push(ServiceCategoriesScreen.routeName)
              : () {},
        );
      },
    );
  }
}
