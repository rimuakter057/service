import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'report_issue_confirm_bottom_sheet.dart';

/// Modal bottom sheet for reporting an issue with a booking (matching Screenshot 1).
class ReportIssueBottomSheet extends StatefulWidget {
  final Function(
    String issueType,
    String description,
    List<String> evidenceImages,
  ) onSubmit;

  const ReportIssueBottomSheet({
    super.key,
    required this.onSubmit,
  });

  @override
  State<ReportIssueBottomSheet> createState() => _ReportIssueBottomSheetState();
}

class _ReportIssueBottomSheetState extends State<ReportIssueBottomSheet> {
  final TextEditingController _issueTypeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _evidenceImages = [
    AssetsPath.evidenceImage1,
    AssetsPath.evidenceImage2,
    AssetsPath.evidenceImage3,
    AssetsPath.evidenceImage1,
  ];

  @override
  void dispose() {
    _issueTypeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addEvidence() {
    setState(() {
      _evidenceImages.add(AssetsPath.evidenceImage2);
    });
  }

  void _onSubmitIssue() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (_) => ReportIssueConfirmBottomSheet(
        onConfirm: () {
          Navigator.of(context).pop(); // Close ReportIssueBottomSheet
          widget.onSubmit(
            _issueTypeController.text,
            _descriptionController.text,
            _evidenceImages,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: ResponsiveHelper.padding(20),
            right: ResponsiveHelper.padding(20),
            top: ResponsiveHelper.padding(20),
            bottom: ResponsiveHelper.padding(28),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(ResponsiveHelper.borderRadius(24)),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row: Title & Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppText.reportAnIssue,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(19),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close_rounded,
                          size: ResponsiveHelper.iconSize(22),
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.spacing(6)),

                // Subtitle
                Text(
                  AppText.tellUsWhatWentWrongWithYourService,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(12.5),
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(18)),

                // Issue Type Label
                Text(
                  AppText.issueType,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(13),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(8)),

                // Issue Type Text Field
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(10),
                    ),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.padding(14),
                    vertical: ResponsiveHelper.padding(12),
                  ),
                  child: TextField(
                    controller: _issueTypeController,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(13),
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: AppText.enterYourIssueType,
                      hintStyle: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(12.5),
                        color: const Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(16)),

                // Upload Evidence Label
                Text(
                  AppText.uploadEvidence,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(13),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(8)),

                // Upload Button Box
                GestureDetector(
                  onTap: _addEvidence,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveHelper.padding(14),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(10),
                      ),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: ResponsiveHelper.iconSize(20),
                          color: const Color(0xFF94A3B8),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(8)),
                        Text(
                          AppText.uploadImagesHere,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(12.5),
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(10)),

                // Evidence Thumbnails Horizontal List
                if (_evidenceImages.isNotEmpty)
                  SizedBox(
                    height: ResponsiveHelper.width(72),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _evidenceImages.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(width: ResponsiveHelper.spacing(8)),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(10),
                              ),
                              child: Image.asset(
                                _evidenceImages[index],
                                width: ResponsiveHelper.width(72),
                                height: ResponsiveHelper.width(72),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => setState(
                                  () => _evidenceImages.removeAt(index),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Color(0x99000000),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                SizedBox(height: ResponsiveHelper.spacing(16)),

                // Describe The Issue Label
                Text(
                  AppText.describeTheIssue,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(13),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(8)),

                // Describe Issue Text Area Container
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(12),
                    ),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
                  child: Column(
                    children: [
                      TextField(
                        controller: _descriptionController,
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(12),
                          color: const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          hintText: AppText.pleaseProvideAsMuchDetailAsPossible,
                          hintStyle: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(12),
                            color: const Color(0xFF94A3B8),
                            height: 1.35,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Icon(
                            Icons.drag_handle_rounded,
                            size: 14,
                            color: Colors.grey.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(22)),

                // Bottom Actions: Cancel & Submit Issue
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: AppText.cancel,
                        onPressed: () => Navigator.of(context).pop(),
                        backgroundColor: AppColors.bgOverlay.withValues(
                          alpha: 0.04,
                        ),
                        borderColor: AppColors.textDisabled,
                        textColor: AppColors.textDisabled,
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.spacing(14)),
                    Expanded(
                      child: AppButton(
                        text: AppText.submitIssue,
                        onPressed: _onSubmitIssue,
                        backgroundColor: AppColors.brandPrimary,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
