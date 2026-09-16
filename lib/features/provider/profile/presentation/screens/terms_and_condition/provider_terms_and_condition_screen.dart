import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

/// Provider Terms and Condition screen.
class ProviderTermsAndConditionScreen extends StatelessWidget {
  static const String routeName = '/provider/terms-and-condition';

  const ProviderTermsAndConditionScreen({super.key});

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
                      'By accessing or using Nchito as a Service Provider, you agree to comply with and be bound by these Terms & Conditions. These Terms govern your access to the platform, offering services, managing bookings, receiving payments, and related services provided through Nchito.',
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
                      'By creating an account or using Nchito as a Service Provider, you confirm that you have read, understood, and agreed to these Terms. If you do not agree with any part of these Terms, you must not use the platform.',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(13),
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(18)),
                    Text(
                      '• Provider Responsibilities',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(8)),
                    Text(
                      'Service Providers must maintain valid certifications, identity documentation, and comply with safety standards when delivering services to customers.',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(13),
                        height: 1.5,
                        color: AppColors.textSecondary,
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
