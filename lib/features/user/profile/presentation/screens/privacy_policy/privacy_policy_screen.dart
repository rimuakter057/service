import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const String routeName = '/privacy-policy';

  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.privacyPolicy),
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
                      'Privacy Policy',
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
                      'Your privacy is important to us. This Privacy Policy explains how Nchito collects, uses, and protects your information.',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(13),
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(18)),
                    Text(
                      '• Information We Collect',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(8)),
                    Text(
                      'We may collect:\n\n'
                      '- Name and account information\n'
                      '- Email address and mobile number\n'
                      '- Profile information\n'
                      '- Service and booking information\n'
                      '- Payment and transaction information\n'
                      '- Basic device and usage information',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(13),
                        height: 1.6,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(18)),
                    Text(
                      '• How We Use Your Information',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(8)),
                    Text(
                      'We use your information to:\n\n'
                      '- Provide Nchito services\n'
                      '- Manage accounts and bookings\n'
                      '- Process payments\n'
                      '- Connect customers and providers\n'
                      '- Provide customer support\n'
                      '- Maintain platform security\n'
                      '- Improve the platform experience',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(13),
                        height: 1.6,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(18)),
                    Text(
                      '• Information Sharing',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(8)),
                    Text(
                      'We do not sell your personal information.\n\n'
                      'Information may be shared with payment providers, technical service providers, or legal authorities when necessary for platform operation or legal compliance.',
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
