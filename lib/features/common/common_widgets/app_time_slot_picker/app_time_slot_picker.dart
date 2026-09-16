import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';

class TimeSlotItem {
  final String label;
  final bool isAvailable;

  const TimeSlotItem({required this.label, required this.isAvailable});
}

const List<TimeSlotItem> defaultTimeSlots = [
  TimeSlotItem(label: '8:00 AM – 10:00 AM', isAvailable: true),
  TimeSlotItem(label: '10:30 AM – 12:30 PM', isAvailable: false),
  TimeSlotItem(label: '1:00 PM – 3:00 PM', isAvailable: false),
  TimeSlotItem(label: '3:30 PM – 5:30 PM', isAvailable: true),
];

/// Reusable Custom Time Slot Picker Grid used in both User and Provider availability screens.
class AppTimeSlotPicker extends StatelessWidget {
  final List<TimeSlotItem> slots;
  final Set<int> selectedSlots;
  final ValueChanged<int> onSlotToggled;
  final String? title;

  const AppTimeSlotPicker({
    super.key,
    this.slots = defaultTimeSlots,
    required this.selectedSlots,
    required this.onSlotToggled,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? AppText.availableTime,
          style: context.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textBlackPrimary,
          ),
        ),
        SizedBox(height: ResponsiveHelper.spacing(14)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: slots.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: ResponsiveHelper.spacing(12),
            crossAxisSpacing: ResponsiveHelper.spacing(12),
            childAspectRatio: 3.2,
          ),
          itemBuilder: (context, index) {
            final slot = slots[index];
            final isAvailable = slot.isAvailable;
            final isSelected = selectedSlots.contains(index);

            final bgColor = isAvailable
                ? (isSelected ? AppColors.brandSoft : AppColors.white)
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
              onTap: isAvailable ? () => onSlotToggled(index) : null,
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
                    fontWeight:
                        isAvailable ? FontWeight.w700 : FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: textColor,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
