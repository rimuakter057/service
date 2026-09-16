import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_bottom_nav_bar/provider_bottom_nav_bar.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_provider_card/app_provider_card.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/features/provider/services/presentation/screens/add_service/provider_add_service_screen.dart';
import 'package:nchito/features/provider/services/presentation/screens/service_details/provider_service_details_screen.dart';
import 'package:nchito/features/provider/services/presentation/widgets/provider_services_sample_data.dart';
// Empty state custom widget kept in reserve for when provider has 0 services:
// import 'package:nchito/features/provider/services/presentation/widgets/my_services_empty_card.dart';

/// Provider's My Services screen — displays grid of services using [AppProviderCard],
/// with trailing add button and navigation to [ProviderServiceDetailsScreen].
class MyServicesScreen extends StatelessWidget {
  static const String routeName = '/provider/my-services';

  const MyServicesScreen({super.key});

  void _onAddService(BuildContext context) {
    context.push(ProviderAddServiceScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final services = sampleProviderServices;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopAppbar(
              title: AppText.myServices,
              trailing: GestureDetector(
                onTap: () => _onAddService(context),
                child: Container(
                  width: ResponsiveHelper.width(40),
                  height: ResponsiveHelper.width(40),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.brandSoft,
                    shape: BoxShape.circle,
                  ),
                  child: AppIcon(
                    assetPath: AssetsPath.providerHomeIconAdd,
                    size: ResponsiveHelper.iconSize(20),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(16),
                  vertical: ResponsiveHelper.padding(12),
                ),
                child: Column(
                  children: [
                    // Empty state (commented out per user instruction, kept for when services list is empty):
                    // if (services.isEmpty)
                    //   MyServicesEmptyCard(
                    //     onAddService: () => _onAddService(context),
                    //   )
                    // else
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: services.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: ResponsiveHelper.spacing(12),
                        crossAxisSpacing: ResponsiveHelper.spacing(12),
                        childAspectRatio: 170 / 226,
                      ),
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return AppProviderCard(
                          photo: service.photo,
                          name: service.name,
                          service: service.service,
                          price: service.price,
                          rating: service.rating,
                          badgeIconAsset: service.badgeIconAsset,
                          badgeBgColor: service.badgeBgColor,
                          badgeIconColor: service.badgeIconColor,
                          onTap: () {
                            context.push(
                              ProviderServiceDetailsScreen.routeName,
                              extra: service,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ProviderBottomNavBar(currentIndex: 2),
    );
  }
}
