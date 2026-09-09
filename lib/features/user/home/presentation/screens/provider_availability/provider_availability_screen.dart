import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/common_widgets/app_calendar/app_calendar.dart';
import 'package:nchito/core/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

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
/// "See Availability" button.
class ProviderAvailabilityScreen extends StatefulWidget {
  static const String routeName = '/provider-availability';

  const ProviderAvailabilityScreen({super.key});

  @override
  State<ProviderAvailabilityScreen> createState() =>
      _ProviderAvailabilityScreenState();
}

class _ProviderAvailabilityScreenState
    extends State<ProviderAvailabilityScreen> {
  int? _selectedSlotIndex;

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
                    const AppCalendar(),
                    SizedBox(height: ResponsiveHelper.spacing(20)),

                    Text(AppText.availableTime, style: context.labelMedium),
                    SizedBox(height: ResponsiveHelper.spacing(12)),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _timeSlots.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: ResponsiveHelper.spacing(12),
                        crossAxisSpacing: ResponsiveHelper.spacing(12),
                        childAspectRatio: 2.6,
                      ),
                      itemBuilder: (context, index) {
                        final slot = _timeSlots[index];
                        final isSelected = _selectedSlotIndex == index;
                        return AppButton(
                          text: slot.label,
                          onPressed: slot.isAvailable
                              ? () => setState(() => _selectedSlotIndex = index)
                              : null,
                          backgroundColor: isSelected
                              ? AppColors.brandSoft
                              : Colors.transparent,
                          borderColor: slot.isAvailable
                              ? AppColors.brandPrimary
                              : AppColors.borderDefault,
                          textColor: slot.isAvailable
                              ? AppColors.brandPrimary
                              : AppColors.textGrey,
                          textStyle: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(12),
                            fontWeight: FontWeight.w600,
                            color: slot.isAvailable
                                ? AppColors.brandPrimary
                                : AppColors.textGrey,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(24),
                vertical: ResponsiveHelper.padding(16),
              ),
              child: AppButton(
                text: AppText.bookNow,
                onPressed: () {},
                width: double.infinity,
                backgroundColor: AppColors.brandPrimary,
                textColor: AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
