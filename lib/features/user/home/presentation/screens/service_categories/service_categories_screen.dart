import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/user/home/presentation/widgets/category_tile.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../widgets/category_ui_helper.dart';

/// Full grid of service categories — reached from Home's "View more" tile.
class ServiceCategoriesScreen extends StatelessWidget {
  static const String routeName = '/service-categories';

  const ServiceCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    final apiCategories = provider.categories;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopAppbar(title: AppText.serviceCategories),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: apiCategories.isNotEmpty
                    ? GridView.builder(
                        itemCount: apiCategories.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: ResponsiveHelper.spacing(20),
                          crossAxisSpacing: ResponsiveHelper.spacing(8),
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final category = apiCategories[index];
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
                      )
                    : GridView.builder(
                        itemCount: serviceCategoriesList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: ResponsiveHelper.spacing(20),
                          crossAxisSpacing: ResponsiveHelper.spacing(8),
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final category = serviceCategoriesList[index];
                          if (category == null) {
                            return const SizedBox.shrink();
                          }
                          return CategoryTile(
                            assetPath: category.assetPath,
                            label: category.label,
                            bgColor: category.bgColor,
                            iconColor: category.iconColor,
                            onTap: () {},
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
