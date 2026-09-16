import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/home/presentation/widgets/detail_field.dart';

/// Read-only customer info screen, from the provider's side — reached by
/// tapping the "view" icon on the Provider Booking Details screen's
/// "Requested By" row. Mirrors the same avatar + [DetailField] pattern
/// as the user app's My Profile screen, just for a customer instead of
/// self, with "Send Message" instead of "Update Profile".
class CustomerDetailsScreen extends StatelessWidget {
  static const String routeName = '/provider/customer-details';

  final String customerName;
  final String customerEmailOrPhone;
  final String customerPhoto;

  const CustomerDetailsScreen({
    super.key,
    required this.customerName,
    required this.customerEmailOrPhone,
    required this.customerPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final fieldColor = AppColors.bgOverlay.withValues(alpha: 0.04);
    final fieldRadius = ResponsiveHelper.borderRadius(10);
    final fieldPadding = EdgeInsets.all(ResponsiveHelper.padding(14));
    final fieldGap = ResponsiveHelper.spacing(8);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.customerDetails),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  children: [
                    SizedBox(height: ResponsiveHelper.spacing(8)),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(24),
                        ),
                        border: Border.all(color: AppColors.borderDefault),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(24),
                        ),
                        child: AppIcon(
                          assetPath: customerPhoto,
                          size: ResponsiveHelper.width(100),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    DetailField(
                      label: AppText.name,
                      value: customerName,
                      color: fieldColor,
                      radius: fieldRadius,
                      contentPadding: fieldPadding,
                      gap: fieldGap,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    DetailField(
                      label: AppText.emailPhoneNumber,
                      value: customerEmailOrPhone,
                      color: fieldColor,
                      radius: fieldRadius,
                      contentPadding: fieldPadding,
                      gap: fieldGap,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    AppButton(
                      text: AppText.sendMessage,
                      onPressed: () {
                        // TODO: wire up once the provider messages
                        // feature exists.
                      },
                      width: double.infinity,
                      backgroundColor: AppColors.brandPrimary,
                      radius: ResponsiveHelper.borderRadius(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppIcon(
                            assetPath: AssetsPath.providerDetailsIconMessage,
                            size: ResponsiveHelper.iconSize(16),
                            color: AppColors.white,
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(8)),
                          Text(
                            AppText.sendMessage,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(14),
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
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
