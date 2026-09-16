import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_text_field/app_text_field.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

/// Provider Help & Support screen — an FAQ accordion plus a "Contact us" form.
/// Navigated to from [ProviderProfileScreen]'s "Help & Support" menu tile.
class ProviderHelpSupportScreen extends StatefulWidget {
  static const String routeName = '/provider/help-support';

  const ProviderHelpSupportScreen({super.key});

  @override
  State<ProviderHelpSupportScreen> createState() =>
      _ProviderHelpSupportScreenState();
}

class _ProviderHelpSupportScreenState extends State<ProviderHelpSupportScreen> {
  final _reasonController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    // TODO(backend): submit provider support request
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.helpAndSupport),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppText.faqSectionTitle,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(20),
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(12)),
                    _ProviderFaqItem(
                      question: AppText.howDoIBookAService,
                      answer: AppText
                          .chooseAServiceSelectAProviderChooseAnAvailableDateAndTimeAndConfirmYourBooking,
                      initiallyExpanded: true,
                    ),
                    _ProviderFaqItem(
                      question: AppText.howDoIOfferAService,
                      answer: AppText
                          .chooseAServiceSelectAProviderChooseAnAvailableDateAndTimeAndConfirmYourBooking,
                    ),
                    _ProviderFaqItem(
                      question: AppText.howCanICancelABooking,
                      answer: AppText
                          .chooseAServiceSelectAProviderChooseAnAvailableDateAndTimeAndConfirmYourBooking,
                    ),
                    _ProviderFaqItem(
                      question: AppText.whatIfIHaveAnIssueWithAService,
                      answer: AppText
                          .chooseAServiceSelectAProviderChooseAnAvailableDateAndTimeAndConfirmYourBooking,
                    ),
                    _ProviderFaqItem(
                      question: AppText.howCanIContactAProvider,
                      answer: AppText
                          .chooseAServiceSelectAProviderChooseAnAvailableDateAndTimeAndConfirmYourBooking,
                    ),
                    _ProviderFaqItem(
                      question: AppText.howDoIContactNchitoSupport,
                      answer: AppText
                          .chooseAServiceSelectAProviderChooseAnAvailableDateAndTimeAndConfirmYourBooking,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),
                    Text(
                      AppText.contactUsSectionTitle,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(16),
                        fontWeight: FontWeight.w700,
                        color: AppColors.brandPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(14)),
                    AppTextField(
                      label: AppText.reasonForContact,
                      hint: AppText.enterYourReasonForContact,
                      controller: _reasonController,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(14)),
                    AppTextField(
                      label: AppText.descriptionLabel,
                      hint: AppText.pleaseDescribeYourIssueOrQuestionInDetail,
                      controller: _descriptionController,
                      maxLines: 4,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(18)),
                    AppButton(
                      text: AppText.submit,
                      onPressed: _onSubmit,
                      width: double.infinity,
                      backgroundColor: AppColors.brandPrimary,
                      textColor: AppColors.white,
                      radius: ResponsiveHelper.borderRadius(10),
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

class _ProviderFaqItem extends StatefulWidget {
  final String question;
  final String answer;
  final bool initiallyExpanded;

  const _ProviderFaqItem({
    required this.question,
    required this.answer,
    this.initiallyExpanded = false,
  });

  @override
  State<_ProviderFaqItem> createState() => _ProviderFaqItemState();
}

class _ProviderFaqItemState extends State<_ProviderFaqItem> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveHelper.padding(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(14),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlackPrimary,
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: _expanded ? math.pi / 2 : 0,
                  child: Icon(
                    Icons.chevron_right,
                    size: ResponsiveHelper.iconSize(20),
                    color: AppColors.textBlackPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          Padding(
            padding: EdgeInsets.only(
              bottom: ResponsiveHelper.padding(10),
              right: ResponsiveHelper.padding(16),
            ),
            child: Text(
              widget.answer,
              style: context.bodySmall.copyWith(
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        Divider(
          height: 1,
          thickness: 1,
          color: AppColors.borderDefault.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}
