import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_calendar/app_calendar.dart';
import 'package:nchito/features/common/common_widgets/app_time_slot_picker/app_time_slot_picker.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/bookings/presentation/screens/booking_details/booking_details_screen.dart'
    as bookings;
import 'package:nchito/features/user/explore/presentation/screens/book_a_service/book_a_service_screen.dart';

/// Calendar + time-slot picker — reached from Provider Details'
/// "See Availability" button or from Reschedule Booking flow.
class ProviderAvailabilityScreen extends StatefulWidget {
  static const String routeName = '/provider-availability';

  final bool isRescheduling;
  final dynamic booking;

  const ProviderAvailabilityScreen({
    super.key,
    this.isRescheduling = false,
    this.booking,
  });

  @override
  State<ProviderAvailabilityScreen> createState() =>
      _ProviderAvailabilityScreenState();
}

class _ProviderAvailabilityScreenState
    extends State<ProviderAvailabilityScreen> {
  final Set<int> _selectedSlots = {0, 3};

  void _onToggleSlot(int index) {
    setState(() {
      if (_selectedSlots.contains(index)) {
        _selectedSlots.remove(index);
      } else {
        _selectedSlots.add(index);
      }
    });
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
                    const AppCalendar(
                      initialSelectedDate: null,
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
                text: widget.isRescheduling
                    ? AppText.rescheduleNow
                    : AppText.bookNow,
                onPressed: () {
                  if (widget.isRescheduling) {
                    if (widget.booking is BookingHistoryData) {
                      final updated =
                          (widget.booking as BookingHistoryData).copyWith(
                        status: AppText.inProgress,
                      );
                      context.pushReplacement(
                        bookings.BookingDetailsScreen.routeName,
                        extra: updated,
                      );
                    } else {
                      context.pop();
                    }
                  } else {
                    context.push(BookAServiceScreen.routeName);
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
}
