import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nchito/features/common/common_widgets/app_button/app_button.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_select_sheet/app_select_sheet.dart';
import 'package:nchito/features/common/common_widgets/app_text_field/app_text_field.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

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

const double _priceMin = 0;
const double _priceMax = 1000;

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
  RangeValues _priceRange = const RangeValues(0, 500);

  final TextEditingController _locationController = TextEditingController();
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController(
      text: _priceRange.start.round().toString(),
    );
    _maxPriceController = TextEditingController(
      text: _priceRange.end.round().toString(),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _onRangeChanged(RangeValues values) {
    setState(() {
      _priceRange = values;
      _minPriceController.text = values.start.round().toString();
      _maxPriceController.text = values.end.round().toString();
    });
  }

  void _onMinPriceChanged(String value) {
    final parsed = double.tryParse(value);
    if (parsed == null) return;
    final clamped = parsed.clamp(_priceMin, _priceRange.end);
    setState(() => _priceRange = RangeValues(clamped, _priceRange.end));
  }

  void _onMaxPriceChanged(String value) {
    final parsed = double.tryParse(value);
    if (parsed == null) return;
    final clamped = parsed.clamp(_priceRange.start, _priceMax);
    setState(() => _priceRange = RangeValues(_priceRange.start, clamped));
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
      _priceRange = const RangeValues(0, 500);
      _locationController.clear();
      _minPriceController.text = '0';
      _maxPriceController.text = '500';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.padding(24)),
        decoration: BoxDecoration(
          color: AppColors.bgApp,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ResponsiveHelper.borderRadius(24)),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppText.filter, style: context.labelMedium),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: AppIcon(
                      assetPath: AssetsPath.filterIconClose,
                      size: ResponsiveHelper.iconSize(20),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.spacing(4)),
              Text(
                AppText.refineServicesAndProvidersToFindTheRightMatch,
                style: context.bodyMedium,
              ),
              SizedBox(height: ResponsiveHelper.spacing(20)),

              _DropdownField(
                label: AppText.serviceType,
                hint: AppText.selectServiceType,
                value: _serviceType,
                onTap: _pickServiceType,
              ),
              SizedBox(height: ResponsiveHelper.spacing(20)),

              AppTextField(
                label: AppText.serviceLocation,
                hint: AppText.enterYourLocation,
                controller: _locationController,
              ),
              SizedBox(height: ResponsiveHelper.spacing(20)),

              _DropdownField(
                label: AppText.sortBy,
                hint: AppText.selectSortingPreference,
                value: _sortBy,
                onTap: _pickSortBy,
              ),
              SizedBox(height: ResponsiveHelper.spacing(20)),

              Text(AppText.priceRange, style: context.labelLarge),
              SizedBox(height: ResponsiveHelper.spacing(8)),
              Row(
                children: [
                  Expanded(
                    child: _PriceBox(
                      controller: _minPriceController,
                      onChanged: _onMinPriceChanged,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(8)),
                  AppIcon(
                    assetPath: AssetsPath.filterIconPriceRangeDash,
                    size: ResponsiveHelper.iconSize(12),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(8)),
                  Expanded(
                    child: _PriceBox(
                      controller: _maxPriceController,
                      onChanged: _onMaxPriceChanged,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.brandPrimary,
                  inactiveTrackColor: AppColors.borderDefault,
                  thumbColor: AppColors.brandPrimary,
                  overlayColor: AppColors.brandPrimary.withValues(alpha: 0.1),
                  rangeThumbShape: const RoundRangeSliderThumbShape(
                    enabledThumbRadius: 9,
                  ),
                ),
                child: RangeSlider(
                  min: _priceMin,
                  max: _priceMax,
                  values: _priceRange,
                  onChanged: _onRangeChanged,
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(12)),

              Text(AppText.minimumRating, style: context.labelLarge),
              SizedBox(height: ResponsiveHelper.spacing(8)),
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

              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: AppText.resetFilter,
                      onPressed: _onReset,
                      borderColor: AppColors.red400,
                      textColor: AppColors.red400,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(12)),
                  Expanded(
                    child: AppButton(
                      text: AppText.applyFilter,
                      onPressed: () => Navigator.of(context).pop(),
                      backgroundColor: AppColors.brandPrimary,
                      textColor: AppColors.textOnPrimary,
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

class _DropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final VoidCallback onTap;

  const _DropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.labelLarge),
        SizedBox(height: ResponsiveHelper.spacing(8)),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.padding(16),
              vertical: ResponsiveHelper.padding(16),
            ),
            decoration: BoxDecoration(
              color: AppColors.borderDefault.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value ?? hint,
                  style: context.bodyMedium.copyWith(
                    color: value != null
                        ? AppColors.textBlackPrimary
                        : AppColors.textGrey,
                  ),
                ),
                AppIcon(
                  assetPath: AssetsPath.filterIconDropdownChevron,
                  size: ResponsiveHelper.iconSize(16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PriceBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _PriceBox({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: onChanged,
      style: context.bodyMedium.copyWith(color: AppColors.textBlackPrimary),
      textAlign: TextAlign.center,
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
          vertical: ResponsiveHelper.padding(10),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandPrimary : AppColors.bgCard,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(20),
          ),
          border: Border.all(
            color: isSelected
                ? AppColors.brandPrimary
                : AppColors.borderDefault,
          ),
        ),
        child: Text(
          label,
          style: context.bodySmall.copyWith(
            color: isSelected
                ? AppColors.textOnPrimary
                : AppColors.textBlackPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
