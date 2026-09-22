import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nchito/features/common/cms_support/presentation/providers/company_notifier.dart';
import 'package:nchito/features/common/common_widgets/app_detail_field/app_detail_field.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

/// Read-only provider legal & company info screen. Navigated to from
/// [ProviderProfileScreen]'s "Legal & Company Info" menu tile.
class ProviderLegalCompanyInfoScreen extends StatefulWidget {
  static const String routeName = '/provider/legal-company-info';

  const ProviderLegalCompanyInfoScreen({super.key});

  @override
  State<ProviderLegalCompanyInfoScreen> createState() =>
      _ProviderLegalCompanyInfoScreenState();
}

class _ProviderLegalCompanyInfoScreenState
    extends State<ProviderLegalCompanyInfoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProviderCompanyNotifier>().fetchCompanyInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final fieldColor = AppColors.bgOverlay.withValues(alpha: 0.04);
    final fieldRadius = ResponsiveHelper.borderRadius(10);
    final fieldPadding = EdgeInsets.all(ResponsiveHelper.padding(14));
    final fieldGap = ResponsiveHelper.spacing(8);
    final rowGap = SizedBox(height: ResponsiveHelper.spacing(8));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.legalAndCompanyInfo),
            Expanded(
              child: Consumer<ProviderCompanyNotifier>(
                builder: (context, notifier, child) {
                  if (notifier.isLoading && notifier.companyInfo == null) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.brandPrimary,
                      ),
                    );
                  }

                  if (notifier.errorMessage != null &&
                      notifier.companyInfo == null) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(ResponsiveHelper.padding(24)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              notifier.errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.red,
                                fontSize: ResponsiveHelper.fontSize(14),
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(16)),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brandPrimary,
                              ),
                              onPressed: () =>
                                  notifier.fetchCompanyInfo(forceRefresh: true),
                              child: const Text(
                                'Retry',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final info = notifier.companyInfo;
                  final companyName = (info != null && info.name.isNotEmpty)
                      ? info.name
                      : AppText.nchitoCompanyName;
                  final businessType = (info != null && info.businessType.isNotEmpty)
                      ? info.businessType
                      : AppText.onlineServiceMarketplacePlatform;
                  final country = (info != null && info.country.isNotEmpty)
                      ? info.country
                      : AppText.zambia;
                  final email = (info != null && info.email.isNotEmpty)
                      ? info.email
                      : AppText.supportAtNchitoEmail;
                  final phone = (info != null && info.phone.isNotEmpty)
                      ? info.phone
                      : AppText.userPhoneVaughan;
                  final website = (info != null && info.website.isNotEmpty)
                      ? info.website
                      : AppText.nchitoWebsite;

                  return RefreshIndicator(
                    color: AppColors.brandPrimary,
                    onRefresh: () =>
                        notifier.fetchCompanyInfo(forceRefresh: true),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(24),
                      ),
                      child: Column(
                        children: [
                          AppDetailField(
                            label: AppText.companyName,
                            value: companyName,
                            color: fieldColor,
                            radius: fieldRadius,
                            contentPadding: fieldPadding,
                            gap: fieldGap,
                          ),
                          rowGap,
                          AppDetailField(
                            label: AppText.businessType,
                            value: businessType,
                            color: fieldColor,
                            radius: fieldRadius,
                            contentPadding: fieldPadding,
                            gap: fieldGap,
                          ),
                          rowGap,
                          AppDetailField(
                            label: AppText.country,
                            value: country,
                            color: fieldColor,
                            radius: fieldRadius,
                            contentPadding: fieldPadding,
                            gap: fieldGap,
                          ),
                          rowGap,
                          AppDetailField(
                            label: AppText.contactEmail,
                            value: email,
                            color: fieldColor,
                            radius: fieldRadius,
                            contentPadding: fieldPadding,
                            gap: fieldGap,
                          ),
                          rowGap,
                          AppDetailField(
                            label: AppText.contactPhone,
                            value: phone,
                            color: fieldColor,
                            radius: fieldRadius,
                            contentPadding: fieldPadding,
                            gap: fieldGap,
                          ),
                          rowGap,
                          AppDetailField(
                            label: AppText.officialWebsite,
                            value: website,
                            color: fieldColor,
                            radius: fieldRadius,
                            contentPadding: fieldPadding,
                            gap: fieldGap,
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(24)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
