import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_box_text_field/app_box_text_field.dart';
import 'package:nchito/features/common/common_widgets/app_dropdown_field/app_dropdown_field.dart';
import 'package:nchito/features/common/common_widgets/app_select_sheet/app_select_sheet.dart';

const List<String> _serviceTypeOptions = [
  AppText.categoryCleaning,
  AppText.categoryPlumbing,
  AppText.categoryElectrical,
  AppText.serviceTypeGardeningLandscaping,
  AppText.serviceTypeHomeMaintenance,
  AppText.serviceTypePaintingDecorating,
  AppText.serviceTypeMovingRelocation,
  AppText.serviceTypeBeautyPersonalCare,
];

const List<String> _sortByOptions = [
  AppText.sortRecommended,
  AppText.sortHighestRated,
  AppText.sortLowestPrice,
  AppText.sortHighestPrice,
  AppText.sortNearestFirst,
];

const List<String> _ratingOptions = [
  AppText.anyRating,
  AppText.upTo1,
  AppText.upTo2,
  AppText.upTo3,
  AppText.upTo4,
  AppText.only1,
];

/// Filter modal opened from Explore Provider's filter button — Service
/// Type / Sort By pickers, Service Location, Price Range slider and
/// Minimum Rating chips.
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _serviceType;
  String? _sortBy;
  String _rating = AppText.anyRating;
  double _priceValue = 100;

  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickServiceType() async {
    final result = await AppSelectSheet.show(
      context,
      title: AppText.selectServiceType,
      options: _serviceTypeOptions,
      selected: _serviceType,
    );
    if (result != null) setState(() => _serviceType = result);
  }

  Future<void> _pickSortBy() async {
    final result = await AppSelectSheet.show(
      context,
      title: AppText.selectSortingPreference,
      options: _sortByOptions,
      selected: _sortBy,
    );
    if (result != null) setState(() => _sortBy = result);
  }

  void _onReset() {
    setState(() {
      _serviceType = null;
      _sortBy = null;
      _rating = AppText.anyRating;
      _priceValue = 100;
      _locationController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        ResponsiveHelper.padding(20),
        ResponsiveHelper.padding(20),
        ResponsiveHelper.padding(20),
        ResponsiveHelper.padding(24),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.borderRadius(24)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppText.filter,
                    style: context.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlackPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      size: ResponsiveHelper.iconSize(22),
                      color: AppColors.textBlackPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.spacing(4)),
              Text(
                AppText.refineServicesAndProvidersToFindTheRightMatch,
                style: context.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(20)),

              // Service Type
              AppDropdownField(
                label: AppText.serviceType,
                hint: AppText.selectServiceType,
                value: _serviceType,
                onTap: _pickServiceType,
              ),
              SizedBox(height: ResponsiveHelper.spacing(16)),

              // Service Location
              AppBoxTextField(
                label: AppText.serviceLocation,
                hint: AppText.enterYourLocation,
                controller: _locationController,
              ),
              SizedBox(height: ResponsiveHelper.spacing(16)),

              // Sort By
              AppDropdownField(
                label: AppText.sortBy,
                hint: AppText.selectSortingPreference,
                value: _sortBy,
                onTap: _pickSortBy,
              ),
              SizedBox(height: ResponsiveHelper.spacing(16)),

              // Price Range
              Text(
                AppText.priceRange,
                style: context.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlackPrimary,
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: ResponsiveHelper.width(76),
                    height: ResponsiveHelper.height(42),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F4F1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(8),
                      ),
                      border: Border.all(color: const Color(0xFFE2E7E3)),
                    ),
                    child: Text(
                      '0',
                      style: context.bodyMedium.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '»',
                    style: TextStyle(
                      color: AppColors.brandPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: ResponsiveHelper.width(76),
                    height: ResponsiveHelper.height(42),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F4F1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(8),
                      ),
                      border: Border.all(color: const Color(0xFFE2E7E3)),
                    ),
                    child: Text(
                      _priceValue.round().toString(),
                      style: context.bodyMedium.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: ResponsiveHelper.height(8),
                  activeTrackColor: const Color(0xFF5A7E6B),
                  inactiveTrackColor: const Color(0xFFE5EEE8),
                  thumbColor: AppColors.brandPrimary,
                  overlayColor: AppColors.brandPrimary.withValues(alpha: 0.1),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                    elevation: 0,
                  ),
                  trackShape: const RoundedRectSliderTrackShape(),
                ),
                child: Slider(
                  min: 0,
                  max: 100,
                  value: _priceValue,
                  onChanged: (val) => setState(() => _priceValue = val),
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(12)),

              // Minimum Rating
              Text(
                AppText.minimumRating,
                style: context.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlackPrimary,
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(10)),
              Wrap(
                spacing: ResponsiveHelper.spacing(8),
                runSpacing: ResponsiveHelper.spacing(8),
                children: _ratingOptions
                    .map(
                      (option) => _RatingChip(
                        label: option,
                        isSelected: option == _rating,
                        onTap: () => setState(() => _rating = option),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: ResponsiveHelper.spacing(24)),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _onReset,
                      child: Container(
                        height: ResponsiveHelper.height(50),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE8E8),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(12),
                          ),
                          border: Border.all(
                            color: const Color(0xFFE05252),
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          AppText.resetFilter,
                          style: context.labelLarge.copyWith(
                            color: const Color(0xFFD64545),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(12)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: ResponsiveHelper.height(50),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.brandPrimary,
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(12),
                          ),
                        ),
                        child: Text(
                          AppText.applyFilter,
                          style: context.labelLarge.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _RatingChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RatingChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(14),
          vertical: ResponsiveHelper.padding(8),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(10),
          ),
          border: Border.all(
            color: isSelected
                ? AppColors.brandPrimary
                : const Color(0xFFB0B7B3),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: context.bodySmall.copyWith(
            color: isSelected
                ? AppColors.brandPrimary
                : const Color(0xFF7D8782),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
