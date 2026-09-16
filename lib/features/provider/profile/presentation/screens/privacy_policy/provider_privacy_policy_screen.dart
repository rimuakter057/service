import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

/// Provider Privacy Policy screen.
class ProviderPrivacyPolicyScreen extends StatelessWidget {
  static const String routeName = '/provider/privacy-policy';

  const ProviderPrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Your privacy is important to us. This Privacy Policy explains how Nchito collects, uses, and protects your information as a registered Service Provider.',
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
                      'We collect personal information such as your name, contact details, payment information, and identity verification documents when you register as a provider on Nchito.',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(13),
                        height: 1.5,
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
                      'Your information is used to facilitate bookings, process payouts, verify professional credentials, and ensure marketplace integrity.',
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
