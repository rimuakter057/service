import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nchito/features/common/cms_support/presentation/providers/faq_notifier.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FaqNotifier>().fetchFaqs();
    });
  }

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
              child: Consumer<FaqNotifier>(
                builder: (context, notifier, child) {
                  return RefreshIndicator(
                    color: AppColors.brandPrimary,
                    onRefresh: () => notifier.fetchFaqs(forceRefresh: true),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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

                          if (notifier.isLoading && notifier.faqs.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 24.0),
                                child: CircularProgressIndicator(
                                  color: AppColors.brandPrimary,
                                ),
                              ),
                            )
                          else if (notifier.errorMessage != null &&
                              notifier.faqs.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      notifier.errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.red,
                                        fontSize: ResponsiveHelper.fontSize(14),
                                      ),
                                    ),
                                    SizedBox(
                                      height: ResponsiveHelper.spacing(12),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.brandPrimary,
                                      ),
                                      onPressed: () => notifier.fetchFaqs(
                                        forceRefresh: true,
                                      ),
                                      child: const Text(
                                        'Retry',
                                        style:
                                            TextStyle(color: AppColors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (notifier.faqs.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'No FAQs available at the moment.',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(14),
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: notifier.faqs.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: ResponsiveHelper.spacing(10)),
                              itemBuilder: (context, index) {
                                final faq = notifier.faqs[index];
                                return _FaqTile(
                                  key: ValueKey(faq.id),
                                  question: faq.question,
                                  answer: faq.answer.isNotEmpty
                                      ? faq.answer
                                      : null,
                                  initiallyExpanded: index == 0,
                                );
                              },
                            ),

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
                            hint: AppText
                                .pleaseDescribeYourIssueOrQuestionInDetail,
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

class _FaqTile extends StatefulWidget {
  final String question;
  final String? answer;
  final bool initiallyExpanded;

  const _FaqTile({
    super.key,
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
    final isExpandable = widget.answer != null && widget.answer!.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.brandSoft),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
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
            if (_expanded && isExpandable) ...[
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
