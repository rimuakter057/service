import 'package:flutter/material.dart';

import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import '../app_container_bg/app_container_bg.dart';

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
  final DateTime? initialDisplayedMonth;
  final DateTime? today;
  final ValueChanged<DateTime>? onDateSelected;

  const AppCalendar({
    super.key,
    this.initialSelectedDate,
    this.initialDisplayedMonth,
    this.today,
    this.onDateSelected,
  });

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
    _today = widget.today ?? DateTime(2025, 10, 17);
    _selectedDate = widget.initialSelectedDate ?? DateTime(2025, 10, 26);
    _displayedMonth = widget.initialDisplayedMonth ??
        DateTime(_selectedDate!.year, _selectedDate!.month);
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
    final leadingDays = (firstOfMonth.weekday - DateTime.monday) % 7;
    final gridStart = firstOfMonth.subtract(Duration(days: leadingDays));
    return List.generate(35, (i) => gridStart.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final monthDays = _buildMonthGrid();
    final monthLabel =
        '${_monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}';

    return AppContainerBg(
      color: AppColors.white,
      padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
      radius: ResponsiveHelper.borderRadius(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthLabel,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBlackPrimary,
                ),
              ),
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
                    child: Center(
                      child: Text(
                        day,
                        style: context.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: ResponsiveHelper.spacing(12)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: monthDays.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: ResponsiveHelper.spacing(8),
            ),
            itemBuilder: (context, index) {
              final day = monthDays[index];
              final isCurrentMonth = day.month == _displayedMonth.month;
              final isPastInMonth = isCurrentMonth &&
                  (day.year == _today.year &&
                      day.month == _today.month &&
                      day.day < _today.day);
              final isToday = day.year == _today.year &&
                  day.month == _today.month &&
                  day.day == _today.day;
              final isSelected = _selectedDate != null &&
                  day.year == _selectedDate!.year &&
                  day.month == _selectedDate!.month &&
                  day.day == _selectedDate!.day;

              return Center(
                child: _DayCell(
                  date: day,
                  isCurrentMonth: isCurrentMonth,
                  isToday: isToday,
                  isSelected: isSelected,
                  isPastInMonth: isPastInMonth,
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
  final bool pointsForward;
  final VoidCallback onTap;

  const _MonthNavButton({required this.pointsForward, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveHelper.width(36),
        height: ResponsiveHelper.width(36),
        decoration: const BoxDecoration(
          color: Color(0xFFF3F4F6),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          pointsForward
              ? Icons.chevron_right_rounded
              : Icons.chevron_left_rounded,
          size: ResponsiveHelper.iconSize(20),
          color: AppColors.textBlackPrimary,
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final bool isPastInMonth;
  final VoidCallback onTap;

  const _DayCell({
    required this.date,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSelected,
    required this.isPastInMonth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveHelper.width(36);
    final Color textColor;
    final Color bgColor;
    final Border? border;

    if (!isCurrentMonth || isPastInMonth) {
      textColor = const Color(0xFFD1D5DB);
      bgColor = Colors.transparent;
      border = null;
    } else if (isSelected) {
      textColor = AppColors.brandPrimary;
      bgColor = AppColors.brandSoft;
      border = Border.all(color: AppColors.brandPrimary, width: 1.5);
    } else if (isToday) {
      textColor = AppColors.textBlackPrimary;
      bgColor = const Color(0xFFF3F4F6);
      border = null;
    } else {
      textColor = AppColors.textBlackPrimary;
      bgColor = Colors.transparent;
      border = null;
    }

    return GestureDetector(
      onTap: (isCurrentMonth && !isPastInMonth) ? onTap : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: border,
        ),
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: TextStyle(
            fontSize: ResponsiveHelper.fontSize(14),
            fontWeight: (isSelected ||
                    isToday ||
                    (isCurrentMonth && !isPastInMonth))
                ? FontWeight.w600
                : FontWeight.w400,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
