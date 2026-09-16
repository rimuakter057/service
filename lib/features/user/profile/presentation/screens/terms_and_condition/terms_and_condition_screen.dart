import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

class TermsAndConditionScreen extends StatelessWidget {
  static const String routeName = '/terms-and-condition';

  const TermsAndConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.termsAndCondition),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ResponsiveHelper.spacing(16)),
                    Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(16),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    Text(
                      'Last Updated: 16 August 2026',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(14)),
                    Text(
                      'By accessing or using Nchito, you agree to comply with and be bound by these Terms & Conditions. These Terms govern your access to the platform, including the website, mobile application, service tools, training resources, and related services provided through Nchito.',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(13),
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(18)),
                    Text(
                      '• Acceptance of Terms',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(8)),
                    Text(
                      'By creating an account, requesting services, offering services, booking a provider, or using any feature of Nchito, you confirm that you have read, understood, and accepted these Terms. If you do not agree with any part of these Terms, you should stop using the platform immediately.',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(13),
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(18)),
                    Text(
                      '• Platform Purpose',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(8)),
                    Text(
                      'Nchito is designed to connect customers with local service providers. Customers can discover and book services, while providers can offer their skills and manage service bookings through the platform.',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(13),
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(18)),
                    Text(
                      '• User Accounts',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(8)),
                    Text(
                      'Users are responsible for keeping their account information accurate and maintaining the security of their login credentials. All information provided during registration must be truthful and up to date.\n\nNchito reserves the right to suspend or restrict accounts that contain misleading information or violate platform policies.',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(13),
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(32)),
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
