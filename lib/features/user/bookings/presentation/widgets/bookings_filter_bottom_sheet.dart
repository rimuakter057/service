import 'package:flutter/material.dart';

import '../../../../../core/common_widgets/app_button/app_button.dart';
import '../../../../../core/extensions/context_extension/context_extension.dart';
import '../../../../../core/helper/responsive_helper/responsive_helper.dart';
import '../../../../../core/utils/app_colors/app_colors.dart';
import '../../../../../core/utils/app_text/app_text.dart';

/// Modal bottom sheet for filtering bookings by status (e.g. All Bookings,
/// Pending, Accepted, Scheduled, In Progress, Completed, etc.).
class BookingsFilterBottomSheet extends StatefulWidget {
  final String currentFilter;
  final ValueChanged<String> onApply;

  const BookingsFilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.onApply,
  });

  static const List<String> filterOptions = [
    AppText.allBookings,
    AppText.pending,
    AppText.accepted,
    AppText.scheduled,
    AppText.inProgress,
    AppText.completed,
    AppText.cancelled,
    AppText.rejected,
    AppText.disputed,
  ];

  @override
  State<BookingsFilterBottomSheet> createState() =>
      _BookingsFilterBottomSheetState();
}

class _BookingsFilterBottomSheetState extends State<BookingsFilterBottomSheet> {
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.currentFilter;
  }

  void _onReset() {
    setState(() => _selectedFilter = AppText.allBookings);
  }

  void _onApply() {
    widget.onApply(_selectedFilter);
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

            // Filter Options List
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: BookingsFilterBottomSheet.filterOptions
                      .map((option) {
                        final isSelected = option == _selectedFilter;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = option),
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
                                  option,
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
                      })
                      .toList(),
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(16)),

            // Action Buttons (Reset Filter & Apply Filter)
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
