import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/common_widgets/app_calendar/app_calendar.dart';
import 'package:nchito/core/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/bookings/presentation/screens/booking_details/booking_details_screen.dart'
    as bookings;

class _TimeSlot {
  final String label;
  final bool isAvailable;

  const _TimeSlot({required this.label, required this.isAvailable});
}

const List<_TimeSlot> _timeSlots = [
  _TimeSlot(label: '8:00 AM – 10:00 AM', isAvailable: true),
  _TimeSlot(label: '10:30 AM – 12:30 PM', isAvailable: false),
  _TimeSlot(label: '1:00 PM – 3:00 PM', isAvailable: false),
  _TimeSlot(label: '3:30 PM – 5:30 PM', isAvailable: true),
];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
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
                      initialSelectedDate: null, // defaults to 2025-10-26 in AppCalendar
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),

                    Text(
                      AppText.availableTime,
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(14)),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _timeSlots.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: ResponsiveHelper.spacing(12),
                        crossAxisSpacing: ResponsiveHelper.spacing(12),
                        childAspectRatio: 3.2,
                      ),
                      itemBuilder: (context, index) {
                        final slot = _timeSlots[index];
                        final isAvailable = slot.isAvailable;
                        final isSelected = _selectedSlots.contains(index);

                        final bgColor = isAvailable
                            ? (isSelected
                                ? AppColors.brandSoft
                                : AppColors.white)
                            : const Color(0xFFF6F6F6);
                        final borderColor = isAvailable
                            ? (isSelected
                                ? AppColors.brandPrimary
                                : AppColors.borderDefault)
                            : const Color(0xFFD1D5DB);
                        final textColor = isAvailable
                            ? AppColors.brandPrimary
                            : const Color(0xFF9CA3AF);

                        return GestureDetector(
                          onTap: isAvailable
                              ? () {
                                  setState(() {
                                    if (_selectedSlots.contains(index)) {
                                      _selectedSlots.remove(index);
                                    } else {
                                      _selectedSlots.add(index);
                                    }
                                  });
                                }
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(10),
                              ),
                              border: Border.all(
                                color: borderColor,
                                width: isAvailable && isSelected ? 1.4 : 1.0,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              slot.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(12),
                                fontWeight: isAvailable
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                color: textColor,
                              ),
                            ),
                          ),
                        );
                      },
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
                    context.push('/booking-confirmed');
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
