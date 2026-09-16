import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/dispute_status_card.dart';

class DisputeDetailsScreen extends StatelessWidget {
  static const String routeName = '/bookings/dispute-details';

  final BookingHistoryData? booking;

  const DisputeDetailsScreen({super.key, this.booking});

  static const List<String> _evidenceImages = [
    AssetsPath.evidenceImage1,
    AssetsPath.evidenceImage2,
    AssetsPath.evidenceImage3,
  ];

  @override
  Widget build(BuildContext context) {
    final fieldColor = AppColors.bgOverlay.withValues(alpha: 0.04);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.disputeDetails),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ResponsiveHelper.spacing(12)),

                    /// Card 1: Dispute Details Card
                    AppContainerBg(
                      width: double.infinity,
                      color: fieldColor,
                      radius: ResponsiveHelper.borderRadius(14),
                      padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppText.disputeDetails,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(14),
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textBlackPrimary,
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(10)),
                          Container(
                            width: double.infinity,
                            height: 0.5,
                            color: AppColors.textDisabled.withValues(alpha: 0.3),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(12)),

                          // Issue Type
                          Text(
                            AppText.issueType,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(12),
                              fontStyle: FontStyle.italic,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(4)),
                          Text(
                            AppText.serviceQuality,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(14),
                              fontWeight: FontWeight.w700,
                              color: AppColors.textBlackPrimary,
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(14)),

                          // Submitted On
                          Text(
                            AppText.submittedOn,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(12),
                              fontStyle: FontStyle.italic,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(4)),
                          Text(
                            '27 Aug 2026 - 06:20 AM',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(14),
                              fontWeight: FontWeight.w700,
                              color: AppColors.textBlackPrimary,
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(14)),

                          // Evidence
                          Text(
                            AppText.evidence,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(12),
                              fontStyle: FontStyle.italic,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(8)),
                          Row(
                            children: _evidenceImages.map((imgPath) {
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveHelper.padding(3),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveHelper.borderRadius(10),
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 1.25,
                                      child: Image.asset(
                                        imgPath,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: AppColors.bgOverlay.withValues(alpha: 0.1),
                                          child: const Icon(
                                            Icons.broken_image_outlined,
                                            size: 24,
                                            color: AppColors.textDisabled,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(14)),

                          // Message
                          Text(
                            AppText.message,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(12),
                              fontStyle: FontStyle.italic,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(4)),
                          Text(
                            AppText.theServiceWasCompletedButINoticeAnIssueWithTheWorkAfterward,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(12.5),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBlackPrimary,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: ResponsiveHelper.spacing(12)),

                    /// Card 2: Dispute Status Card (reused widget)
                    const DisputeStatusCard(
                      status: AppText.inReview,
                      bannerText: AppText
                          .ourTeamIsReviewingYourIssueWeWillUpdateYouOnceADecisionIsMade,
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
