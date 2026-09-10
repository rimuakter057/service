import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

/// Modal bottom sheet for submitting a rating and review for a completed booking.
class LeaveReviewBottomSheet extends StatefulWidget {
  final String providerName;
  final Function(int rating, String comment) onSubmit;

  const LeaveReviewBottomSheet({
    super.key,
    required this.providerName,
    required this.onSubmit,
  });

  @override
  State<LeaveReviewBottomSheet> createState() => _LeaveReviewBottomSheetState();
}

class _LeaveReviewBottomSheetState extends State<LeaveReviewBottomSheet> {
  int _rating = 4;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Title & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppText.leaveAReview,
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
                'Share your experience with ${widget.providerName} and let others know how the service went.',
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(12.5),
                  color: const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(18)),

              // Star Rating Row (Interactive 1-5 Stars)
              Row(
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  final isSelected = starIndex <= _rating;
                  return GestureDetector(
                    onTap: () => setState(() => _rating = starIndex),
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: ResponsiveHelper.spacing(10),
                      ),
                      child: Icon(
                        isSelected
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: ResponsiveHelper.iconSize(38),
                        color: isSelected
                            ? const Color(0xFFFABD24)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: ResponsiveHelper.spacing(18)),

              // "Your Review" Label
              Text(
                AppText.yourReview,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(13),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(8)),

              // Feedback Text Area Container
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
                      controller: _reviewController,
                      maxLines: 4,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(12),
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        hintText: AppText.shareYourFeedbackAboutTheProvider,
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

              // Bottom Actions: Cancel & Submit
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
                      text: AppText.submit,
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onSubmit(_rating, _reviewController.text);
                      },
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
    );
  }
}
