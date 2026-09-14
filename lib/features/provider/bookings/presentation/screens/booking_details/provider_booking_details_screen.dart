import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/core/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/provider/bookings/presentation/screens/customer_details/customer_details_screen.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/provider_booking_sample_data.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/cancel_booking_bottom_sheet.dart';
import 'package:nchito/features/user/messages/presentation/screens/chat_screen.dart';
import 'package:nchito/features/user/messages/presentation/widgets/message_sample_data.dart';
import '../../widgets/accept_quote_confirm_bottom_sheet.dart';
import '../../widgets/reject_booking_bottom_sheet.dart';
import '../../widgets/send_quote_bottom_sheet.dart';

class ProviderBookingDetailsScreen extends StatefulWidget {
  static const String routeName = '/provider/booking-details';

  final ProviderBookingData booking;

  const ProviderBookingDetailsScreen({super.key, required this.booking});

  @override
  State<ProviderBookingDetailsScreen> createState() =>
      _ProviderBookingDetailsScreenState();
}

class _ProviderBookingDetailsScreenState
    extends State<ProviderBookingDetailsScreen> {
  late String _currentStatus;
  late String _currentPrice;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.booking.status;
    _currentPrice = widget.booking.price;
  }

  ProviderBookingData get booking => widget.booking;

  static final _fieldColor = AppColors.bgOverlay.withValues(alpha: 0.04);
  static final _fieldRadius = ResponsiveHelper.borderRadius(10);
  static final _fieldPadding = EdgeInsets.all(ResponsiveHelper.padding(14));
  static final _fieldGap = ResponsiveHelper.spacing(8);

  Color get _statusColor {
    switch (_currentStatus) {
      case 'Accepted':
      case 'Confirmed':
        return AppColors.emerald400;
      case 'Scheduled':
        return AppColors.cyan400;
      case 'Rejected':
      case 'Cancelled':
        return AppColors.red400;
      default:
        return AppColors.amber500;
    }
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
            _currentStatus = AppText.accepted;
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

  void _onCancelBooking(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => CancelBookingBottomSheet(
        onConfirm: () {
          setState(() {
            _currentStatus = AppText.cancelled;
          });
        },
      ),
    );
  }

  void _onReschedule() {
    // TODO: wire up once the provider reschedule flow is designed.
  }

  void _onMessageCustomer(BuildContext context) {
    context.push(
      ChatScreen.routeName,
      extra: MessageData(
        name: booking.customerName,
        avatarAsset: booking.customerPhoto,
        lastMessage: 'Hi, regarding your booking for ${booking.service}.',
        timeLabel: 'Now',
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.spacing(10)),
      child: AppContainerBg(
        width: double.infinity,
        color: _fieldColor,
        radius: _fieldRadius,
        padding: _fieldPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: context.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: _fieldGap),
            Text(
              value,
              style: context.labelSmall.copyWith(
                color: AppColors.textBlackPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPending = _currentStatus == AppText.pending;

    return Scaffold(
      backgroundColor: AppColors.bgApp,
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
                              color: _statusColor.withValues(alpha: 0.2),
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

                    ///location========================================
                    _buildDetailRow(
                      context,
                      label: AppText.location,
                      value: booking.location,
                    ),

                    /// date================================
                    _buildDetailRow(
                      context,
                      label: AppText.date,
                      value: booking.fullDate,
                    ),

                    /// time====================================
                    _buildDetailRow(
                      context,
                      label: AppText.time,
                      value: booking.fullTime,
                    ),

                    /// price/quote=============================
                    _buildDetailRow(
                      context,
                      label: AppText.serviceCost,
                      value: _currentPrice,
                    ),

                    ///details======================================
                    _buildDetailRow(
                      context,
                      label: AppText.details,
                      value: booking.details,
                    ),

                    ///photo=========================================
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
                    SizedBox(height: ResponsiveHelper.spacing(20)),
                  ],
                ),
              ),
            ),

            /// depend of status==================================================
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(24),
                vertical: ResponsiveHelper.padding(16),
              ),
              child: _currentStatus == AppText.rejected
                  ? AppButton(
                      text: AppText.messageCustomer,
                      onPressed: () => _onMessageCustomer(context),
                      width: double.infinity,
                      backgroundColor: AppColors.brandPrimary,
                      textColor: AppColors.white,
                    )
                  : isPending
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
                      : Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: AppButton(
                                    text: AppText.cancelBooking,
                                    onPressed: () => _onCancelBooking(context),
                                    backgroundColor: AppColors.red,
                                    textColor: AppColors.white,
                                  ),
                                ),
                                SizedBox(width: ResponsiveHelper.spacing(10)),
                                Expanded(
                                  child: AppButton(
                                    text: AppText.reschedule,
                                    onPressed: _onReschedule,
                                    backgroundColor: AppColors.brandPrimary,
                                    textColor: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(10)),
                            AppButton(
                              text: AppText.messageCustomer,
                              onPressed: () => _onMessageCustomer(context),
                              width: double.infinity,
                              backgroundColor: AppColors.brandPrimary,
                              textColor: AppColors.white,
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
