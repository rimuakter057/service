import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import '../../../../../core/utils/app_colors/app_colors.dart';
import '../../../../../core/utils/app_text/app_text.dart';

class BookingFilterOption {
  final String value;
  final String label;

  const BookingFilterOption({required this.value, required this.label});
}

/// Modal bottom sheet for filtering bookings by status (e.g. All Bookings,
/// Pending, Accepted, Scheduled, In Progress, Completed, Cancelled, Rejected, Disputed).
class BookingsFilterBottomSheet extends StatefulWidget {
  final String currentFilter;
  final ValueChanged<String> onApply;

  const BookingsFilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.onApply,
  });

  static const List<BookingFilterOption> filterOptions = [
    BookingFilterOption(value: 'all', label: AppText.allBookings),
    BookingFilterOption(value: 'pending', label: AppText.pending),
    BookingFilterOption(value: 'quoted', label: AppText.accepted),
    BookingFilterOption(value: 'scheduled', label: AppText.scheduled),
    BookingFilterOption(value: 'in_progress', label: AppText.inProgress),
    BookingFilterOption(value: 'completed', label: AppText.completed),
    BookingFilterOption(value: 'cancelled', label: AppText.cancelled),
    BookingFilterOption(value: 'rejected', label: AppText.rejected),
    BookingFilterOption(value: 'disputed', label: AppText.disputed),
  ];

  @override
  State<BookingsFilterBottomSheet> createState() =>
      _BookingsFilterBottomSheetState();
}

class _BookingsFilterBottomSheetState extends State<BookingsFilterBottomSheet> {
  late String _selectedGroup;

  @override
  void initState() {
    super.initState();
    _selectedGroup = _resolveInitialValue(widget.currentFilter);
  }

  String _resolveInitialValue(String current) {
    final trimmed = current.trim().toLowerCase();
    for (final opt in BookingsFilterBottomSheet.filterOptions) {
      if (opt.value.toLowerCase() == trimmed ||
          opt.label.toLowerCase() == trimmed) {
        return opt.value;
      }
    }
    return current.isNotEmpty ? current : 'all';
  }

  void _onReset() {
    setState(() {
      _selectedGroup = 'all';
    });
  }

  void _onApply() {
    widget.onApply(_selectedGroup);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final double radius = ResponsiveHelper.borderRadius(24);

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(20),
          vertical: ResponsiveHelper.padding(20),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title & Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppText.filter,
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: ResponsiveHelper.fontSize(18),
                    color: AppColors.textBlackPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: EdgeInsets.all(ResponsiveHelper.padding(4)),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 22,
                      color: AppColors.textBlackPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.spacing(16)),

            // Filter Options List (Exact 100% original design matching Figma)
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: BookingsFilterBottomSheet.filterOptions.map((option) {
                    final isSelected = option.value.toLowerCase() ==
                            _selectedGroup.toLowerCase() ||
                        option.label.toLowerCase() ==
                            _selectedGroup.toLowerCase();
                    return GestureDetector(
                      onTap: () => setState(() => _selectedGroup = option.value),
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: ResponsiveHelper.spacing(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.padding(16),
                          vertical: ResponsiveHelper.padding(14),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.borderDefault.withValues(
                            alpha: 0.25,
                          ),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              option.label,
                              style: context.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.textBlackPrimary,
                              ),
                            ),
                            _RadioCircle(isSelected: isSelected),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(16)),

            // Action Buttons: Reset & Apply (Exact 100% original colors, radius & height)
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: AppText.resetFilter,
                    onPressed: _onReset,
                    height: ResponsiveHelper.height(48),
                    backgroundColor: const Color(0xFFFFECEB),
                    borderColor: const Color(0xFFFCA5A5),
                    textColor: const Color(0xFFEF4444),
                    radius: ResponsiveHelper.borderRadius(12),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.spacing(12)),
                Expanded(
                  child: AppButton(
                    text: AppText.applyFilter,
                    onPressed: _onApply,
                    height: ResponsiveHelper.height(48),
                    backgroundColor: AppColors.brandPrimary,
                    textColor: AppColors.textOnPrimary,
                    radius: ResponsiveHelper.borderRadius(12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  final bool isSelected;

  const _RadioCircle({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveHelper.width(20),
      height: ResponsiveHelper.width(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? AppColors.brandPrimary
              : AppColors.textGrey.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: ResponsiveHelper.width(10),
                height: ResponsiveHelper.width(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.brandPrimary,
                ),
              ),
            )
          : null,
    );
  }
}
