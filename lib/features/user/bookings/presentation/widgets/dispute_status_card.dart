import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_container_bg/app_container_bg.dart';

/// Reusable Dispute Status Card used in Booking Details and Dispute Details screens.
class DisputeStatusCard extends StatelessWidget {
  final String status;
  final String? statusLabel;
  final String? bannerText;
  final Color? bannerBgColor;
  final Color? bannerTextColor;
  final VoidCallback? onViewTap;
  final VoidCallback? onTap;

  const DisputeStatusCard({
    super.key,
    required this.status,
    this.statusLabel,
    this.bannerText,
    this.bannerBgColor,
    this.bannerTextColor,
    this.onViewTap,
    this.onTap,
  });

  bool get _isResolved =>
      status.trim().toLowerCase() == AppText.resolved.toLowerCase();

  String get _displayStatusText {
    if (statusLabel != null && statusLabel!.isNotEmpty) {
      return statusLabel!;
    }
    return _isResolved ? AppText.resolved : AppText.inReview;
  }

  @override
  Widget build(BuildContext context) {
    final cardWidget = AppContainerBg(
      width: double.infinity,
      color: AppColors.bgOverlay.withValues(alpha: 0.04),
      radius: ResponsiveHelper.borderRadius(12),
      padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveHelper.width(36),
                height: ResponsiveHelper.width(36),
                decoration: BoxDecoration(
                  color: AppColors.disputeShieldBg,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(8),
                  ),
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: ResponsiveHelper.iconSize(20),
                        color: AppColors.disputeShieldIcon,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Icon(
                          Icons.gavel_rounded,
                          size: ResponsiveHelper.iconSize(10),
                          color: AppColors.disputeShieldIcon,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.spacing(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppText.disputeStatus,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(12),
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(4)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(8),
                        vertical: ResponsiveHelper.padding(2.5),
                      ),
                      decoration: BoxDecoration(
                        color: _isResolved
                            ? AppColors.disputeResolvedBg
                            : AppColors.disputeBannerBg.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: _isResolved
                              ? AppColors.disputeResolvedBorder
                                  .withValues(alpha: 0.5)
                              : AppColors.disputeInReviewBorder
                                  .withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isResolved
                                  ? AppColors.disputeResolvedText
                                  : AppColors.disputeBannerText,
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(4)),
                          Text(
                            _displayStatusText,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(12),
                              fontWeight: FontWeight.w500,
                              color: _isResolved
                                  ? AppColors.disputeResolvedText
                                  : AppColors.disputeBannerText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (onViewTap != null)
                GestureDetector(
                  onTap: onViewTap,
                  child: Container(
                    width: ResponsiveHelper.width(36),
                    height: ResponsiveHelper.height(36),
                    decoration: BoxDecoration(
                      color: AppColors.disputeEyeBg,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(8),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.remove_red_eye_outlined,
                      size: ResponsiveHelper.iconSize(18),
                      color: AppColors.disputeEyeIcon,
                    ),
                  ),
                ),
            ],
          ),
          if (bannerText != null) ...[
            SizedBox(height: ResponsiveHelper.spacing(12)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(14),
                vertical: ResponsiveHelper.padding(12),
              ),
              decoration: BoxDecoration(
                color: bannerBgColor ??
                    AppColors.disputeBannerBg.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(10),
                ),
              ),
              child: Text(
                bannerText!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(12),
                  color: bannerTextColor ?? AppColors.disputeBannerText,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: cardWidget,
      );
    }

    if (onViewTap != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onViewTap,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}
