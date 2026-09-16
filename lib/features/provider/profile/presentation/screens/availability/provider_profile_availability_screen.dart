import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_confirm_bottom_sheet/app_confirm_bottom_sheet.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/features/provider/profile/presentation/screens/set_availability/provider_set_availability_screen.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

class _SlotInfo {
  final String id;
  final String timeRange;
  bool isBlocked;

  _SlotInfo({
    required this.id,
    required this.timeRange,
  }) : isBlocked = false;
}

/// Provider Availability Screen — displays interactive calendar, slots for selected day,
/// and options to block individual slots or block all day via confirmation bottom sheets.
class ProviderProfileAvailabilityScreen extends StatefulWidget {
  static const String routeName = '/provider/profile-availability';

  const ProviderProfileAvailabilityScreen({super.key});

  @override
  State<ProviderProfileAvailabilityScreen> createState() =>
      _ProviderProfileAvailabilityScreenState();
}

class _ProviderProfileAvailabilityScreenState
    extends State<ProviderProfileAvailabilityScreen> {
  int _selectedDay = 26;

  final List<_SlotInfo> _slots = [
    _SlotInfo(id: '1', timeRange: '1:00 pm – 2:00 pm'),
    _SlotInfo(id: '2', timeRange: '4:30 pm – 5:30 pm'),
    _SlotInfo(id: '3', timeRange: '3:00 pm – 4:00 pm'),
  ];

  void _onBlockSlotTap(_SlotInfo slot) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (ctx) => AppConfirmBottomSheet(
        icon: AppIcon(
          assetPath: AssetsPath.updateProfileIconInformation,
          size: ResponsiveHelper.iconSize(72),
        ),
        title: AppText.blockThisSlotExclaim,
        description: Text(
          AppText.areYouSureYouWantToBlockThisTimeSlot,
          textAlign: TextAlign.center,
          style: ctx.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
          ),
        ),
        confirmLabel: AppText.confirm,
        confirmColor: const Color(0xFF0F3E2E),
        onConfirm: () {
          setState(() {
            slot.isBlocked = true;
          });
        },
      ),
    );
  }

  void _onBlockAllDayTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (ctx) => AppConfirmBottomSheet(
        icon: AppIcon(
          assetPath: AssetsPath.updateProfileIconInformation,
          size: ResponsiveHelper.iconSize(72),
        ),
        title: AppText.blockFullDayExclaim,
        description: Text(
          AppText.areYouSureYouWantToBlockYourAvailabilityForEntireDay,
          textAlign: TextAlign.center,
          style: ctx.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
          ),
        ),
        confirmLabel: AppText.confirm,
        confirmColor: const Color(0xFF0F3E2E),
        onConfirm: () {
          setState(() {
            for (final slot in _slots) {
              slot.isBlocked = true;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopAppbar(
              title: AppText.availability,
              trailing: GestureDetector(
                onTap: () =>
                    context.push(ProviderSetAvailabilityScreen.routeName),
                child: Container(
                  width: ResponsiveHelper.width(40),
                  height: ResponsiveHelper.width(40),
                  decoration: BoxDecoration(
                    color: AppColors.brandSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    size: ResponsiveHelper.iconSize(18),
                    color: AppColors.brandPrimary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(20),
                  vertical: ResponsiveHelper.padding(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calendar card
                    _buildCalendarCard(),
                    SizedBox(height: ResponsiveHelper.spacing(20)),

                    // Selected Date Header
                    Text(
                      '${_selectedDay}th October 2025',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(16),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF14212B),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(14)),

                    // Time slots list
                    for (final slot in _slots) ...[
                      _buildSlotTile(slot),
                      SizedBox(height: ResponsiveHelper.spacing(12)),
                    ],

                    SizedBox(height: ResponsiveHelper.spacing(12)),

                    // Block All Day Button
                    AppButton(
                      text: AppText.blockAllDay,
                      onPressed: _onBlockAllDayTap,
                      width: double.infinity,
                      backgroundColor: const Color(0xFF0F3E2E),
                      textColor: AppColors.white,
                      radius: ResponsiveHelper.borderRadius(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.block_rounded,
                            size: ResponsiveHelper.iconSize(18),
                            color: AppColors.white,
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(8)),
                          Text(
                            AppText.blockAllDay,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(14),
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // 5 rows representing October 2025 layout matching screenshot:
    // Row 1: 31 (Sept), 1, 2, 3, 4, 5, 6
    // Row 2: 7, 8, 9, 10, 11, 12, 13
    // Row 3: 14, 15, 16, 17, 18, 19, 20
    // Row 4: 21, 22, 23, 24, 25, 26, 27
    // Row 5: 28, 29, 30, 31, 1, 2, 3
    final daysMatrix = [
      [
        _CalendarDay(day: 31, isCurrentMonth: false),
        _CalendarDay(day: 1),
        _CalendarDay(day: 2),
        _CalendarDay(day: 3),
        _CalendarDay(day: 4),
        _CalendarDay(day: 5),
        _CalendarDay(day: 6),
      ],
      [
        _CalendarDay(day: 7),
        _CalendarDay(day: 8),
        _CalendarDay(day: 9),
        _CalendarDay(day: 10),
        _CalendarDay(day: 11),
        _CalendarDay(day: 12),
        _CalendarDay(day: 13),
      ],
      [
        _CalendarDay(day: 14),
        _CalendarDay(day: 15),
        _CalendarDay(day: 16),
        _CalendarDay(day: 17, isToday: true),
        _CalendarDay(day: 18),
        _CalendarDay(day: 19),
        _CalendarDay(day: 20),
      ],
      [
        _CalendarDay(day: 21),
        _CalendarDay(day: 22),
        _CalendarDay(day: 23),
        _CalendarDay(day: 24),
        _CalendarDay(day: 25),
        _CalendarDay(day: 26),
        _CalendarDay(day: 27),
      ],
      [
        _CalendarDay(day: 28),
        _CalendarDay(day: 29),
        _CalendarDay(day: 30),
        _CalendarDay(day: 31),
        _CalendarDay(day: 1, isCurrentMonth: false),
        _CalendarDay(day: 2, isCurrentMonth: false),
        _CalendarDay(day: 3, isCurrentMonth: false),
      ],
    ];

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month navigation header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'October 2025',
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(15),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF14212B),
                ),
              ),
              Row(
                children: [
                  _circleNavButton(Icons.chevron_left),
                  SizedBox(width: ResponsiveHelper.spacing(8)),
                  _circleNavButton(Icons.chevron_right),
                ],
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.spacing(16)),

          // Weekdays header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekdays
                .map(
                  (d) => SizedBox(
                    width: ResponsiveHelper.width(36),
                    child: Center(
                      child: Text(
                        d,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(12),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF718096),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: ResponsiveHelper.spacing(12)),

          // Day rows
          for (final week in daysMatrix) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveHelper.padding(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: week.map((dayObj) {
                  final isSelected =
                      dayObj.isCurrentMonth && dayObj.day == _selectedDay;

                  return GestureDetector(
                    onTap: () {
                      if (dayObj.isCurrentMonth) {
                        setState(() {
                          _selectedDay = dayObj.day;
                        });
                      }
                    },
                    child: Container(
                      width: ResponsiveHelper.width(36),
                      height: ResponsiveHelper.width(36),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dayObj.isToday
                            ? const Color(0xFFF0F2F4)
                            : Colors.transparent,
                        border: isSelected
                            ? Border.all(
                                color: const Color(0xFF0F3E2E),
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: Text(
                        '${dayObj.day}',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(13),
                          fontWeight: isSelected || dayObj.isToday
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: !dayObj.isCurrentMonth
                              ? const Color(0xFFCBD5E0)
                              : const Color(0xFF14212B),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _circleNavButton(IconData icon) {
    return Container(
      width: ResponsiveHelper.width(28),
      height: ResponsiveHelper.width(28),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F9),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: ResponsiveHelper.iconSize(16),
        color: const Color(0xFF14212B),
      ),
    );
  }

  Widget _buildSlotTile(_SlotInfo slot) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(14),
        vertical: ResponsiveHelper.padding(14),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveHelper.width(42),
            height: ResponsiveHelper.width(42),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F5F4),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(10),
              ),
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: ResponsiveHelper.iconSize(18),
              color: const Color(0xFF0F3E2E),
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.timeRange,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(13),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF14212B),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(6)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.padding(10),
                    vertical: ResponsiveHelper.padding(4),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6F6),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(6),
                    ),
                  ),
                  child: Text(
                    slot.isBlocked ? 'Blocked' : AppText.available,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(12),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: slot.isBlocked
                          ? AppColors.red
                          : const Color(0xFF6A7D8E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.block_rounded,
              size: ResponsiveHelper.iconSize(22),
              color: slot.isBlocked
                  ? AppColors.red
                  : const Color(0xFF8C9BA5),
            ),
            onPressed: () => _onBlockSlotTap(slot),
          ),
        ],
      ),
    );
  }
}

class _CalendarDay {
  final int day;
  final bool isCurrentMonth;
  final bool isToday;

  _CalendarDay({
    required this.day,
    this.isCurrentMonth = true,
    this.isToday = false,
  });
}
