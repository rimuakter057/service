import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_calendar/app_calendar.dart';
import 'package:nchito/features/common/common_widgets/app_shimmer/app_shimmer.dart';
import 'package:nchito/features/common/common_widgets/app_time_slot_picker/app_time_slot_picker.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/features/common/common_widgets/app_snackbar/app_snackbar.dart';
import 'package:nchito/features/user/bookings/presentation/providers/customer_booking_detail_notifier.dart';
import 'package:nchito/features/user/bookings/presentation/screens/booking_details/booking_details_screen.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/explore/presentation/screens/book_a_service/book_a_service_screen.dart';
import 'package:nchito/features/user/home/data/models/provider_day_availability_model.dart';
import 'package:nchito/features/user/home/presentation/providers/provider_availability_provider.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

/// Calendar + time-slot picker — reached from Provider Details'
/// "See Availability" button or from Reschedule Booking flow.
class ProviderAvailabilityScreen extends StatefulWidget {
  static const String routeName = '/provider-availability';

  final bool isRescheduling;
  final dynamic booking;
  final String? providerId;
  final dynamic provider;

  const ProviderAvailabilityScreen({
    super.key,
    this.isRescheduling = false,
    this.booking,
    this.providerId,
    this.provider,
  });

  @override
  State<ProviderAvailabilityScreen> createState() =>
      _ProviderAvailabilityScreenState();
}

