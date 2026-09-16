import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/customer_details/customer_details_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/accept_quote_confirm_bottom_sheet.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/confirm_service_completion_bottom_sheet.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/mark_completed_confirm_bottom_sheet.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/provider_booking_sample_data.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/provider_reschedule_booking_bottom_sheet.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/reject_booking_bottom_sheet.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/send_quote_bottom_sheet.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/dispute_details/provider_dispute_details_screen.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/cancel_booking_bottom_sheet.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/dispute_status_card.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/dispute_response_bottom_sheet.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/provider_availability/provider_availability_screen.dart';
import 'package:nchito/features/common/common_widgets/app_detail_field/app_detail_field.dart';
import 'package:nchito/features/provider/messages/presentation/screens/provider_chat_screen.dart';
import 'package:nchito/features/user/messages/presentation/widgets/message_sample_data.dart';

class ProviderBookingDetailsScreen extends StatefulWidget {
  static const String routeName = '/provider/booking-details';

  final dynamic booking;

  const ProviderBookingDetailsScreen({super.key, required this.booking});

  @override
  State<ProviderBookingDetailsScreen> createState() =>
      _ProviderBookingDetailsScreenState();
}

class _ProviderBookingDetailsScreenState
    extends State<ProviderBookingDetailsScreen> {
  late ProviderBookingData _bookingData;
  late String _currentStatus;
  late String _currentPrice;
  bool _isCanceledByProvider = false;
  bool _hasReview = false;
  bool _isResponseSubmitted = false;

  @override
  void initState() {
    super.initState();
    if (widget.booking is ProviderBookingData) {
      _bookingData = widget.booking as ProviderBookingData;
    } else if (widget.booking is BookingHistoryData) {
      final b = widget.booking as BookingHistoryData;
      final is25Aug = (b.day == '25' && b.month.toLowerCase().startsWith('aug'));
      final is23Feb = (b.day == '23' && b.month.toLowerCase().startsWith('feb'));
      final isDisputed = b.status == AppText.disputed ||
          b.status.toLowerCase().contains('disput');
      final mappedStatus = isDisputed
          ? AppText.disputed
          : (is25Aug
              ? AppText.pending
              : (is23Feb || b.status == AppText.accepted
                  ? AppText.inProgress
                  : b.status));

      _bookingData = ProviderBookingData(
        customerName: is23Feb ? 'Vaughan Gething' : b.providerName,
        service: b.service,
        price: b.serviceCost ?? b.price,
        iconAsset: b.iconAsset,
        iconBgColor: b.iconBgColor,
        day: b.day,
        month: b.month,
        time: b.time,
        status: mappedStatus,
        location: b.location,
        fullDate: b.date,
        fullTime: b.time,
        details: b.details,
        customerPhoto: AssetsPath.avatarUser,
        customerEmailOrPhone: 'customer@nchito.com',
      );
    } else {
      _bookingData = providerNewBookingRequests.first;
    }

    _currentStatus = _bookingData.status == AppText.pending
        ? AppText.pending
        : (_bookingData.status == AppText.accepted
            ? AppText.inProgress
            : _bookingData.status);
    _currentPrice = _bookingData.price;
    if (_currentStatus == AppText.cancelled) {
      _isCanceledByProvider = false;
    }
  }

  ProviderBookingData get booking => _bookingData;

  static final _fieldColor = AppColors.bgOverlay.withValues(alpha: 0.04);
  static final _fieldRadius = ResponsiveHelper.borderRadius(10);
  static final _fieldPadding = EdgeInsets.all(ResponsiveHelper.padding(14));
  static final _fieldGap = ResponsiveHelper.spacing(8);

  Color get _statusColor {
    switch (_currentStatus) {
      case 'Confirmed':
      case AppText.accepted:
        return AppColors.emerald400;
      case AppText.scheduled:
        return AppColors.cyan400;
      case AppText.inProgress:
        return const Color(0xFF8B5CF6);
      case AppText.completed:
        return AppColors.emerald400;
      case AppText.disputed:
        return AppColors.amber500;
      case AppText.rejected:
      case AppText.cancelled:
        return AppColors.red400;
      default:
        return AppColors.amber500;
    }
  }

  String get _serviceCostDisplay {
    final raw = _currentPrice.replaceAll(RegExp(r'[^0-9.]'), '');
    final val = double.tryParse(raw) ?? 500.00;
    return 'ZMW ${val.toStringAsFixed(2)}';
  }

  String get _platformFeeDisplay {
    final raw = _currentPrice.replaceAll(RegExp(r'[^0-9.]'), '');
    final val = double.tryParse(raw) ?? 500.00;
    final fee = val * 0.05;
    return 'ZMW ${fee.toStringAsFixed(2)}';
  }

  String get _totalCostDisplay {
    final raw = _currentPrice.replaceAll(RegExp(r'[^0-9.]'), '');
    final val = double.tryParse(raw) ?? 500.00;
    final total = val * 1.05;
    return 'ZMW ${total.toStringAsFixed(2)}';
  }

  void _onReject(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (_) => RejectBookingBottomSheet(
        onConfirm: () {
          setState(() {
            _currentStatus = AppText.rejected;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking request rejected'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _onAccept(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (_) => SendQuoteBottomSheet(
        onSendQuote: (price) {
          _showAcceptConfirm(context, price);
        },
      ),
    );
  }

  void _showAcceptConfirm(BuildContext context, String price) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (_) => AcceptQuoteConfirmBottomSheet(
        onConfirm: () {
          setState(() {
            _currentStatus = AppText.inProgress;
            _currentPrice = price.startsWith('ZMW') ? price : 'ZMW $price';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pricing quote sent: $_currentPrice'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _onMarkAsCompleted(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (_) => ConfirmServiceCompletionBottomSheet(
        onVerifyOtp: () {
          _showMarkCompletedConfirm(context);
        },
      ),
    );
  }

  void _showMarkCompletedConfirm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (_) => MarkCompletedConfirmBottomSheet(
        onConfirm: () {
          if (!mounted) return;
          setState(() {
            _currentStatus = AppText.completed;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Service marked as completed!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _onMessageCustomer(BuildContext context) {
    context.push(
      ProviderChatScreen.routeName,
      extra: MessageData(
        name: booking.customerName,
        avatarAsset: booking.customerPhoto,
        lastMessage: 'Hi, regarding your booking for ${booking.service}.',
        timeLabel: 'Now',
      ),
    );
  }

  void _openDisputeResponseBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (_) => DisputeResponseBottomSheet(
        onSubmit: (response, evidenceImages) {
          setState(() {
            _isResponseSubmitted = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppText.responseSubmittedSuccessfully),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _onCancelBooking(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (_) => CancelBookingBottomSheet(
        onConfirm: () {
          setState(() {
            _currentStatus = AppText.cancelled;
            _isCanceledByProvider = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking canceled successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _onRescheduleBooking(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => ProviderRescheduleBookingBottomSheet(
        onConfirm: () {
          context.push(
            ProviderAvailabilityScreen.routeName,
            extra: _bookingData,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.bookingDetails),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service & status badge
                    Row(
                      children: [
                        BgIcon(
                          assetPath: booking.iconAsset,
                          bgColor: booking.iconBgColor,
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
                              '${booking.service} ${AppText.service}',
                              style: context.labelMedium,
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(4)),
                            AppContainerBg(
                              color: _statusColor.withValues(alpha: 0.15),
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
                                    color: _statusColor,
                                  ),
                                  SizedBox(width: ResponsiveHelper.spacing(4)),
                                  Text(
                                    _currentStatus,
                                    style: context.bodySmall.copyWith(
                                      fontSize: ResponsiveHelper.fontSize(10),
                                      color: _statusColor,
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

                    // Location
                    DetailField(
                      label: AppText.location,
                      value: booking.location,
                      color: _fieldColor,
                      radius: _fieldRadius,
                      contentPadding: _fieldPadding,
                      gap: _fieldGap,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // Date
                    DetailField(
                      label: AppText.date,
                      value: booking.fullDate,
                      color: _fieldColor,
                      radius: _fieldRadius,
                      contentPadding: _fieldPadding,
                      gap: _fieldGap,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // Time
                    DetailField(
                      label: AppText.time,
                      value: booking.fullTime,
                      color: _fieldColor,
                      radius: _fieldRadius,
                      contentPadding: _fieldPadding,
                      gap: _fieldGap,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // Details
                    DetailField(
                      label: AppText.details,
                      value: booking.details,
                      emphasizeValue: false,
                      color: _fieldColor,
                      radius: _fieldRadius,
                      contentPadding: _fieldPadding,
                      gap: _fieldGap,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // Requested By
                    AppContainerBg(
                      width: double.infinity,
                      color: _fieldColor,
                      radius: _fieldRadius,
                      padding: _fieldPadding,
                      child: Row(
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
                              child: AppIcon(
                                assetPath: booking.customerPhoto,
                                size: ResponsiveHelper.width(44),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(10)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppText.requestedBy,
                                  style: context.bodySmall.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: ResponsiveHelper.spacing(6)),
                                Text(
                                  booking.customerName,
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
                              CustomerDetailsScreen.routeName,
                              extra: booking,
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
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // Payment Info Card (Image 2)
                    if (_currentStatus == AppText.inProgress ||
                        _currentStatus == AppText.completed ||
                        _currentStatus == AppText.disputed) ...[
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
                                    'ZMW',
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
                              color: AppColors.borderDefault,
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
                                  _serviceCostDisplay,
                                  style: context.labelMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(8)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Platform Fee ',
                                      style: context.bodySmall.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      '(5%)',
                                      style: context.bodySmall.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFF59E0B),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  _platformFeeDisplay,
                                  style: context.labelMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(8)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppText.totalCost,
                                  style: context.bodySmall.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textBlackPrimary,
                                  ),
                                ),
                                Text(
                                  _totalCostDisplay,
                                  style: context.labelMedium.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(10)),

                      // Blue OTP info note (Image 2)
                      if (_currentStatus == AppText.inProgress) ...[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.padding(12),
                            vertical: ResponsiveHelper.padding(10),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(10),
                            ),
                          ),
                          child: Row(
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
                                  size: 14,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                              SizedBox(width: ResponsiveHelper.spacing(8)),
                              Expanded(
                                child: Text(
                                  AppText
                                      .theProviderCanOnlyCompleteTheBookingAfterEnteringTheCustomerProvidedOtp,
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(10.5),
                                    fontStyle: FontStyle.italic,
                                    color: const Color(0xFF475569),
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(10)),
                      ],
                    ],
                    // Completed On Card & Review Section (Image 1 & Image 2)
                    if (_currentStatus == AppText.completed ||
                        _currentStatus == AppText.disputed) ...[
                      AppContainerBg(
                        width: double.infinity,
                        color: _fieldColor,
                        radius: _fieldRadius,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.padding(14),
                          vertical: ResponsiveHelper.padding(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: ResponsiveHelper.width(36),
                              height: ResponsiveHelper.width(36),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.borderRadius(10),
                                ),
                              ),
                              child: AppIcon(
                                assetPath:
                                    AssetsPath.bookingsBookingDetailsIconCancelBooking,
                                color: const Color(0xFF10B981),
                                size: ResponsiveHelper.iconSize(20),
                              ),
                            ),
                            SizedBox(width: ResponsiveHelper.spacing(12)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppText.bookingCompletedOn,
                                    style: context.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.textBlackPrimary,
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveHelper.spacing(4)),
                                  Text(
                                    '27 Aug 2026 - 06:20 AM',
                                    style: context.bodySmall.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(10)),
                    ],

                    // Dispute Status Card (Disputed status - matching Image 1)
                    if (_currentStatus == AppText.disputed) ...[
                      DisputeStatusCard(
                        status: _isResponseSubmitted
                            ? AppText.inReview
                            : AppText.disputed,
                        statusLabel: _isResponseSubmitted
                            ? AppText.inReview
                            : AppText.responseRequired,
                        onViewTap: () => context.push(
                          ProviderDisputeDetailsScreen.routeName,
                          extra: widget.booking,
                        ),
                        onTap: () => _openDisputeResponseBottomSheet(context),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(10)),
                    ],

                    // Review Section (Completed only)
                    if (_currentStatus == AppText.completed) ...[
                      if (!_hasReview)
                        GestureDetector(
                          onTap: () => setState(() => _hasReview = true),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.padding(12),
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(100),
                              ),
                              border: Border.all(
                                color: const Color(0xFFCBD5E1),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              AppText.noReviewYet,
                              style: context.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: () => setState(() => _hasReview = false),
                          child: AppContainerBg(
                            width: double.infinity,
                            color: _fieldColor,
                            radius: _fieldRadius,
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
                                        child: AppIcon(
                                          assetPath: booking.customerPhoto,
                                          size: ResponsiveHelper.width(36),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: ResponsiveHelper.spacing(10)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            booking.customerName,
                                            style: TextStyle(
                                              fontSize:
                                                  ResponsiveHelper.fontSize(12.5),
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.italic,
                                              color: const Color(0xFF0F172A),
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  ResponsiveHelper.spacing(2)),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star_rounded,
                                                size: 13,
                                                color: Color(0xFFFABD24),
                                              ),
                                              SizedBox(
                                                  width:
                                                      ResponsiveHelper.spacing(
                                                          2)),
                                              Text(
                                                '4.8/5.0',
                                                style: TextStyle(
                                                  fontSize:
                                                      ResponsiveHelper.fontSize(
                                                          10.5),
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
                                  'The electrical service provided by this company was exceptional! They arrived on time and handled the installation with great professionalism. My home is now equipped with energy-efficient solutions that work perfectly. Highly recommend their services!',
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
                        ),
                      SizedBox(height: ResponsiveHelper.spacing(10)),
                    ],
                    // Cancellation Card (Screenshots: You Canceled / Customer Canceled)
                    if (_currentStatus == AppText.cancelled) ...[
                      AppContainerBg(
                        width: double.infinity,
                        color: _fieldColor,
                        radius: _fieldRadius,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.padding(14),
                          vertical: ResponsiveHelper.padding(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: ResponsiveHelper.width(36),
                              height: ResponsiveHelper.width(36),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.borderRadius(10),
                                ),
                              ),
                              child: AppIcon(
                                assetPath:
                                    AssetsPath.bookingsBookingDetailsIconCancelBooking,
                                size: ResponsiveHelper.iconSize(20),
                              ),
                            ),
                            SizedBox(width: ResponsiveHelper.spacing(12)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _isCanceledByProvider
                                        ? AppText.youCanceledThisBooking
                                        : AppText.customerCanceledThisBooking,
                                    style: context.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.textBlackPrimary,
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveHelper.spacing(4)),
                                  Text(
                                    AppText.on27Aug2026,
                                    style: context.bodySmall.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(10)),
                    ],
                    SizedBox(height: ResponsiveHelper.spacing(20)),
                  ],
                ),
              ),
            ),

            // Bottom Actions (Hidden when Cancelled or Completed)
            if (_currentStatus != AppText.cancelled &&
                _currentStatus != AppText.completed)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                  vertical: ResponsiveHelper.padding(16),
                ),
                child: _currentStatus == AppText.disputed
                    ? AppButton(
                        text: _isResponseSubmitted
                            ? AppText.inReview
                            : AppText.submitResponse,
                        onPressed: _isResponseSubmitted
                            ? null
                            : () => _openDisputeResponseBottomSheet(context),
                        width: double.infinity,
                        backgroundColor: _isResponseSubmitted
                            ? AppColors.textDisabled.withValues(alpha: 0.3)
                            : AppColors.brandPrimary,
                        textColor: _isResponseSubmitted
                            ? AppColors.textDisabled
                            : AppColors.white,
                      )
                    : _currentStatus == AppText.inProgress
                    ? Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: AppText.messageCustomer,
                              onPressed: () => _onMessageCustomer(context),
                              backgroundColor: AppColors.brandPrimary,
                              textColor: AppColors.white,
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(12)),
                          Expanded(
                            child: AppButton(
                              text: AppText.markAsCompleted,
                              onPressed: () => _onMarkAsCompleted(context),
                              backgroundColor: AppColors.brandPrimary,
                              textColor: AppColors.white,
                            ),
                          ),
                        ],
                      )
                    : _currentStatus == AppText.pending
                        ? Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  text: AppText.reject,
                                  onPressed: () => _onReject(context),
                                  backgroundColor: AppColors.red,
                                  textColor: AppColors.white,
                                ),
                              ),
                              SizedBox(width: ResponsiveHelper.spacing(10)),
                              Expanded(
                                child: AppButton(
                                  text: AppText.accept,
                                  onPressed: () => _onAccept(context),
                                  backgroundColor: AppColors.brandPrimary,
                                  textColor: AppColors.white,
                                ),
                              ),
                            ],
                          )
                        : _currentStatus == AppText.scheduled
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppButton(
                                          text: AppText.cancelBooking,
                                          onPressed: () =>
                                              _onCancelBooking(context),
                                          backgroundColor: AppColors.red,
                                          textColor: AppColors.white,
                                        ),
                                      ),
                                      SizedBox(
                                          width: ResponsiveHelper.spacing(10)),
                                      Expanded(
                                        child: AppButton(
                                          text: AppText.reschedule,
                                          onPressed: () =>
                                              _onRescheduleBooking(context),
                                          backgroundColor:
                                              AppColors.brandPrimary,
                                          textColor: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: ResponsiveHelper.spacing(10)),
                                  AppButton(
                                    text: AppText.messageCustomer,
                                    onPressed: () =>
                                        _onMessageCustomer(context),
                                    width: double.infinity,
                                    backgroundColor: AppColors.brandPrimary,
                                    textColor: AppColors.white,
                                  ),
                                ],
                              )
                            : AppButton(
                                text: AppText.messageCustomer,
                                onPressed: () => _onMessageCustomer(context),
                                width: double.infinity,
                                backgroundColor: AppColors.brandPrimary,
                                textColor: AppColors.white,
                              ),
              ),
          ],
        ),
      ),
    );
  }
}
