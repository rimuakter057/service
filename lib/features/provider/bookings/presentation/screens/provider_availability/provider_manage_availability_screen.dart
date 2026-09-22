import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_calendar/app_calendar.dart';
import 'package:nchito/features/common/common_widgets/app_snackbar/app_snackbar.dart';
import 'package:nchito/features/common/common_widgets/app_time_slot_picker/app_time_slot_picker.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/features/provider/bookings/presentation/providers/provider_booking_detail_notifier.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/provider_booking_sample_data.dart';

/// Provider Manage Availability Screen — separate screen for the provider
/// to propose new reschedule dates/times or view/update their own working
/// availability. Not to be confused with the user-facing
/// `ProviderAvailabilityScreen` (features/user/home), which is a user
/// viewing a provider's availability to book a slot.
class ProviderManageAvailabilityScreen extends StatefulWidget {
  static const String routeName = '/provider/availability';

  final dynamic booking;

  const ProviderManageAvailabilityScreen({super.key, this.booking});

  @override
  State<ProviderManageAvailabilityScreen> createState() =>
      _ProviderManageAvailabilityScreenState();
}

class _ProviderManageAvailabilityScreenState
    extends State<ProviderManageAvailabilityScreen> {
  final Set<int> _selectedSlots = {0, 3};
  DateTime _selectedDate = DateTime.now();

  void _onToggleSlot(int index) {
    setState(() {
      if (_selectedSlots.contains(index)) {
        _selectedSlots.remove(index);
      } else {
        _selectedSlots.add(index);
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Converts a "8:00 AM" / "10:30 PM" label into a 24h "HH:mm:00" string
  /// the API expects for `scheduled_time`.
  String? _slotStartTime24h() {
    if (_selectedSlots.isEmpty) return null;
    final index = _selectedSlots.first;
    if (index < 0 || index >= defaultTimeSlots.length) return null;
    final label = defaultTimeSlots[index].label;
    final start = label.split('–').first.trim();
    final match = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)$', caseSensitive: false)
        .firstMatch(start);
    if (match == null) return null;
    int hour = int.parse(match.group(1)!);
    final minute = match.group(2)!;
    final period = match.group(3)!.toUpperCase();
    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;
    return '${hour.toString().padLeft(2, '0')}:$minute:00';
  }

  void _onConfirm() async {
    final bookingId =
        widget.booking is ProviderBookingData ? widget.booking.id : null;
    final scheduledTime = _slotStartTime24h();

    if (bookingId == null || bookingId.isEmpty || scheduledTime == null) {
      if (context.canPop()) context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reschedule proposal sent to customer!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final notifier = context.read<ProviderBookingDetailNotifier>();
    final ok = await notifier.rescheduleBooking(
      bookingId,
      scheduledDate: _formatDate(_selectedDate),
      scheduledTime: scheduledTime,
    );
    if (!mounted) return;
    if (ok) {
      AppSnackbar.showSuccess(context, 'Reschedule proposal sent to customer!');
      if (context.canPop()) context.pop();
    } else {
      AppSnackbar.showError(
        context,
        notifier.actionErrorMessage ?? 'Failed to send reschedule proposal',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.providerAvailability),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCalendar(
                      initialSelectedDate: _selectedDate,
                      onDateSelected: (date) =>
                          setState(() => _selectedDate = date),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),
                    AppTimeSlotPicker(
                      selectedSlots: _selectedSlots,
                      onSlotToggled: _onToggleSlot,
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
                text: AppText.rescheduleNow,
                onPressed: _onConfirm,
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
}
