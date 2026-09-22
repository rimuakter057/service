import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_confirm_bottom_sheet/app_confirm_bottom_sheet.dart';
import 'package:nchito/features/common/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_availability/provider_availability_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_details/provider_details_screen.dart';
import 'package:nchito/features/user/home/presentation/widgets/detail_field.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/booking_details_shimmer.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/cancel_booking_bottom_sheet.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/decline_quote_bottom_sheet.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/leave_review_bottom_sheet.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/proceed_to_payment_bottom_sheet.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/report_issue_bottom_sheet.dart';
import 'package:nchito/features/common/common_widgets/app_reschedule_booking_bottom_sheet/app_reschedule_booking_bottom_sheet.dart';
import 'package:nchito/features/common/common_widgets/app_snackbar/app_snackbar.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/dispute_status_card.dart';
import 'package:nchito/features/user/bookings/presentation/providers/customer_booking_detail_notifier.dart';
import 'package:nchito/features/user/bookings/presentation/providers/customer_dispute_notifier.dart';
import 'package:nchito/features/user/reviews/presentation/providers/customer_review_notifier.dart';
import 'package:nchito/features/user/bookings/data/models/customer_booking_detail_model.dart';
import '../dispute_details/dispute_details_screen.dart';
import '../dpo_checkout/dpo_checkout_screen.dart';

/// Single booking — reached by tapping an item on the My Bookings screen.
///
/// Shows the plain "Cancel Booking" action for most statuses, and swaps in
/// a Payment Info card plus "Decline Quote" / "Proceed to Pay" / "Message
/// Provider" actions once a quote has been accepted (`booking.serviceCost`
/// is set).
class BookingDetailsScreen extends StatefulWidget {
  static const String routeName = '/bookings/booking-details';

  final BookingHistoryData? booking;
  final String? bookingId;

  const BookingDetailsScreen({super.key, this.booking, this.bookingId});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool _isReviewed = false;
  int _rating = 5;
  String _reviewComment = '';
  bool _isDisputeCancelled = false;

  late BookingHistoryData _initialBooking;

