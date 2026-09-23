import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_snackbar/app_snackbar.dart';
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
import 'package:nchito/features/provider/bookings/data/models/provider_booking_detail_model.dart';
import 'package:nchito/features/provider/bookings/presentation/providers/provider_booking_detail_notifier.dart';
import 'package:nchito/features/provider/bookings/presentation/providers/provider_dispute_notifier.dart';
import 'package:nchito/features/common/chat/presentation/providers/conversations_notifier.dart';
import 'package:nchito/features/common/common_widgets/app_reschedule_booking_bottom_sheet/app_reschedule_booking_bottom_sheet.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/reject_booking_bottom_sheet.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/send_quote_bottom_sheet.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/dispute_details/provider_dispute_details_screen.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/cancel_booking_bottom_sheet.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/dispute_status_card.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/dispute_response_bottom_sheet.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/provider_availability/provider_manage_availability_screen.dart';
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
  bool _isResponseSubmitted = false;
  BookingEmbeddedReviewModel? _review;
  String? _bookingId;

  /// Raw API status (e.g. `pending`, `accepted`, `in_progress`) → the
  /// display status this screen already branches its UI on.
  String _mapApiStatus(String rawStatus) {
    switch (rawStatus.toLowerCase()) {
      case 'pending':
        return AppText.pending;
      case 'accepted':
        // Matches this screen's existing accept flow, which moves a
        // booking straight to "In Progress" once a price is sent.
        return AppText.inProgress;
      case 'scheduled':
      case 'confirmed':
        return AppText.scheduled;
      case 'in_progress':
      case 'started':
        return AppText.inProgress;
      case 'completed':
        return AppText.completed;
      case 'cancelled':
      case 'canceled':
        return AppText.cancelled;
      case 'rejected':
        return AppText.rejected;
      case 'disputed':
        return AppText.disputed;
      case 'quoted':
        // Price sent, awaiting the customer's accept/decline — confirmed
        // against live data as a real intermediate status between
        // "pending" and "accepted". No dedicated UI bucket in this
        // screen's design, so it's shown like "scheduled" (booking is
        // locked in, nothing left for the provider to action but
        // cancel/message while the customer decides).
        return AppText.scheduled;
      default:
        return rawStatus.isEmpty
            ? AppText.pending
            : '${rawStatus[0].toUpperCase()}${rawStatus.substring(1)}';
    }
  }

  /// Re-syncs the locally-held display fields from the notifier once a
  /// real booking detail arrives (initial load or after an action).
  void _onDetailChanged() {
    if (!mounted) return;
    final notifier = context.read<ProviderBookingDetailNotifier>();
    final detail = notifier.bookingDetail;
    if (detail != null && notifier.currentBookingId == _bookingId) {
      setState(() {
        _bookingData = detail.toProviderBookingData();
        _currentStatus = _mapApiStatus(detail.status);
        _currentPrice = _bookingData.price;
        _isCanceledByProvider = detail.cancelledBy?.toLowerCase() == 'provider';
        _review = detail.review;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.booking is ProviderBookingData) {
      _bookingData = widget.booking as ProviderBookingData;
      _bookingId = _bookingData.id;
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
      _bookingId = b.id;
    } else {
      _bookingData = providerNewBookingRequests.first;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = context.read<ProviderBookingDetailNotifier>();
      notifier.clear();
      notifier.addListener(_onDetailChanged);
      if (_bookingId != null && _bookingId!.isNotEmpty) {
        notifier.fetchBookingDetail(_bookingId!);
      }
    });

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

  @override
  void dispose() {
    context.read<ProviderBookingDetailNotifier>().removeListener(_onDetailChanged);
    super.dispose();
  }

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
    final raw = _currentPrice.replaceAll(RegExp(r'[a-zA-Z\s]'), '').trim();
    final val = double.tryParse(raw) ?? 0.00;
    return 'ZMW ${val.toStringAsFixed(2)}';
  }

  String get _platformFeeDisplay {
    final raw = _currentPrice.replaceAll(RegExp(r'[a-zA-Z\s]'), '').trim();
    final val = double.tryParse(raw) ?? 0.00;
    return 'ZMW ${(val * 0.05).toStringAsFixed(2)}';
  }

  String get _totalCostDisplay {
    final raw = _currentPrice.replaceAll(RegExp(r'[a-zA-Z\s]'), '').trim();
    final val = double.tryParse(raw) ?? 0.00;
    return 'ZMW ${(val * 1.05).toStringAsFixed(2)}';
  }

  void _onReject(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (_) => RejectBookingBottomSheet(
        onConfirm: () async {
          setState(() {
            _currentStatus = AppText.rejected;
          });
          if (_bookingId == null || _bookingId!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking request rejected'),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }
          final notifier = context.read<ProviderBookingDetailNotifier>();
          final ok = await notifier.rejectBooking(_bookingId!);
          if (!context.mounted) return;
          if (ok) {
            AppSnackbar.showSuccess(context, 'Booking request rejected');
          } else {
            AppSnackbar.showError(
              context,
              notifier.actionErrorMessage ?? 'Failed to reject booking',
            );
          }
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
        onConfirm: () async {
          setState(() {
            _currentStatus = AppText.inProgress;
            _currentPrice = price.startsWith('ZMW') ? price : 'ZMW $price';
          });
          if (_bookingId == null || _bookingId!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Pricing quote sent: $_currentPrice'),
                duration: const Duration(seconds: 2),
              ),
            );
            return;
          }
          // Strip the "ZMW" prefix / commas back out for the API — it
          // wants a plain numeric amount string.
          final amount = price.replaceAll(RegExp(r'[^0-9.]'), '');
          final notifier = context.read<ProviderBookingDetailNotifier>();
          final ok = await notifier.acceptBooking(_bookingId!, amount: amount);
          if (!context.mounted) return;
          if (ok) {
            AppSnackbar.showSuccess(context, 'Pricing quote sent: $_currentPrice');
          } else {
            AppSnackbar.showError(
              context,
              notifier.actionErrorMessage ?? 'Failed to send quote',
            );
          }
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
        onVerifyOtp: (code) {
          _showMarkCompletedConfirm(context, code);
        },
      ),
    );
  }

  void _showMarkCompletedConfirm(BuildContext context, String otpCode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (_) => MarkCompletedConfirmBottomSheet(
        onConfirm: () async {
          if (!mounted) return;
          setState(() {
            _currentStatus = AppText.completed;
          });
          if (_bookingId == null || _bookingId!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Service marked as completed!'),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }
          final notifier = context.read<ProviderBookingDetailNotifier>();
          final ok = await notifier.verifyCompletion(_bookingId!, code: otpCode);
          if (!context.mounted) return;
          if (ok) {
            AppSnackbar.showSuccess(context, 'Service marked as completed!');
          } else {
            AppSnackbar.showError(
              context,
              notifier.actionErrorMessage ?? 'Failed to verify completion',
            );
          }
        },
      ),
    );
  }

  Future<void> _onMessageCustomer(BuildContext context) async {
    final detail = context.read<ProviderBookingDetailNotifier>().bookingDetail;
    final customerId = detail?.customerDetail?.id ?? detail?.counterparty?.id;

    if (customerId == null || customerId.isEmpty) {
      // No real customer id available yet (detail hasn't loaded) — fall
      // back to the old placeholder-thread behaviour rather than blocking
      // the button.
      context.push(
        ProviderChatScreen.routeName,
        extra: MessageData(
          name: booking.customerName,
          avatarAsset: booking.customerPhoto,
          lastMessage: 'Hi, regarding your booking for ${booking.service}.',
          timeLabel: 'Now',
        ),
      );
      return;
    }

    final conversationsNotifier = context.read<ProviderConversationsNotifier>();
    final conversation = await conversationsNotifier.startConversation(
      participantId: customerId,
      bookingId: _bookingId,
    );
    if (!context.mounted) return;
    if (conversation != null) {
      context.push(ProviderChatScreen.routeName, extra: conversation.toMessageData());
    } else {
      AppSnackbar.showError(
        context,
        conversationsNotifier.errorMessage ?? 'Failed to start conversation',
      );
    }
  }

  void _openDisputeResponseBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (_) => DisputeResponseBottomSheet(
        onSubmit: (response, evidenceImages) async {
          setState(() {
            _isResponseSubmitted = true;
          });
          // The booking's `dispute` field carries the dispute id once one
          // has been raised against it; there's no other way to reach it
          // from this screen today.
          final disputeId = context
              .read<ProviderBookingDetailNotifier>()
              .bookingDetail
              ?.dispute
              ?.toString();
          if (disputeId == null || disputeId.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppText.responseSubmittedSuccessfully),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }
          final notifier = context.read<ProviderDisputeNotifier>();
          final ok = await notifier.respondDispute(
            disputeId,
            message: response,
            evidenceFiles: evidenceImages,
          );
          if (!context.mounted) return;
          if (ok) {
            AppSnackbar.showSuccess(
              context,
              AppText.responseSubmittedSuccessfully,
            );
          } else {
            AppSnackbar.showError(
              context,
              notifier.actionErrorMessage ?? 'Failed to submit response',
            );
          }
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
        onConfirm: () async {
          setState(() {
            _currentStatus = AppText.cancelled;
            _isCanceledByProvider = true;
          });
          if (_bookingId == null || _bookingId!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking canceled successfully'),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }
          final notifier = context.read<ProviderBookingDetailNotifier>();
          final ok = await notifier.cancelBooking(_bookingId!);
          if (!context.mounted) return;
          if (ok) {
            AppSnackbar.showSuccess(context, 'Booking canceled successfully');
          } else {
            AppSnackbar.showError(
              context,
              notifier.actionErrorMessage ?? 'Failed to cancel booking',
            );
          }
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
      builder: (_) => AppRescheduleBookingBottomSheet(
        description: AppText.youReAboutToProposeANewDateAndTimeForThisBooking,
        onConfirm: () {
          context.push(
            ProviderManageAvailabilityScreen.routeName,
            extra: _bookingData,
          );
        },
      ),
    );
  }

  Future<void> _onStartService(BuildContext context) async {
    if (_bookingId == null || _bookingId!.isEmpty) {
      setState(() {
        _currentStatus = AppText.inProgress;
      });
      AppSnackbar.showSuccess(context, AppText.bookingStartedSuccessfully);
      return;
    }
    final notifier = context.read<ProviderBookingDetailNotifier>();
    final ok = await notifier.startBooking(_bookingId!);
    if (!context.mounted) return;
    if (ok) {
      setState(() {
        _currentStatus = AppText.inProgress;
      });
      AppSnackbar.showSuccess(context, AppText.bookingStartedSuccessfully);
    } else {
      AppSnackbar.showError(
        context,
        notifier.actionErrorMessage ?? 'Failed to start booking',
      );
    }
  }

  Future<void> _onResendOtpCode(BuildContext context) async {
    if (_bookingId == null || _bookingId!.isEmpty) {
      AppSnackbar.showSuccess(context, AppText.completionCodeResentSuccessfully);
      return;
    }
    final notifier = context.read<ProviderBookingDetailNotifier>();
    final ok = await notifier.resendCompletionCode(_bookingId!);
    if (!context.mounted) return;
    if (ok) {
      AppSnackbar.showSuccess(context, AppText.completionCodeResentSuccessfully);
    } else {
      AppSnackbar.showError(
        context,
        notifier.actionErrorMessage ?? 'Failed to resend completion code',
      );
    }
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
                                    context.read<ProviderBookingDetailNotifier>().bookingDetail?.formattedCompletedOn ?? '–',
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
                      if (_review == null || !_review!.exists)
                        Container(
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
                        )
                      else
                        AppContainerBg(
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
                                        assetPath: (_review!.authorAvatar != null &&
                                                _review!.authorAvatar!.isNotEmpty)
                                            ? _review!.authorAvatar!
                                            : booking.customerPhoto,
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
                                          _review!.authorName?.isNotEmpty == true
                                              ? _review!.authorName!
                                              : booking.customerName,
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
                                              _review!.ratingDisplay ??
                                                  '${_review!.rating}/5.0',
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
                                    ProviderBookingDetailModel
                                        .formattedShortDate(_review!.createdAt),
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(11),
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(10)),
                              Text(
                                _review!.comment?.isNotEmpty == true
                                    ? _review!.comment!
                                    : 'No comment left.',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(11),
                                  fontStyle: FontStyle.italic,
                                  color: const Color(0xFF475569),
                                  height: 1.4,
                                ),
                              ),
                              if (_review!.replyMessage != null &&
                                  _review!.replyMessage!.isNotEmpty) ...[
                                SizedBox(height: ResponsiveHelper.spacing(10)),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(
                                    ResponsiveHelper.padding(10),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveHelper.borderRadius(8),
                                    ),
                                    border: Border.all(
                                      color: AppColors.borderDefault,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppText.yourResponse,
                                        style: TextStyle(
                                          fontSize:
                                              ResponsiveHelper.fontSize(10),
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      SizedBox(
                                          height: ResponsiveHelper.spacing(4)),
                                      Text(
                                        _review!.replyMessage!,
                                        style: TextStyle(
                                          fontSize:
                                              ResponsiveHelper.fontSize(11),
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
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
                                    (() {
                                      final detail = context.read<ProviderBookingDetailNotifier>().bookingDetail;
                                      if (detail?.cancelledAt != null && detail!.cancelledAt!.isNotEmpty) {
                                        return ProviderBookingDetailModel.formattedShortDate(detail.cancelledAt);
                                      }
                                      return '–';
                                    })(),
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
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
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
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(10)),
                          AppButton(
                            text: AppText.resendCompletionCode,
                            onPressed: () => _onResendOtpCode(context),
                            width: double.infinity,
                            backgroundColor: AppColors.bgOverlay.withValues(alpha: 0.06),
                            borderColor: AppColors.brandPrimary,
                            textColor: AppColors.brandPrimary,
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppButton(
                                          text: AppText.messageCustomer,
                                          onPressed: () =>
                                              _onMessageCustomer(context),
                                          backgroundColor: AppColors.brandPrimary,
                                          textColor: AppColors.white,
                                        ),
                                      ),
                                      SizedBox(
                                          width: ResponsiveHelper.spacing(10)),
                                      Expanded(
                                        child: AppButton(
                                          text: AppText.startService,
                                          onPressed: () =>
                                              _onStartService(context),
                                          backgroundColor:
                                              AppColors.brandPrimary,
                                          textColor: AppColors.white,
                                        ),
                                      ),
                                    ],
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