class _ProviderAvailabilityScreenState
    extends State<ProviderAvailabilityScreen> {
  late DateTime _currentSelectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentSelectedDate = DateTime(now.year, now.month, now.day);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAvailabilityForDate(_currentSelectedDate);
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _resolveProviderId() {
    if (widget.providerId != null && widget.providerId!.isNotEmpty) {
      return widget.providerId!;
    }
    if (widget.provider is HomeProviderData) {
      final p = widget.provider as HomeProviderData;
      if (p.id != null && p.id!.isNotEmpty) {
        return p.id!;
      }
    }
    return '6aae448a527875a24459c632';
  }

  void _loadAvailabilityForDate(DateTime date) {
    final effectiveId = _resolveProviderId();
    context.read<ProviderAvailabilityNotifier>().fetchAvailability(
          providerId: effectiveId,
          date: _formatDate(date),
        );
  }

  @override
  Widget build(BuildContext context) {
    final availabilityNotifier = context.watch<ProviderAvailabilityNotifier>();
    final model = availabilityNotifier.availabilityModel;
    final isLoading = availabilityNotifier.isLoading;

    final title = (model != null && model.title.isNotEmpty)
        ? model.title
        : AppText.providerAvailability;

    final bookLabel = widget.isRescheduling
        ? AppText.rescheduleNow
        : ((model != null && model.bookLabel.isNotEmpty)
            ? model.bookLabel
            : AppText.bookNow);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopAppbar(title: title),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCalendar(
                      initialSelectedDate: _currentSelectedDate,
                      onDateSelected: (date) {
                        setState(() => _currentSelectedDate = date);
                        _loadAvailabilityForDate(date);
                      },
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),
                    if (!isLoading && model != null) ...[
                      _buildWorkingHoursSection(context, model.workingHours),
                      SizedBox(height: ResponsiveHelper.spacing(18)),
                      _buildBookedTimeSection(
                        context,
                        bookedLabel: model.bookedLabel,
                        booked: model.booked,
                        emptyMessage: model.bookedEmptyMessage,
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(18)),
                    ],
                    _buildTimeSlotsSection(
                      context,
                      availabilityNotifier: availabilityNotifier,
                      isLoading: isLoading,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(24),
                vertical: ResponsiveHelper.padding(20),
              ),
                child: AppButton(
                  text: bookLabel,
                  onPressed: () async {
                    if (widget.isRescheduling) {
                      final currentBooking = widget.booking is BookingHistoryData
                          ? widget.booking as BookingHistoryData
                          : null;
                      final bookingId = currentBooking?.id;

                      final selectedSlotIndex =
                          availabilityNotifier.selectedSlots.isNotEmpty
                              ? availabilityNotifier.selectedSlots.first
                              : -1;
                      final slots = availabilityNotifier.availabilityModel?.slots;
                      final selectedSlotModel = (slots != null &&
                              selectedSlotIndex >= 0 &&
                              selectedSlotIndex < slots.length)
                          ? slots[selectedSlotIndex]
                          : (slots?.where((s) => s.isAvailable).firstOrNull);

                      if (bookingId == null || bookingId.isEmpty) {
                        context.pop();
                        return;
                      }

                      final notifier = context.read<CustomerBookingDetailNotifier>();
                      final ok = await notifier.rescheduleBooking(
                        bookingId,
                        scheduledDate: _formatDate(_currentSelectedDate),
                        scheduledTime: selectedSlotModel?.startTime ?? '',
                      );
                      if (!context.mounted) return;
                      if (!ok) {
                        AppSnackbar.showError(
                          context,
                          notifier.actionErrorMessage ??
                              'Failed to reschedule booking',
                        );
                        return;
                      }
                      AppSnackbar.showSuccess(
                        context,
                        'Reschedule request sent successfully',
                      );
                      final updated = currentBooking?.copyWith(
                        status: AppText.inProgress,
                      );
                      if (updated != null) {
                        context.pushReplacement(
                          BookingDetailsScreen.routeName,
                          extra: updated,
                        );
                      } else {
                        context.pop();
                      }
                    } else {
                      HomeProviderData? passProvider;
                      if (widget.provider is HomeProviderData) {
                        passProvider = widget.provider as HomeProviderData;
                      }

                      // Extract selected slot
                      final selectedSlotIndex =
                          availabilityNotifier.selectedSlots.isNotEmpty
                              ? availabilityNotifier.selectedSlots.first
                              : -1;
                      final slots =
                          availabilityNotifier.availabilityModel?.slots;
                      final selectedSlotModel =
                          (slots != null &&
                                  selectedSlotIndex >= 0 &&
                                  selectedSlotIndex < slots.length)
                              ? slots[selectedSlotIndex]
                              : (slots?.where((s) => s.isAvailable).firstOrNull);

                      context.push(
                        BookAServiceScreen.routeName,
                        extra: {
                          'provider': passProvider,
                          'date': _formatDate(_currentSelectedDate),
                          'slot': selectedSlotModel?.formattedSlotLabel,
                          'time': selectedSlotModel?.startTime,
                          'providerId': _resolveProviderId(),
                        },
                      );
                    }
                  },
                  width: double.infinity,
                  height: ResponsiveHelper.height(52),
                  radius: ResponsiveHelper.borderRadius(12),
                  backgroundColor: AppColors.brandPrimary,
                  textColor: AppColors.textOnPrimary,
                  textStyle: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(16),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkingHoursSection(
    BuildContext context,
    ProviderWorkingHoursModel? workingHours,
  ) {
    if (workingHours == null || workingHours.label.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Working Hours',
          style: context.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textBlackPrimary,
          ),
        ),
        SizedBox(height: ResponsiveHelper.spacing(10)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.padding(16),
            vertical: ResponsiveHelper.padding(14),
          ),
          decoration: BoxDecoration(
            color: AppColors.brandSoft,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.borderRadius(12),
            ),
            border: Border.all(
              color: AppColors.brandPrimary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: ResponsiveHelper.width(36),
                height: ResponsiveHelper.width(36),
                decoration: const BoxDecoration(
                  color: AppColors.brandPrimary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.access_time_rounded,
                  size: ResponsiveHelper.iconSize(18),
                  color: Colors.white,
                ),
              ),
              SizedBox(width: ResponsiveHelper.spacing(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Schedule',
                      style: context.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(2)),
                    Text(
                      workingHours.label,
                      style: context.labelLarge.copyWith(
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(10),
                  vertical: ResponsiveHelper.padding(4),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.spacing(4)),
                    Text(
                      'Active',
                      style: context.bodySmall.copyWith(
                        color: const Color(0xFF047857),
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveHelper.fontSize(11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookedTimeSection(
    BuildContext context, {
    required String bookedLabel,
    required List<ProviderBookedSlotModel> booked,
    required String emptyMessage,
  }) {
    final title = bookedLabel.isNotEmpty ? bookedLabel : 'Booked Time';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: context.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textBlackPrimary,
              ),
            ),
            if (booked.isNotEmpty) ...[
              SizedBox(width: ResponsiveHelper.spacing(8)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(8),
                  vertical: ResponsiveHelper.padding(2),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(10),
                  ),
                ),
                child: Text(
                  '${booked.length} booked',
                  style: TextStyle(
                    color: const Color(0xFFDC2626),
                    fontSize: ResponsiveHelper.fontSize(11),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: ResponsiveHelper.spacing(10)),
        if (booked.isNotEmpty)
          Wrap(
            spacing: ResponsiveHelper.spacing(10),
            runSpacing: ResponsiveHelper.spacing(10),
            children: booked.map((b) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(12),
                  vertical: ResponsiveHelper.padding(10),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(10),
                  ),
                  border: Border.all(
                    color: const Color(0xFFFECDD3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.event_busy_rounded,
                      size: ResponsiveHelper.iconSize(14),
                      color: const Color(0xFFE11D48),
                    ),
                    SizedBox(width: ResponsiveHelper.spacing(6)),
                    Text(
                      b.label,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(12),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFBE123C),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          )
        else
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.padding(14),
              vertical: ResponsiveHelper.padding(12),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(10),
              ),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: ResponsiveHelper.iconSize(16),
                  color: const Color(0xFF10B981),
                ),
                SizedBox(width: ResponsiveHelper.spacing(8)),
                Expanded(
                  child: Text(
                    emptyMessage.isNotEmpty
                        ? emptyMessage
                        : 'No bookings yet — any time works.',
                    style: context.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTimeSlotsSection(
    BuildContext context, {
    required ProviderAvailabilityNotifier availabilityNotifier,
    required bool isLoading,
  }) {
    final model = availabilityNotifier.availabilityModel;
    final slotsLabel = (model != null && model.slotsLabel.isNotEmpty)
        ? model.slotsLabel
        : AppText.availableTime;

    if (isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            slotsLabel,
            style: context.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textBlackPrimary,
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(14)),
          AppShimmer(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: ResponsiveHelper.spacing(12),
                crossAxisSpacing: ResponsiveHelper.spacing(12),
                childAspectRatio: 3.2,
              ),
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (model == null ||
        model.slots.isEmpty ||
        !model.hasSchedule ||
        model.isFullDayBlocked) {
      final emptyMsg = (model != null && model.emptyMessage.isNotEmpty)
          ? model.emptyMessage
          : 'No available time on this date. Try another day.';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            slotsLabel,
            style: context.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textBlackPrimary,
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(14)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveHelper.padding(24),
              horizontal: ResponsiveHelper.padding(16),
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(12),
              ),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Center(
              child: Text(
                emptyMsg,
                textAlign: TextAlign.center,
                style: context.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    }

    final slotItems = model.slots.map((s) => s.toTimeSlotItem()).toList();

    return AppTimeSlotPicker(
      title: slotsLabel,
      slots: slotItems,
      selectedSlots: availabilityNotifier.selectedSlots,
      onSlotToggled: availabilityNotifier.toggleSlot,
    );
  }
}
