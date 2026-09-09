import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/user/home/presentation/widgets/category_tile.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

/// Full grid of service categories — reached from Home's "View more" tile.
class ServiceCategoriesScreen extends StatelessWidget {
  static const String routeName = '/service-categories';

  const ServiceCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
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
                child: GridView.builder(
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
