import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_text_field/app_text_field.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

/// Help & Support screen — an FAQ accordion plus a "Contact us" form.
/// Navigated to from [ProfileScreen]'s "Help & Support" menu tile.
class HelpSupportScreen extends StatefulWidget {
  static const String routeName = '/help-support';

  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _reasonController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    // TODO(backend): send the contact-us request here once the backend is
    // available.
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

                    _FaqTile(
                      question: AppText.howDoIBookAService,
                      answer: AppText
                          .chooseAServiceSelectAProviderChooseAnAvailableDateAndTimeAndConfirmYourBooking,
                      initiallyExpanded: true,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    // The remaining FAQ answers aren't in the design yet —
                    // shown collapsed until that content is provided.
                    _FaqTile(question: AppText.howDoIOfferAService),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    _FaqTile(question: AppText.howCanICancelABooking),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    _FaqTile(question: AppText.whatIfIHaveAnIssueWithAService),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    _FaqTile(question: AppText.howCanIContactAProvider),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    _FaqTile(question: AppText.howDoIContactNchitoSupport),
                    SizedBox(height: ResponsiveHelper.spacing(32)),

                    Text(
                      AppText.contactUsSectionTitle,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(20),
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(12)),

                    AppTextField(
                      label: AppText.reasonForContact,
                      hint: AppText.enterYourReasonForContact,
                      controller: _reasonController,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),
                    AppTextField(
                      label: AppText.descriptionLabel,
                      hint: AppText.pleaseDescribeYourIssueOrQuestionInDetail,
                      controller: _descriptionController,
                      maxLines: 4,
                      minLines: 4,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),

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

class _FaqTile extends StatefulWidget {
  final String question;
  final String? answer;
  final bool initiallyExpanded;

  const _FaqTile({
    required this.question,
    this.answer,
    this.initiallyExpanded = false,
  });

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final isExpandable = widget.answer != null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.brandSoft),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
      ),
      child: GestureDetector(
        onTap: isExpandable
            ? () => setState(() => _expanded = !_expanded)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: context.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlackPrimary,
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: _expanded ? math.pi : 0,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: ResponsiveHelper.iconSize(16),
                    color: AppColors.textBlackPrimary,
                  ),
                ),
              ],
            ),
            if (_expanded && widget.answer != null) ...[
              SizedBox(height: ResponsiveHelper.spacing(10)),
              Divider(height: 1, color: AppColors.brandSoft),
              SizedBox(height: ResponsiveHelper.spacing(10)),
              Text(
                widget.answer!,
                style: context.bodySmall.copyWith(
                  fontSize: ResponsiveHelper.fontSize(13),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
