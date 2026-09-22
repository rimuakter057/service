import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/features/user/bookings/data/models/customer_dispute_model.dart';
import 'package:nchito/features/user/bookings/presentation/providers/customer_dispute_notifier.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/dispute_status_card.dart';

class DisputeDetailsScreen extends StatefulWidget {
  static const String routeName = '/bookings/dispute-details';

  final BookingHistoryData? booking;
  final String? disputeId;
  final String? bookingId;

  const DisputeDetailsScreen({
    super.key,
    this.booking,
    this.disputeId,
    this.bookingId,
  });

  @override
  State<DisputeDetailsScreen> createState() => _DisputeDetailsScreenState();
}

class _DisputeDetailsScreenState extends State<DisputeDetailsScreen> {
  static const List<String> _fallbackEvidenceImages = [
    AssetsPath.evidenceImage1,
    AssetsPath.evidenceImage2,
    AssetsPath.evidenceImage3,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDisputeData();
    });
  }

  void _loadDisputeData({bool refresh = false}) {
    final disputeNotifier = context.read<CustomerDisputeNotifier>();
    final targetDisputeId = widget.disputeId;
    if (targetDisputeId != null && targetDisputeId.isNotEmpty) {
      disputeNotifier.fetchDisputeDetail(targetDisputeId, refresh: refresh);
    } else {
      disputeNotifier.fetchDisputes(refresh: refresh);
    }
  }

  CustomerDisputeModel? _resolveActiveDispute(CustomerDisputeNotifier notifier) {
    if (widget.disputeId != null && widget.disputeId!.isNotEmpty) {
      if (notifier.activeDispute?.id == widget.disputeId) {
        return notifier.activeDispute;
      }
    }
    final targetBookingId = widget.bookingId ?? widget.booking?.id;
    if (targetBookingId != null && targetBookingId.isNotEmpty) {
      final match = notifier.disputes.where((d) => d.booking == targetBookingId).firstOrNull;
      if (match != null) return match;
    }
    return notifier.activeDispute ?? notifier.disputes.firstOrNull;
  }

  Widget _buildEvidenceThumbnail(String imgPath) {
    final isNetwork = imgPath.startsWith('http://') || imgPath.startsWith('https://');

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        ResponsiveHelper.borderRadius(10),
      ),
      child: AspectRatio(
        aspectRatio: 1.25,
        child: isNetwork
            ? Image.network(
                imgPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildFallbackIcon(),
              )
            : Image.asset(
                imgPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildFallbackIcon(),
              ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      color: AppColors.bgOverlay.withValues(alpha: 0.1),
      child: const Icon(
        Icons.broken_image_outlined,
        size: 24,
        color: AppColors.textDisabled,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldColor = AppColors.bgOverlay.withValues(alpha: 0.04);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.disputeDetails),
            Expanded(
              child: Consumer<CustomerDisputeNotifier>(
                builder: (context, disputeNotifier, child) {
                  final dispute = _resolveActiveDispute(disputeNotifier);

                  final issueType = (dispute?.reason != null && dispute!.reason!.trim().isNotEmpty)
                      ? dispute.reason!.trim()
                      : AppText.serviceQuality;

                  final submittedOn = dispute != null
                      ? dispute.formattedSubmittedOn
                      : '27 Aug 2026 - 06:20 AM';

                  final message = (dispute?.description != null && dispute!.description!.trim().isNotEmpty)
                      ? dispute.description!.trim()
                      : AppText.theServiceWasCompletedButINoticeAnIssueWithTheWorkAfterward;

                  final evidenceList = (dispute?.evidence != null && dispute!.evidence.isNotEmpty)
                      ? dispute.evidence.map((e) => e.file).toList()
                      : _fallbackEvidenceImages;

                  final status = (dispute?.status != null && dispute!.status.isNotEmpty)
                      ? dispute.status
                      : AppText.inReview;

                  final bannerText = (dispute?.resolutionNote != null && dispute!.resolutionNote!.isNotEmpty)
                      ? dispute.resolutionNote!
                      : (dispute?.statusMessage != null && dispute!.statusMessage!.isNotEmpty
                          ? dispute.statusMessage!
                          : AppText.ourTeamIsReviewingYourIssueWeWillUpdateYouOnceADecisionIsMade);

                  return RefreshIndicator(
                    color: AppColors.brandPrimary,
                    onRefresh: () async {
                      _loadDisputeData(refresh: true);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                                  issueType,
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
                                  submittedOn,
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
                                  children: evidenceList.map((imgPath) {
                                    return Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ResponsiveHelper.padding(3),
                                        ),
                                        child: _buildEvidenceThumbnail(imgPath),
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
                                  message,
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
                          DisputeStatusCard(
                            status: status,
                            bannerText: bannerText,
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
