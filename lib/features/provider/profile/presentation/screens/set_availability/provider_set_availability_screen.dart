import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_confirm_bottom_sheet/app_confirm_bottom_sheet.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';

/// Day availability model
class _DayAvailability {
  final String dayName;
  bool isEnabled;
  TimeOfDay fromTime;
  TimeOfDay untilTime;

  _DayAvailability({
    required this.dayName,
    required this.isEnabled,
    required this.fromTime,
    required this.untilTime,
  });

  String formatTime(BuildContext context, TimeOfDay time) {
    return time.format(context);
  }
}

/// Provider Set Availability Screen — allows configuring working days,
/// from/until working hours with time pickers, work interval break time,
/// and cancellation policy terms.
class ProviderSetAvailabilityScreen extends StatefulWidget {
  static const String routeName = '/provider/set-availability';

  const ProviderSetAvailabilityScreen({super.key});

  @override
  State<ProviderSetAvailabilityScreen> createState() =>
      _ProviderSetAvailabilityScreenState();
}

class _ProviderSetAvailabilityScreenState
    extends State<ProviderSetAvailabilityScreen> {
  final TextEditingController _intervalController = TextEditingController();

  late final List<_DayAvailability> _days;

  @override
  void initState() {
    super.initState();
    _days = [
      _DayAvailability(
        dayName: 'Saturday',
        isEnabled: false,
        fromTime: const TimeOfDay(hour: 0, minute: 0),
        untilTime: const TimeOfDay(hour: 12, minute: 0),
      ),
      _DayAvailability(
        dayName: 'Sunday',
        isEnabled: true,
        fromTime: const TimeOfDay(hour: 0, minute: 0),
        untilTime: const TimeOfDay(hour: 12, minute: 0),
      ),
      _DayAvailability(
        dayName: 'Monday',
        isEnabled: true,
        fromTime: const TimeOfDay(hour: 0, minute: 0),
        untilTime: const TimeOfDay(hour: 12, minute: 0),
      ),
      _DayAvailability(
        dayName: 'Tuesday',
        isEnabled: true,
        fromTime: const TimeOfDay(hour: 0, minute: 0),
        untilTime: const TimeOfDay(hour: 12, minute: 0),
      ),
      _DayAvailability(
        dayName: 'Wednesday',
        isEnabled: true,
        fromTime: const TimeOfDay(hour: 0, minute: 0),
        untilTime: const TimeOfDay(hour: 12, minute: 0),
      ),
      _DayAvailability(
        dayName: 'Thursday',
        isEnabled: true,
        fromTime: const TimeOfDay(hour: 0, minute: 0),
        untilTime: const TimeOfDay(hour: 12, minute: 0),
      ),
      _DayAvailability(
        dayName: 'Friday',
        isEnabled: true,
        fromTime: const TimeOfDay(hour: 0, minute: 0),
        untilTime: const TimeOfDay(hour: 12, minute: 0),
      ),
    ];
  }

  @override
  void dispose() {
    _intervalController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(
    BuildContext context,
    _DayAvailability day,
    bool isFromTime,
  ) async {
    final initial = isFromTime ? day.fromTime : day.untilTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );

    if (picked != null) {
      setState(() {
        if (isFromTime) {
          day.fromTime = picked;
        } else {
          day.untilTime = picked;
        }
      });
    }
  }

  void _onSaveAvailabilityTap() {
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
        title: AppText.saveAvailabilityExclaim,
        description: Text(
          AppText.areYouSureYouWantToSaveYourAvailability,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.fontSize(13.5),
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        confirmLabel: AppText.confirm,
        confirmColor: const Color(0xFF0F3E2E),
        onConfirm: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Availability saved successfully!'),
              backgroundColor: Color(0xFF0F3E2E),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context);
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
            const TopAppbar(
              title: AppText.setAvailability,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(20),
                  vertical: ResponsiveHelper.padding(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._days.map(_buildDayRow),
                    SizedBox(height: ResponsiveHelper.spacing(16)),
                    // Work Interval Section
                    Text(
                      AppText.workInterval,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(8)),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8F9),
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(12),
                        ),
                      ),
                      child: TextField(
                        controller: _intervalController,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(13),
                          color: AppColors.textBlackPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: AppText.enterBreakTimeBetweenBookings,
                          hintStyle: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(13),
                            color: AppColors.textGrey,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.padding(16),
                            vertical: ResponsiveHelper.padding(14),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(14)),
                    // Cancellation Notice
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: ResponsiveHelper.padding(2),
                            right: ResponsiveHelper.padding(8),
                          ),
                          child: Icon(
                            Icons.error_outline_rounded,
                            color: const Color(0xFFEF4444),
                            size: ResponsiveHelper.iconSize(16),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppText.setAvailabilityCancellationNotice,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(11),
                              fontStyle: FontStyle.italic,
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),
                    // Save Availability Button
                    SizedBox(
                      width: double.infinity,
                      height: ResponsiveHelper.buttonHeight(48),
                      child: ElevatedButton(
                        onPressed: _onSaveAvailabilityTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F3E2E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(12),
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          AppText.saveAvailability,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(15),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
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

  Widget _buildDayRow(_DayAvailability day) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.spacing(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day name and toggle switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day.dayName,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(15),
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textBlackPrimary,
                ),
              ),
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: day.isEnabled,
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF0F3E2E),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFD0D5DD),
                  trackOutlineColor:
                      WidgetStateProperty.all(Colors.transparent),
                  onChanged: (val) {
                    setState(() {
                      day.isEnabled = val;
                    });
                  },
                ),
              ),
            ],
          ),
          if (day.isEnabled) ...[
            SizedBox(height: ResponsiveHelper.spacing(8)),
            Row(
              children: [
                // From Box
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppText.from,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(12.5),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlackPrimary,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(6)),
                      GestureDetector(
                        onTap: () => _pickTime(context, day, true),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.padding(14),
                            vertical: ResponsiveHelper.padding(12),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F8F9),
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                day.formatTime(context, day.fromTime),
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(13),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Icon(
                                Icons.access_time_rounded,
                                size: ResponsiveHelper.iconSize(16),
                                color: AppColors.textGrey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ResponsiveHelper.width(14)),
                // Until Box
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppText.until,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(12.5),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlackPrimary,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(6)),
                      GestureDetector(
                        onTap: () => _pickTime(context, day, false),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.padding(14),
                            vertical: ResponsiveHelper.padding(12),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F8F9),
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                day.formatTime(context, day.untilTime),
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(13),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Icon(
                                Icons.access_time_rounded,
                                size: ResponsiveHelper.iconSize(16),
                                color: AppColors.textGrey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