  @override
  void initState() {
    super.initState();
    _initialBooking = widget.booking ?? myBookingsHistory.first;
    final effectiveId = widget.bookingId ?? widget.booking?.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = context.read<CustomerBookingDetailNotifier>();
      notifier.clear();
      if (effectiveId != null && effectiveId.isNotEmpty) {
        notifier.fetchBookingDetail(effectiveId);
      }
    });
  }

  Color _resolveStatusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('accept')) {
      return AppColors.blueStatusInfo;
    }
    if (s.contains('schedul') || s.contains('confirm')) {
      return AppColors.emerald400;
    }
    if (s.contains('progress')) {
      return const Color(0xFF8B5CF6);
    }
    if (s.contains('complet')) {
      return AppColors.emerald400;
    }
    if (s.contains('cancel')) {
      return AppColors.red400;
    }
    if (s.contains('reject')) {
      return AppColors.red;
    }
    if (s.contains('disput')) {
      return AppColors.orange400;
    }
    return AppColors.amber500; // Pending
  }

  Widget _buildProviderAvatar(String photo) {
    if (photo.startsWith('http://') || photo.startsWith('https://')) {
      return Image.network(
        photo,
        width: ResponsiveHelper.width(44),
        height: ResponsiveHelper.width(44),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => AppIcon(
          assetPath: AssetsPath.providerRobert,
          size: ResponsiveHelper.width(44),
          fit: BoxFit.cover,
        ),
      );
    }
    return AppIcon(
      assetPath: photo.isNotEmpty ? photo : AssetsPath.providerRobert,
      size: ResponsiveHelper.width(44),
      fit: BoxFit.cover,
    );
  }

  Widget _buildCustomerAvatar(String? avatarUrl) {
    if (avatarUrl != null &&
        (avatarUrl.startsWith('http://') || avatarUrl.startsWith('https://'))) {
      return Image.network(
        avatarUrl,
        width: ResponsiveHelper.width(36),
        height: ResponsiveHelper.width(36),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          AssetsPath.avatarUser,
          width: ResponsiveHelper.width(36),
          height: ResponsiveHelper.width(36),
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      AssetsPath.avatarUser,
      width: ResponsiveHelper.width(36),
      height: ResponsiveHelper.width(36),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.emerald50,
        child: const Icon(
          Icons.person,
          color: AppColors.brandPrimary,
          size: 20,
        ),
      ),
    );
  }

  // Figma: rgba(0,0,0,0.04) bg, 10px radius, 14px padding, 8px label/value gap
  static final _fieldColor = AppColors.bgOverlay.withValues(alpha: 0.04);
  static final _fieldRadius = ResponsiveHelper.borderRadius(10);
  static final _fieldPadding = EdgeInsets.all(ResponsiveHelper.padding(14));
  static final _fieldGap = ResponsiveHelper.spacing(8);

  void _onDeclineQuote(BuildContext context, [String? bookingId]) {
    final targetId = bookingId ?? widget.bookingId ?? widget.booking?.id;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => DeclineQuoteBottomSheet(
        onConfirm: () async {
          Navigator.of(context).pop();
          if (targetId != null && targetId.isNotEmpty) {
            final success = await context
                .read<CustomerBookingDetailNotifier>()
                .declineQuote(targetId, reason: 'Declined by customer');
            if (!context.mounted) return;
            if (success) {
              AppSnackbar.showSuccess(context, 'Quote declined successfully');
            } else {
              final err = context
                      .read<CustomerBookingDetailNotifier>()
                      .actionErrorMessage ??
                  'Failed to decline quote';
              AppSnackbar.showError(context, err);
            }
          }
        },
      ),
    );
  }

  void _onProceedToPay(
      BuildContext context, BookingHistoryData currentBooking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => ProceedToPaymentBottomSheet(
        serviceCost: currentBooking.serviceCost ?? 'ZMW 0',
        onConfirm: () {
          context.pop();
          context.push(
            DpoCheckoutScreen.routeName,
            extra: currentBooking,
          );
        },
      ),
    );
  }

  void _onCancelBooking(BuildContext context, [String? bookingId]) {
    final targetId = bookingId ?? widget.bookingId ?? widget.booking?.id;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => CancelBookingBottomSheet(
        onConfirm: () async {
          Navigator.of(context).pop();
          if (targetId != null && targetId.isNotEmpty) {
            final success = await context
                .read<CustomerBookingDetailNotifier>()
                .cancelBooking(targetId);
            if (!context.mounted) return;
            if (success) {
              AppSnackbar.showSuccess(context, 'Booking cancelled successfully');
            } else {
              final err = context
                      .read<CustomerBookingDetailNotifier>()
                      .actionErrorMessage ??
                  'Failed to cancel booking';
              AppSnackbar.showError(context, err);
            }
          }
        },
      ),
    );
  }

  void _onRescheduleBooking(BuildContext context, [BookingHistoryData? currentBooking]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => AppRescheduleBookingBottomSheet(
        description: AppText.youReAboutToRequestANewDateAndTimeForThisBooking,
        onConfirm: () {
          context.push(
            ProviderAvailabilityScreen.routeName,
            extra: currentBooking ?? _initialBooking,
          );
        },
      ),
    );
  }

  void _onLeaveReview(BuildContext context,
      [String? providerName, String? bookingId]) {
    final targetId = bookingId ?? widget.bookingId ?? widget.booking?.id;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      builder: (_) => LeaveReviewBottomSheet(
        providerName: providerName ?? _initialBooking.providerName,
        onSubmit: (rating, comment) async {
          setState(() {
            _isReviewed = true;
            _rating = rating;
            _reviewComment = comment;
          });
          if (targetId == null || targetId.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Thank you for rating $rating stars!'),
                duration: const Duration(seconds: 2),
              ),
            );
            return;
          }
          final notifier = context.read<CustomerReviewNotifier>();
          final ok = await notifier.submitReview(
            booking: targetId,
            rating: rating,
            comment: comment,
          );
          if (!context.mounted) return;
          if (ok) {
            AppSnackbar.showSuccess(context, 'Thank you for rating $rating stars!');
          } else {
            AppSnackbar.showError(
              context,
              notifier.submitErrorMessage ?? 'Failed to submit review',
            );
          }
        },
      ),
    );
  }

  void _onReportIssue(BuildContext context, [String? bookingId]) {
    final targetId = bookingId ?? widget.bookingId ?? widget.booking?.id;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (_) => ReportIssueBottomSheet(
        onSubmit: (issueType, description, images) async {
          if (targetId != null && targetId.isNotEmpty) {
            final res = await context
                .read<CustomerDisputeNotifier>()
                .createDispute(
                  booking: targetId,
                  reason: issueType.isNotEmpty ? issueType : 'Service Issue',
                  description: description.isNotEmpty
                      ? description
                      : 'Issue reported with service',
                  evidenceFiles: images,
                );
            if (!context.mounted) return;
            if (res != null) {
              AppSnackbar.showSuccess(
                context,
                'Issue submitted successfully! Our team will review it.',
              );
              // Refresh live booking detail to update dispute card/status
              context
                  .read<CustomerBookingDetailNotifier>()
                  .fetchBookingDetail(targetId, refresh: true);
            } else {
              final err = context
                      .read<CustomerDisputeNotifier>()
                      .actionErrorMessage ??
                  'Failed to submit issue';
              AppSnackbar.showError(context, err);
            }
          }
        },
      ),
    );
  }

  void _onCancelDispute(BuildContext context, [CustomerBookingDetailModel? detail]) {
    final disputeId = detail?.dispute?.toString() ??
        detail?.disputeStatus ??
        widget.bookingId ??
        widget.booking?.id;
    final bookingId = widget.bookingId ?? widget.booking?.id;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AppConfirmBottomSheet(
        icon: AppIcon(
          assetPath: AssetsPath.bookServiceIconInformationLarge,
          size: ResponsiveHelper.iconSize(60),
        ),
        title: AppText.cancelDisputeExclaim,
        description: Text(
          AppText
              .areYouSureYouWantToCancelThisDisputeYouWillNoLongerBeAbleToContinueWithThisIssue,
          textAlign: TextAlign.center,
          style: context.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        cancelLabel: AppText.cancel,
        confirmLabel: AppText.confirm,
        confirmColor: AppColors.brandPrimary,
        onConfirm: () async {
          Navigator.of(context).pop();
          if (disputeId != null && disputeId.isNotEmpty) {
            final success = await context
                .read<CustomerDisputeNotifier>()
                .cancelDispute(disputeId, booking: bookingId);
            if (!context.mounted) return;
            if (success) {
              setState(() {
                _isDisputeCancelled = true;
              });
              AppSnackbar.showSuccess(context, 'Dispute cancelled successfully');
              if (bookingId != null) {
                context
                    .read<CustomerBookingDetailNotifier>()
                    .fetchBookingDetail(bookingId, refresh: true);
              }
            } else {
              final err = context
                      .read<CustomerDisputeNotifier>()
                      .actionErrorMessage ??
                  'Failed to cancel dispute';
              AppSnackbar.showError(context, err);
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveId = widget.bookingId ?? widget.booking?.id;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.bookingDetails),
            Expanded(
              child: Consumer<CustomerBookingDetailNotifier>(
                builder: (context, detailNotifier, child) {
                  final isCurrent = detailNotifier.currentBookingId == effectiveId;
                  final isLoading = detailNotifier.isLoading || (!isCurrent && effectiveId != null);
                  final detail = isCurrent ? detailNotifier.bookingDetail : null;

                  if (isLoading || detail == null) {
                    return const BookingDetailsShimmer();
                  }

                  final activeBooking = detail.toBookingHistoryData(
                      fallbackProvider: _initialBooking.provider);

                  final hasQuote = activeBooking.serviceCost != null &&
                      activeBooking.serviceCost!.isNotEmpty;
                  final statusColor = _resolveStatusColor(activeBooking.status);

                  return RefreshIndicator(
                    color: AppColors.brandPrimary,
                    onRefresh: () async {
                      if (effectiveId != null && effectiveId.isNotEmpty) {
                        await context
                            .read<CustomerBookingDetailNotifier>()
                            .fetchBookingDetail(effectiveId, refresh: true);
                      }
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///service type=============================================
                          Row(
                            children: [
                              BgIcon(
                                assetPath: activeBooking.iconAsset,
                                bgColor: activeBooking.iconBgColor,
                                bgSize: ResponsiveHelper.width(44),
                                radius: ResponsiveHelper.borderRadius(11),
                                iconSize: ResponsiveHelper.iconSize(24),
                                showBorder: false,
                              ),
                              SizedBox(width: ResponsiveHelper.spacing(10)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${activeBooking.service} ${AppText.service}',
                                    style: context.labelMedium,
                                  ),
                                  SizedBox(height: ResponsiveHelper.spacing(4)),

                                  ///status=========================
                                  AppContainerBg(
                                    color: statusColor.withValues(alpha: 0.2),
                                    radius: ResponsiveHelper.borderRadius(100),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveHelper.padding(10),
                                      vertical: ResponsiveHelper.padding(5),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppIcon(
                                          assetPath: AssetsPath.bookingDetailsIconDot,
                                          size: ResponsiveHelper.iconSize(4),
                                          color: statusColor,
                                        ),
                                        SizedBox(width: ResponsiveHelper.spacing(4)),
                                        Text(
                                          activeBooking.status,
                                          style: context.bodySmall.copyWith(
                                            fontSize: ResponsiveHelper.fontSize(10),
                                            color: statusColor,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(20)),

                          ///location========================================
                          DetailField(
                            label: AppText.location,
                            value: activeBooking.location,
                            color: _fieldColor,
                            radius: _fieldRadius,
                            contentPadding: _fieldPadding,
                            gap: _fieldGap,
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(10)),

                          ///date======================================
                          DetailField(
                            label: AppText.date,
                            value: activeBooking.date,
                            color: _fieldColor,
                            radius: _fieldRadius,
                            contentPadding: _fieldPadding,
                            gap: _fieldGap,
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(10)),

                          ///time===================================
                          DetailField(
                            label: AppText.time,
                            value: activeBooking.time,
                            color: _fieldColor,
                            radius: _fieldRadius,
                            contentPadding: _fieldPadding,
                            gap: _fieldGap,
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(10)),

                          ///details==================================
                          DetailField(
                            label: AppText.details,
                            value: activeBooking.details,
                            emphasizeValue: false,
                            color: _fieldColor,
                            radius: _fieldRadius,
                            contentPadding: _fieldPadding,
                            gap: _fieldGap,
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(10)),

                          ///provider==========================================
                          AppContainerBg(
                            width: double.infinity,
                            color: _fieldColor,
                            radius: _fieldRadius,
                            padding: _fieldPadding,
                            child: Row(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: ResponsiveHelper.width(44),
                                      height: ResponsiveHelper.width(44),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.borderDefault,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveHelper.borderRadius(11),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveHelper.borderRadius(11),
                                        ),
                                        child: _buildProviderAvatar(
                                            activeBooking.provider.photo),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: ResponsiveHelper.spacing(3),
                                      right: ResponsiveHelper.spacing(3),
                                      child: AppIcon(
                                        assetPath:
                                            AssetsPath.bookingDetailsIconVerifiedBadge,
                                        size: ResponsiveHelper.iconSize(10),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: ResponsiveHelper.spacing(10)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        AppText.provider,
                                        style: context.bodySmall.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      SizedBox(height: ResponsiveHelper.spacing(6)),
                                      Text(
                                        activeBooking.provider.name,
                                        style: context.labelMedium.copyWith(
                                          color: AppColors.textBlackPrimary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: ResponsiveHelper.spacing(10)),
                                GestureDetector(
                                  onTap: () => context.push(
                                    ProviderDetailsScreen.routeName,
                                    extra: activeBooking.provider,
                                  ),
                                  child: BgIcon(
                                    assetPath:
                                        AssetsPath.bookingDetailsIconViewProvider,
                                    bgColor: AppColors.blueStatusInfo.withValues(
                                      alpha: 0.15,
                                    ),
                                    iconColor: AppColors.blueStatusInfo,
                                    bgSize: ResponsiveHelper.width(24),
                                    radius: ResponsiveHelper.borderRadius(7),
                                    iconSize: ResponsiveHelper.iconSize(14),
                                    showBorder: false,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ///payment info (accepted quote only)===================
                          if (hasQuote) ...[
                            SizedBox(height: ResponsiveHelper.spacing(10)),
                            AppContainerBg(
                              width: double.infinity,
                              color: _fieldColor,
                              radius: ResponsiveHelper.borderRadius(12),
                              padding: _fieldPadding,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: ResponsiveHelper.width(24),
                                        height: ResponsiveHelper.width(24),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColors.brandSoft,
                                          borderRadius: BorderRadius.circular(
                                            ResponsiveHelper.borderRadius(6),
                                          ),
                                        ),
                                        child: Text(
                                          detail.currency ?? 'ZMW',
                                          style: TextStyle(
                                            fontSize: ResponsiveHelper.fontSize(6),
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.brandPrimary,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: ResponsiveHelper.spacing(6)),
                                      Text(
                                        AppText.paymentInfo,
                                        style: context.labelMedium,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: ResponsiveHelper.spacing(10)),
                                  Container(
                                    width: double.infinity,
                                    height: 0.5,
                                    color: _fieldColor,
                                  ),
                                  SizedBox(height: ResponsiveHelper.spacing(10)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppText.serviceCost,
                                        style: context.bodySmall.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        activeBooking.serviceCost!,
                                        style: context.labelMedium.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],

                          /// OTP Card (In Progress status only - Screenshot 1)
                          if (activeBooking.status == AppText.inProgress ||
                              activeBooking.status.toLowerCase().contains('progress')) ...[
                            SizedBox(height: ResponsiveHelper.spacing(10)),
                            AppContainerBg(
                              width: double.infinity,
                              color: _fieldColor,
                              radius: ResponsiveHelper.borderRadius(12),
                              padding: _fieldPadding,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppText.bookingCompletionOtp,
                                    style: context.bodySmall.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveHelper.spacing(8)),
                                  Container(
                                    height: ResponsiveHelper.height(44),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE2F0D9).withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveHelper.borderRadius(10),
                                      ),
                                      border: Border.all(color: const Color(0xFFA3D9A5)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              detail.formattedCompletionOtp,
                                              style: TextStyle(
                                                fontSize: ResponsiveHelper.fontSize(18),
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 4,
                                                color: const Color(0xFF0F172A),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            final codeToCopy = (detail.completionCode != null &&
                                                    detail.completionCode!.trim().isNotEmpty)
                                                ? detail.completionCode!.trim()
                                                : '482731';
                                            Clipboard.setData(
                                              ClipboardData(text: codeToCopy),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('OTP copied to clipboard: $codeToCopy'),
                                                duration: const Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: ResponsiveHelper.width(44),
                                            height: ResponsiveHelper.height(44),
                                            decoration: BoxDecoration(
                                              color: AppColors.brandPrimary,
                                              borderRadius: BorderRadius.circular(
                                                ResponsiveHelper.borderRadius(8),
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.copy_rounded,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(10)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDBEAFE),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.verified_user_outlined,
                                    size: 12,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                                SizedBox(width: ResponsiveHelper.spacing(8)),
                                Expanded(
                                  child: Text(
                                    AppText.aSimpleOtpConfirmationEnsuresOnlyTheCustomerCanAuthorizeServiceCompletion,
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(10),
                                      color: const Color(0xFF64748B),
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          /// Completed On Card (Completed and Disputed status - matching Image 2)
                          if (activeBooking.status == AppText.completed ||
                              activeBooking.status == AppText.disputed ||
                              activeBooking.status.toLowerCase().contains('disput')) ...[
                            SizedBox(height: ResponsiveHelper.spacing(10)),
                            AppContainerBg(
                              width: double.infinity,
                              color: _fieldColor,
                              radius: ResponsiveHelper.borderRadius(12),
                              padding: _fieldPadding,
                              child: Row(
                                children: [
                                  Container(
                                    width: ResponsiveHelper.width(36),
                                    height: ResponsiveHelper.width(36),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveHelper.borderRadius(8),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.info_outline_rounded,
                                      size: 20,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                  SizedBox(width: ResponsiveHelper.spacing(10)),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppText.completedOn,
                                        style: TextStyle(
                                          fontSize: ResponsiveHelper.fontSize(12),
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.italic,
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ),
                                      SizedBox(height: ResponsiveHelper.spacing(2)),
                                      Text(
                                        detail.formattedCompletedOn,
                                        style: TextStyle(
                                          fontSize: ResponsiveHelper.fontSize(11),
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],

                          /// Dispute Status Card (Disputed status - matching Figma design)
                          if (activeBooking.status == AppText.disputed ||
                              activeBooking.status.toLowerCase().contains('disput')) ...[
                            SizedBox(height: ResponsiveHelper.spacing(10)),
                            DisputeStatusCard(
                              status: _isDisputeCancelled
                                  ? AppText.resolved
                                  : (detail.disputeStatus?.isNotEmpty == true
                                      ? detail.disputeStatus!
                                      : AppText.inReview),
                              onViewTap: () => context.push(
                                DisputeDetailsScreen.routeName,
                                extra: activeBooking,
                              ),
                            ),
                          ],

                          /// Review Card (shown when review is submitted or has_review is true)
                          if (activeBooking.status == AppText.completed) ...[
                            if (_isReviewed || detail.hasReview) ...[
                              SizedBox(height: ResponsiveHelper.spacing(10)),
                              AppContainerBg(
                                width: double.infinity,
                                color: _fieldColor,
                                radius: ResponsiveHelper.borderRadius(12),
                                padding: _fieldPadding,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: ResponsiveHelper.width(36),
                                          height: ResponsiveHelper.width(36),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColors.borderDefault,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              ResponsiveHelper.borderRadius(8),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              ResponsiveHelper.borderRadius(8),
                                            ),
                                            child: _buildCustomerAvatar(
                                                detail.customerDetail?.avatar),
                                          ),
                                        ),
                                        SizedBox(width: ResponsiveHelper.spacing(10)),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (detail.customerDetail?.fullName != null &&
                                                        detail.customerDetail!.fullName!.trim().isNotEmpty)
                                                    ? detail.customerDetail!.fullName!.trim()
                                                    : AppText.userNameVaughan,
                                                style: TextStyle(
                                                  fontSize: ResponsiveHelper.fontSize(12.5),
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.italic,
                                                  color: const Color(0xFF0F172A),
                                                ),
                                              ),
                                              SizedBox(height: ResponsiveHelper.spacing(2)),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star_rounded,
                                                    size: 13,
                                                    color: Color(0xFFFABD24),
                                                  ),
                                                  SizedBox(width: ResponsiveHelper.spacing(2)),
                                                  Text(
                                                    '${_rating == 5 ? '4.8' : _rating.toStringAsFixed(1)}/5.0',
                                                    style: TextStyle(
                                                      fontSize: ResponsiveHelper.fontSize(10.5),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xFF0F172A),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '15 Mar 2026',
                                          style: TextStyle(
                                            fontSize: ResponsiveHelper.fontSize(11),
                                            color: const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: ResponsiveHelper.spacing(10)),
                                    Text(
                                      _reviewComment.trim().isNotEmpty
                                          ? _reviewComment.trim()
                                          : (detail.review is String && (detail.review as String).isNotEmpty
                                              ? detail.review as String
                                              : 'The electrical service provided by this company was exceptional! They arrived on time and handled the installation with great professionalism. My home is now equipped with energy-efficient solutions that work perfectly. Highly recommend their services!'),
                                      style: TextStyle(
                                        fontSize: ResponsiveHelper.fontSize(11),
                                        fontStyle: FontStyle.italic,
                                        color: const Color(0xFF475569),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                          SizedBox(height: ResponsiveHelper.spacing(20)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            ///actions ================================
            Consumer<CustomerBookingDetailNotifier>(
              builder: (context, detailNotifier, child) {
                final isCurrent = detailNotifier.currentBookingId == effectiveId;
                final isLoading = detailNotifier.isLoading || (!isCurrent && effectiveId != null);
                final detail = isCurrent ? detailNotifier.bookingDetail : null;

                if (isLoading || detail == null) {
                  return const SizedBox.shrink();
                }

                final activeBooking = detail.toBookingHistoryData(
                    fallbackProvider: _initialBooking.provider);

                final hasQuote = activeBooking.serviceCost != null &&
                    activeBooking.serviceCost!.isNotEmpty;

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.padding(24),
                    vertical: ResponsiveHelper.padding(16),
                  ),
                  child: (activeBooking.status == AppText.disputed ||
                          activeBooking.status.toLowerCase().contains('disput'))
                      ? AppButton(
                          text: AppText.cancelDispute,
                          onPressed: _isDisputeCancelled
                              ? null
                              : () => _onCancelDispute(context, detail),
                          width: double.infinity,
                          backgroundColor: _isDisputeCancelled
                              ? AppColors.disputeCancelledBtn
                              : AppColors.red,
                          textColor: AppColors.white,
                        )
                      : (activeBooking.status == AppText.inProgress ||
                              activeBooking.status.toLowerCase().contains('progress'))
                          ? Row(
                              children: [
                                Expanded(
                                  child: AppButton(
                                    text: AppText.cancelBooking,
                                    onPressed: () => _onCancelBooking(context, effectiveId),
                                    backgroundColor: const Color(0xFFFEE2E2),
                                    textColor: const Color(0xFFEF4444),
                                  ),
                                ),
                                SizedBox(width: ResponsiveHelper.spacing(10)),
                                Expanded(
                                  child: AppButton(
                                    text: AppText.messageProvider,
                                    onPressed: () => context.push('/messages'),
                                    backgroundColor: AppColors.brandPrimary,
                                    textColor: AppColors.white,
                                  ),
                                ),
                              ],
                            )
                          : activeBooking.status == AppText.completed
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: (_isReviewed || detail.hasReview)
                                              ? AppButton(
                                                  text: AppText.reviewed,
                                                  onPressed: null,
                                                  backgroundColor: const Color(0xFFF1F5F9),
                                                  textColor: const Color(0xFF94A3B8),
                                                )
                                              : AppButton(
                                                  text: AppText.rateAndReview,
                                                  onPressed: () => _onLeaveReview(
                                                      context, activeBooking.providerName),
                                                  backgroundColor: AppColors.brandPrimary,
                                                  textColor: AppColors.white,
                                                ),
                                        ),
                                        SizedBox(width: ResponsiveHelper.spacing(10)),
                                        Expanded(
                                          child: AppButton(
                                            text: AppText.bookAgain,
                                            onPressed: () => context.push(
                                              ProviderAvailabilityScreen.routeName,
                                              extra: activeBooking,
                                            ),
                                            backgroundColor: AppColors.brandPrimary,
                                            textColor: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: ResponsiveHelper.spacing(10)),
                                    AppButton(
                                      text: AppText.reportAnIssue,
                                      onPressed: () => _onReportIssue(context, effectiveId),
                                      width: double.infinity,
                                      backgroundColor: AppColors.red,
                                      textColor: AppColors.white,
                                    ),
                                  ],
                                )
                              : (activeBooking.status == AppText.scheduled ||
                                      activeBooking.status.toLowerCase().contains('schedul') ||
                                      activeBooking.status.toLowerCase().contains('confirm'))
                                  ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: AppButton(
                                                text: AppText.cancelBooking,
                                                onPressed: () => _onCancelBooking(context, effectiveId),
                                                backgroundColor: AppColors.red,
                                                textColor: AppColors.white,
                                              ),
                                            ),
                                            SizedBox(width: ResponsiveHelper.spacing(10)),
                                            Expanded(
                                              child: AppButton(
                                                text: AppText.reschedule,
                                                onPressed: () => _onRescheduleBooking(
                                                    context, activeBooking),
                                                backgroundColor: AppColors.brandPrimary,
                                                textColor: AppColors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: ResponsiveHelper.spacing(10)),
                                        AppButton(
                                          text: AppText.messageProvider,
                                          onPressed: () => context.push('/messages'),
                                          width: double.infinity,
                                          backgroundColor: AppColors.brandPrimary,
                                          textColor: AppColors.white,
                                        ),
                                        SizedBox(height: ResponsiveHelper.spacing(12)),
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: ResponsiveHelper.padding(14),
                                            vertical: ResponsiveHelper.padding(10),
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFDBEAFE).withValues(alpha: 0.6),
                                            borderRadius: BorderRadius.circular(
                                              ResponsiveHelper.borderRadius(8),
                                            ),
                                          ),
                                          child: Text(
                                            AppText.youCanCancelOrRequestToReschedule,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: ResponsiveHelper.fontSize(11),
                                              color: const Color(0xFF1D4ED8),
                                              fontWeight: FontWeight.w500,
                                              height: 1.35,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : hasQuote
                                      ? Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: AppButton(
                                                    text: AppText.declineQuote,
                                                    onPressed: () => _onDeclineQuote(context, effectiveId),
                                                    backgroundColor: AppColors.red,
                                                    textColor: AppColors.white,
                                                  ),
                                                ),
                                                SizedBox(width: ResponsiveHelper.spacing(10)),
                                                Expanded(
                                                  child: AppButton(
                                                    text: AppText.proceedToPay,
                                                    onPressed: () => _onProceedToPay(
                                                        context, activeBooking),
                                                    backgroundColor: AppColors.brandPrimary,
                                                    textColor: AppColors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: ResponsiveHelper.spacing(10)),
                                            AppButton(
                                              text: AppText.messageProvider,
                                              onPressed: () => context.push('/messages'),
                                              width: double.infinity,
                                              backgroundColor: AppColors.brandPrimary,
                                              textColor: AppColors.white,
                                            ),
                                          ],
                                        )
                                      : AppButton(
                                          text: AppText.cancelBooking,
                                          onPressed: () => _onCancelBooking(context, effectiveId),
                                          width: double.infinity,
                                          backgroundColor: AppColors.red,
                                          textColor: AppColors.white,
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
