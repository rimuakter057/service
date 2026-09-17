import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_calendar/app_calendar.dart';
import 'package:nchito/features/common/common_widgets/app_time_slot_picker/app_time_slot_picker.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';

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

  void _onToggleSlot(int index) {
    setState(() {
      if (_selectedSlots.contains(index)) {
        _selectedSlots.remove(index);
      } else {
        _selectedSlots.add(index);
      }
    });
  }

  void _onConfirm() {
    if (context.canPop()) {
      context.pop();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reschedule proposal sent to customer!'),
        duration: Duration(seconds: 2),
      ),
    );
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
                    const AppCalendar(),
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
