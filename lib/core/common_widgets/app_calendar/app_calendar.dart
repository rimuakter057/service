import 'package:flutter/material.dart';

import '../../extensions/context_extension/context_extension.dart';
import '../../helper/responsive_helper/responsive_helper.dart';
import '../../utils/app_colors/app_colors.dart';
import '../../utils/app_text/app_text.dart';
import '../../utils/assets_path/assets_path.dart';
import '../app_button/app_button.dart';
import '../app_container_bg/app_container_bg.dart';
import '../app_icon/bg_icon.dart';

const List<String> _weekdayLabels = [
  AppText.mon,
  AppText.tue,
  AppText.wed,
  AppText.thu,
  AppText.fri,
  AppText.sat,
  AppText.sun,
];

const List<String> _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Month calendar with prev/next navigation and a selectable day grid —
/// used anywhere a date needs picking (Provider Availability, Explore
/// Provider, ...).
class AppCalendar extends StatefulWidget {
  final DateTime? initialSelectedDate;
  final ValueChanged<DateTime>? onDateSelected;

  const AppCalendar({super.key, this.initialSelectedDate, this.onDateSelected});

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late DateTime _displayedMonth;
  late DateTime _today;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _selectedDate = widget.initialSelectedDate ?? _today;
    _displayedMonth = DateTime(_selectedDate!.year, _selectedDate!.month);
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + delta,
      );
    });
  }

  void _selectDate(DateTime date) {
    setState(() => _selectedDate = date);
    widget.onDateSelected?.call(date);
  }

  List<DateTime> _buildMonthGrid() {
    final firstOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    );
    final leadingDays = firstOfMonth.weekday - DateTime.monday;
    final gridStart = firstOfMonth.subtract(Duration(days: leadingDays));
    return List.generate(42, (i) => gridStart.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final monthDays = _buildMonthGrid();
    final monthLabel =
        '${_monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}';

    return AppContainerBg(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(monthLabel, style: context.labelMedium),
              Row(
                children: [
                  _MonthNavButton(
                    pointsForward: false,
                    onTap: () => _changeMonth(-1),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(8)),
                  _MonthNavButton(
                    pointsForward: true,
                    onTap: () => _changeMonth(1),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.spacing(16)),
          Row(
            children: _weekdayLabels
                .map(
                  (day) => Expanded(
                    child: Center(child: Text(day, style: context.bodySmall)),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: ResponsiveHelper.spacing(8)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: monthDays.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: ResponsiveHelper.spacing(4),
            ),
            itemBuilder: (context, index) {
              final day = monthDays[index];
              return Center(
                child: _DayCell(
                  date: day,
                  isCurrentMonth: day.month == _displayedMonth.month,
                  isToday: day == _today,
                  isSelected: day == _selectedDate,
                  onTap: () => _selectDate(day),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MonthNavButton extends StatelessWidget {
  /// Mirrors the shared "back" arrow instead of a dedicated forward icon —
  /// several Figma-exported "chevron" assets in this project don't match
  /// their filename, so a known-good arrow flipped is more reliable.
  final bool pointsForward;
  final VoidCallback onTap;

  const _MonthNavButton({required this.pointsForward, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final icon = BgIcon(
      assetPath: AssetsPath.exploreProviderDetailsIconBack,
      bgColor: AppColors.borderDefault.withValues(alpha: 0.3),
      iconColor: AppColors.textBlackPrimary,
      bgSize: ResponsiveHelper.width(28),
      iconSize: ResponsiveHelper.iconSize(12),
      radius: ResponsiveHelper.width(14),
    );

    return GestureDetector(
      onTap: onTap,
      child: pointsForward ? Transform.flip(flipX: true, child: icon) : icon,
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayCell({
    required this.date,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveHelper.width(36);
    final Color textColor;
    final Color bgColor;
    final Color? borderColor;

    if (!isCurrentMonth) {
      textColor = AppColors.textGrey.withValues(alpha: 0.5);
      bgColor = Colors.transparent;
      borderColor = null;
    } else if (isSelected) {
      textColor = AppColors.brandPrimary;
      bgColor = Colors.transparent;
      borderColor = AppColors.brandPrimary;
    } else if (isToday) {
      textColor = AppColors.textBlackPrimary;
      bgColor = AppColors.borderDefault.withValues(alpha: 0.4);
      borderColor = null;
    } else {
      textColor = AppColors.textBlackPrimary;
      bgColor = Colors.transparent;
      borderColor = null;
    }

    return AppButton(
      text: '${date.day}',
      onPressed: isCurrentMonth ? onTap : null,
      width: size,
      height: size,
      radius: size / 2,
      backgroundColor: bgColor,
      borderColor: borderColor,
      textColor: textColor,
      textStyle: TextStyle(
        fontSize: ResponsiveHelper.fontSize(13),
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }
}
