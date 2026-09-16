import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_bottom_nav_bar/provider_bottom_nav_bar.dart';
import 'package:nchito/features/common/common_widgets/app_status_card/app_status_card.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Provider's service list — shows an empty state ("No Services Yet")
/// until at least one service is added. Reached from the provider bottom
/// nav's "Services" tab. Reuses [AppStatusCard] (the same card shape as
/// Chat's blocked-provider state) instead of a bespoke empty-state widget.
class MyServicesScreen extends StatelessWidget {
  static const String routeName = '/provider/my-services';

  const MyServicesScreen({super.key});

  void _onAddService() {
    // TODO: wire up once the "add service" flow is designed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopAppbar(
              title: AppText.myServices,
              trailing: GestureDetector(
                onTap: _onAddService,
                child: Container(
                  width: ResponsiveHelper.width(40),
                  height: ResponsiveHelper.width(40),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.brandSoft,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderDefault),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    size: ResponsiveHelper.iconSize(22),
                    color: AppColors.brandPrimary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: AppStatusCard(
                  iconAsset: AssetsPath.providerHomeIconServices,
                  iconBoxColor: AppColors.brandSoft,
                  title: AppText.noServicesYet,
                  description: AppText
                      .youHaventAddedAnyServicesToYourProfileYetCreateYourFirstServiceToStartReceivingBookingRequests,
                  buttonLabel: AppText.addService,
                  onButtonTap: _onAddService,
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
