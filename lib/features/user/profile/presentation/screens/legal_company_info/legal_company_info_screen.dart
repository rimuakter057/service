import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/user/home/presentation/widgets/detail_field.dart';

/// Read-only legal & company info screen. Navigated to from
/// [ProfileScreen]'s "Legal & Company Info" menu tile.
class LegalCompanyInfoScreen extends StatelessWidget {
  static const String routeName = '/legal-company-info';

  const LegalCompanyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fieldColor = AppColors.bgOverlay.withValues(alpha: 0.04);
    final fieldRadius = ResponsiveHelper.borderRadius(10);
    final fieldPadding = EdgeInsets.all(ResponsiveHelper.padding(14));
    final fieldGap = ResponsiveHelper.spacing(8);
    final rowGap = SizedBox(height: ResponsiveHelper.spacing(8));

    return Scaffold(
      backgroundColor: AppColors.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.legalAndCompanyInfo),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  children: [
                    DetailField(
                      label: AppText.companyName,
                      value: AppText.nchitoCompanyName,
                      color: fieldColor,
                      radius: fieldRadius,
                      contentPadding: fieldPadding,
                      gap: fieldGap,
                    ),
                    rowGap,
                    DetailField(
                      label: AppText.businessType,
                      value: AppText.onlineServiceMarketplacePlatform,
                      color: fieldColor,
                      radius: fieldRadius,
                      contentPadding: fieldPadding,
                      gap: fieldGap,
                    ),
                    rowGap,
                    DetailField(
                      label: AppText.country,
                      value: AppText.zambia,
                      color: fieldColor,
                      radius: fieldRadius,
                      contentPadding: fieldPadding,
                      gap: fieldGap,
                    ),
                    rowGap,
                    DetailField(
                      label: AppText.contactEmail,
                      value: AppText.supportAtNchitoEmail,
                      color: fieldColor,
                      radius: fieldRadius,
                      contentPadding: fieldPadding,
                      gap: fieldGap,
                    ),
                    rowGap,
                    DetailField(
                      label: AppText.contactPhone,
                      value: AppText.userPhoneVaughan,
                      color: fieldColor,
                      radius: fieldRadius,
                      contentPadding: fieldPadding,
                      gap: fieldGap,
                    ),
                    rowGap,
                    DetailField(
                      label: AppText.officialWebsite,
                      value: AppText.nchitoWebsite,
                      color: fieldColor,
                      radius: fieldRadius,
                      contentPadding: fieldPadding,
                      gap: fieldGap,
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
