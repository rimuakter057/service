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
import 'package:nchito/features/user/home/presentation/screens/provider_details/provider_details_screen.dart';
import 'package:nchito/features/user/home/presentation/widgets/detail_field.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/cancel_booking_bottom_sheet.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/decline_quote_bottom_sheet.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/proceed_to_payment_bottom_sheet.dart';

/// Single booking — reached by tapping an item on the My Bookings screen.
///
/// Shows the plain "Cancel Booking" action for most statuses, and swaps in
/// a Payment Info card plus "Decline Quote" / "Proceed to Pay" / "Message
/// Provider" actions once a quote has been accepted (`booking.serviceCost`
/// is set).
class BookingDetailsScreen extends StatelessWidget {
  static const String routeName = '/bookings/booking-details';

  final BookingHistoryData booking;

  const BookingDetailsScreen({super.key, required this.booking});

  bool get _hasQuote => booking.serviceCost != null;

  Color get _statusColor {
    switch (booking.status) {
      case AppText.accepted:
        return AppColors.blueStatusInfo;
      case AppText.scheduled:
        return AppColors.emerald400;
      case AppText.inProgress:
        return AppColors.blue400;
      case AppText.completed:
        return AppColors.emerald400;
      case AppText.cancelled:
        return AppColors.red400;
      case AppText.rejected:
        return AppColors.red;
      case AppText.disputed:
        return AppColors.orange400;
      default:
        return AppColors.amber500; // Pending
    }
  }

  // Figma: rgba(0,0,0,0.04) bg, 10px radius, 14px padding, 8px label/value gap
  static final _fieldColor = AppColors.bgOverlay.withValues(alpha: 0.04);
  static final _fieldRadius = ResponsiveHelper.borderRadius(10);
  static final _fieldPadding = EdgeInsets.all(ResponsiveHelper.padding(14));
  static final _fieldGap = ResponsiveHelper.spacing(8);

  void _onDeclineQuote(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => DeclineQuoteBottomSheet(
        onConfirm: () {
          // TODO(backend): call the decline-quote API for `booking` here
          // once the backend is available.
        },
      ),
    );
  }

  void _onProceedToPay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => ProceedToPaymentBottomSheet(
        serviceCost: booking.serviceCost!,
        onConfirm: () {
          // TODO(backend): kick off the payment flow for `booking` here
          // once the backend is available.
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
          // TODO(backend): call the cancel-booking API for `booking` here
          // once the backend is available.
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    ///service type=============================================
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

                            ///status=========================
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
                                    booking.status,
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
                    DetailField(
                      label: AppText.location,
                      value: booking.location,
                      color: _fieldColor,
                      radius: _fieldRadius,
                      contentPadding: _fieldPadding,
                      gap: _fieldGap,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    ///date======================================
                    DetailField(
                      label: AppText.date,
                      value: booking.date,
                      color: _fieldColor,
                      radius: _fieldRadius,
                      contentPadding: _fieldPadding,
                      gap: _fieldGap,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    ///time===================================
                    DetailField(
                      label: AppText.time,
                      value: booking.time,
                      color: _fieldColor,
                      radius: _fieldRadius,
                      contentPadding: _fieldPadding,
                      gap: _fieldGap,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    ///details==================================
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
                                  child: AppIcon(
                                    assetPath: booking.provider.photo,
                                    size: ResponsiveHelper.width(44),
                                    fit: BoxFit.cover,
                                  ),
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
                                  booking.provider.name,
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
                              extra: booking.provider,
                            ),
                            child: BgIcon(
                              assetPath: AssetsPath.bookingDetailsIconViewProvider,
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
                    if (_hasQuote) ...[
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
                                  booking.serviceCost!,
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
                    SizedBox(height: ResponsiveHelper.spacing(20)),
                  ],
                ),
              ),
            ),

            ///actions ================================
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(24),
                vertical: ResponsiveHelper.padding(16),
              ),
              child: _hasQuote
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                text: AppText.declineQuote,
                                onPressed: () => _onDeclineQuote(context),
                                backgroundColor: AppColors.red,
                                textColor: AppColors.white,
                              ),
                            ),
                            SizedBox(width: ResponsiveHelper.spacing(10)),
                            Expanded(
                              child: AppButton(
                                text: AppText.proceedToPay,
                                onPressed: () => _onProceedToPay(context),
                                backgroundColor: AppColors.brandPrimary,
                                textColor: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(10)),
                        AppButton(
                          text: AppText.messageProvider,
                          onPressed: () {},
                          width: double.infinity,
                          backgroundColor: AppColors.brandPrimary,
                          textColor: AppColors.white,
                        ),
                      ],
                    )
                  : AppButton(
                      text: AppText.cancelBooking,
                      onPressed: () => _onCancelBooking(context),
                      width: double.infinity,
                      backgroundColor: AppColors.red,
                      textColor: AppColors.white,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
