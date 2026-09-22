import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/features/provider/bookings/data/models/provider_dispute_model.dart';
import 'package:nchito/features/provider/bookings/presentation/providers/provider_dispute_notifier.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/provider_booking_sample_data.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/dispute_status_card.dart';

/// Provider Dispute Details Screen — reached from the booking details
/// screen's dispute card. `booking` is whatever was passed as `extra` on
/// navigation (a [ProviderBookingData] today).
class ProviderDisputeDetailsScreen extends StatefulWidget {
  static const String routeName = '/provider/dispute-details';

  final dynamic booking;
  final String? disputeId;

  const ProviderDisputeDetailsScreen({super.key, this.booking, this.disputeId});

  @override
  State<ProviderDisputeDetailsScreen> createState() =>
      _ProviderDisputeDetailsScreenState();
}

class _ProviderDisputeDetailsScreenState
    extends State<ProviderDisputeDetailsScreen> {
  static const List<String> _fallbackEvidenceImages = [
    AssetsPath.evidenceImage1,
    AssetsPath.evidenceImage2,
    AssetsPath.evidenceImage3,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDisputeData());
  }

  void _loadDisputeData({bool refresh = false}) {
    final notifier = context.read<ProviderDisputeNotifier>();
    if (widget.disputeId != null && widget.disputeId!.isNotEmpty) {
      notifier.fetchDisputeDetail(widget.disputeId!, refresh: refresh);
    } else {
      notifier.fetchDisputes(refresh: refresh);
    }
  }

  ProviderDisputeModel? _resolveActiveDispute(ProviderDisputeNotifier notifier) {
    if (widget.disputeId != null && widget.disputeId!.isNotEmpty) {
      if (notifier.activeDispute?.id == widget.disputeId) {
        return notifier.activeDispute;
      }
    }
    final targetBookingId =
        widget.booking is ProviderBookingData ? widget.booking.id : null;
    if (targetBookingId != null && targetBookingId.isNotEmpty) {
      final match =
          notifier.disputes.where((d) => d.booking == targetBookingId).firstOrNull;
      if (match != null) return match;
    }
    return notifier.activeDispute ?? notifier.disputes.firstOrNull;
  }

  Widget _buildEvidenceThumbnail(String imgPath) {
    final isNetwork = imgPath.startsWith('http://') || imgPath.startsWith('https://');
    return ClipRRect(
      borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
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

  /// The resolved-state banner copy. Prefers whatever the backend sends
  /// (`resolution_note` / `status_message`) and only falls back to a
  /// composed sentence — matching the Figma's wording — when neither is
  /// populated. No resolved dispute was available to confirm the live
  /// shape against, so this fallback is a best guess from the field
  /// names; worth re-checking once a real one exists.
  String _resolutionBannerText(ProviderDisputeModel dispute) {
    if (dispute.resolutionNote != null && dispute.resolutionNote!.isNotEmpty) {
      return dispute.resolutionNote!;
    }
    if (dispute.statusMessage != null && dispute.statusMessage!.isNotEmpty) {
      return dispute.statusMessage!;
    }
    final amount = dispute.refundAmount;
    switch (dispute.resolution) {
      case 'full_refund':
        return amount != null
            ? 'ZMW $amount has been fully refunded to the customer. The 5% Nchito platform fee is non-refundable.'
            : 'The customer has been fully refunded. The 5% Nchito platform fee is non-refundable.';
      case 'partial_refund':
        return amount != null
            ? 'ZMW $amount has been refunded to the customer. The 5% Nchito platform fee is non-refundable.'
            : 'A partial refund has been issued to the customer.';
      case 'no_refund':
        return 'This dispute was resolved with no refund issued.';
      default:
        return 'This dispute has been resolved.';
    }
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
              child: Consumer<ProviderDisputeNotifier>(
                builder: (context, disputeNotifier, child) {
                  final dispute = _resolveActiveDispute(disputeNotifier);

                  // The provider's own reply, if one has been submitted —
                  // the most recent entry in `responses`.
                  final myResponse = (dispute?.responses.isNotEmpty ?? false)
                      ? dispute!.responses.last
                      : null;

                  final submittedOn = dispute != null
                      ? dispute.formattedSubmittedOn
                      : '27 Aug 2026 - 06:20 AM';

                  final message = (myResponse?.message != null &&
                          myResponse!.message!.trim().isNotEmpty)
                      ? myResponse.message!.trim()
                      : AppText.theServiceWasCompletedButINoticeAnIssueWithTheWorkAfterward;

                  final evidenceList = (myResponse?.evidence.isNotEmpty ?? false)
                      ? myResponse!.evidence.map((e) => e.file).toList()
                      : ((dispute?.evidence.isNotEmpty ?? false)
                          ? dispute!.evidence.map((e) => e.file).toList()
                          : _fallbackEvidenceImages);

                  final hasResponded = myResponse != null ||
                      (dispute != null && !dispute.awaitingResponse);

                  final isResolved =
                      dispute?.status.trim().toLowerCase() == 'resolved';

                  final status = (dispute?.status.isNotEmpty ?? false)
                      ? dispute!.status
                      : AppText.disputed;

                  final cardTitle =
                      isResolved ? AppText.disputeDetails : AppText.disputeResponse;

                  final statusLabel = isResolved
                      ? AppText.resolved
                      : (hasResponded
                          ? AppText.inReview
                          : AppText.responseRequired);

                  final bannerText = isResolved
                      ? _resolutionBannerText(dispute!)
                      : ((dispute?.resolutionNote != null &&
                              dispute!.resolutionNote!.isNotEmpty)
                          ? dispute.resolutionNote!
                          : (dispute?.statusMessage != null &&
                                  dispute!.statusMessage!.isNotEmpty
                              ? dispute.statusMessage!
                              : (hasResponded
                                  ? AppText
                                      .yourDisputeResponseHasBeenSubmittedSuccessfullyOurTeamIsCurrentlyReviewingTheCase
                                  : AppText
                                      .ourTeamIsReviewingYourIssueWeWillUpdateYouOnceADecisionIsMade)));

                  final bannerBgColor = isResolved
                      ? AppColors.disputeResolvedBg
                      : const Color(0xFFE2E8F0);
                  final bannerTextColor = isResolved
                      ? AppColors.disputeResolvedText
                      : const Color(0xFF475569);

                  return RefreshIndicator(
                    color: AppColors.brandPrimary,
                    onRefresh: () async => _loadDisputeData(refresh: true),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: ResponsiveHelper.spacing(12)),

                          /// Card 1: Dispute Response Card
                          AppContainerBg(
                            width: double.infinity,
                            color: fieldColor,
                            radius: ResponsiveHelper.borderRadius(14),
                            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cardTitle,
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

                                // Your Response
                                Text(
                                  AppText.yourResponse,
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
                              ],
                            ),
                          ),

                          SizedBox(height: ResponsiveHelper.spacing(12)),

                          /// Card 2: Dispute Status Card (reused widget)
                          DisputeStatusCard(
                            status: status,
                            statusLabel: statusLabel,
                            bannerText: bannerText,
                            bannerBgColor: bannerBgColor,
                            bannerTextColor: bannerTextColor,
                          ),

                          SizedBox(height: ResponsiveHelper.spacing(24)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Action: Responded button — hidden once the dispute is
            // resolved, there's nothing left to action.
            Selector<ProviderDisputeNotifier, bool>(
              selector: (context, notifier) =>
                  _resolveActiveDispute(notifier)?.status.trim().toLowerCase() ==
                  'resolved',
              builder: (context, isResolved, child) {
                if (isResolved) return const SizedBox.shrink();
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.padding(24),
                    vertical: ResponsiveHelper.padding(16),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveHelper.padding(14),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(10),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      AppText.responded,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(14),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
