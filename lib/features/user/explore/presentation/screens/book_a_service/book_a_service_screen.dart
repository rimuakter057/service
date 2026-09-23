import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_box_text_field/app_box_text_field.dart';
import 'package:nchito/features/common/common_widgets/app_confirm_bottom_sheet/app_confirm_bottom_sheet.dart';
import 'package:nchito/features/common/common_widgets/app_dropdown_field/app_dropdown_field.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/features/common/common_widgets/app_select_sheet/app_select_sheet.dart';
import 'package:nchito/features/user/bookings/data/models/booking_model.dart';
import 'package:nchito/features/user/bookings/data/repositories/booking_repository_impl.dart';
import 'package:nchito/features/user/bookings/presentation/providers/booking_notifier.dart';
import 'package:nchito/features/user/bookings/presentation/screens/booking_details/booking_details_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_details/provider_details_screen.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

const List<String> _defaultServiceTypeOptions = [
  'Electrical',
  'Gardening & Landscaping',
  'Cleaning',
  'Plumbing',
  'Moving & Relocation',
  'Painting & Decorating',
  'Beauty & Personal Care',
];

const Map<String, String> _knownCategoryNameToIdMap = {
  'Cleaning': '6a8e703141a4558c444a1e92',
  'Plumbing': '6a8e703141a4558c444a1e93',
  'Electrical': '6a8e703141a4558c444a1e94',
  'Gardening & Landscaping': '6a8e703141a4558c444a1e95',
  'Gardening': '6a8e703141a4558c444a1e95',
  'Home Maintenance': '6a8e703241a4558c444a1e96',
  'Painting & Decorating': '6a8e703241a4558c444a1e97',
  'Painting': '6a8e703241a4558c444a1e97',
  'Moving & Relocation': '6a8e703241a4558c444a1e98',
  'Moving': '6a8e703241a4558c444a1e98',
  'Beauty & Personal Care': '6a8e703241a4558c444a1e99',
  'Beauty': '6a8e703241a4558c444a1e99',
  'Personal Care': '6a8e703241a4558c444a1e99',
};

bool _isValidObjectId(String? str) {
  if (str == null || str.trim().length != 24) return false;
  return RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(str.trim());
}


class BookAServiceScreen extends StatefulWidget {
  static const String routeName = '/book-a-service';

  final HomeProviderData? provider;
  final String? selectedDate;
  final String? selectedSlot;
  final String? selectedTime;
  final String? providerId;

  const BookAServiceScreen({
    super.key,
    this.provider,
    this.selectedDate,
    this.selectedSlot,
    this.selectedTime,
    this.providerId,
  });

  @override
  State<BookAServiceScreen> createState() => _BookAServiceScreenState();
}

class _BookAServiceScreenState extends State<BookAServiceScreen> {
  String? _selectedServiceType;
  TimeOfDay? _selectedTimeOfDay;
  String? _selectedTime;
  String? _displayTimeText;
  String? _selectedDate;
  List<String> _serviceTypeOptions = _defaultServiceTypeOptions;
  final Map<String, String> _serviceTypeMap = {};

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  HomeProviderData get _provider => widget.provider ?? robertJuniorProvider;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _selectedDate = widget.selectedDate ??
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    if (widget.selectedTime != null && widget.selectedTime!.isNotEmpty) {
      _selectedTime = widget.selectedTime;
      final parts = _selectedTime!.split(':');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]) ?? 8;
        final minute = int.tryParse(parts[1]) ?? 0;
        _selectedTimeOfDay = TimeOfDay(hour: hour, minute: minute);
        final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        final ampm = hour >= 12 ? 'PM' : 'AM';
        _displayTimeText =
            '${h.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $ampm';
      }
    } else {
      _selectedTime = null;
      _displayTimeText = null;
    }

    _serviceTypeMap.addAll(_knownCategoryNameToIdMap);

    // Populate service type options from provider if available
    final providerServiceTypes = <String>[];
    if (widget.provider != null) {
      if (widget.provider!.tags.isNotEmpty) {
        for (final tag in widget.provider!.tags) {
          final label = tag.label.trim();
          if (label.isNotEmpty && !providerServiceTypes.contains(label)) {
            providerServiceTypes.add(label);
            if (tag.id != null && _isValidObjectId(tag.id)) {
              _serviceTypeMap[label] = tag.id!;
            }
          }
        }
      }
      if (widget.provider!.service.trim().isNotEmpty &&
          !providerServiceTypes.contains(widget.provider!.service.trim())) {
        providerServiceTypes.add(widget.provider!.service.trim());
        if (widget.provider!.serviceTypeId != null &&
            _isValidObjectId(widget.provider!.serviceTypeId)) {
          _serviceTypeMap[widget.provider!.service.trim()] =
              widget.provider!.serviceTypeId!;
        }
      }
    }

    if (providerServiceTypes.isNotEmpty) {
      _serviceTypeOptions = providerServiceTypes;
    } else {
      _serviceTypeOptions = _defaultServiceTypeOptions;
    }

    // Keep fields unselected/empty so placeholders/hint texts are shown initially
    _selectedServiceType = null;
    _locationController.text = '';
    _instructionsController.text = '';

    _loadBookingForm();
  }

  Future<void> _loadBookingForm() async {
    final providerId = widget.providerId ??
        _provider.id ??
        '6aae448a527875a24459c632';
    try {
      final response = await BookingRepositoryImpl().getBookingForm(providerId);
      final data = response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : response;
      final rawTypes = data['service_types'] as List<dynamic>?;
      if (rawTypes != null && rawTypes.isNotEmpty) {
        final names = <String>[];
        final newMap = <String, String>{};
        for (final item in rawTypes) {
          if (item is Map<String, dynamic>) {
            final id = item['id']?.toString() ?? '';
            final name = item['name']?.toString() ?? '';
            if (id.isNotEmpty && name.isNotEmpty) {
              if (!names.contains(name)) names.add(name);
              newMap[name] = id;
              newMap[id] = id;
            }
          }
        }
        if (names.isNotEmpty && mounted) {
          setState(() {
            _serviceTypeOptions = names;
            _serviceTypeMap.addAll(newMap);
          });
        }
      }
    } catch (_) {
      // Graceful fallback to existing tags and known category mappings
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _pickServiceType() async {
    final result = await AppSelectSheet.show(
      context,
      title: AppText.serviceType,
      options: _serviceTypeOptions,
      selected: _selectedServiceType,
    );
    if (result != null) setState(() => _selectedServiceType = result);
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTimeOfDay ?? now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.brandPrimary,
              onPrimary: Colors.white,
              onSurface: AppColors.textBlackPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTimeOfDay = picked;
        final hour = picked.hour.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        _selectedTime = '$hour:$minute:00';
        _displayTimeText = picked.format(context);
      });
    }
  }

  void _onPressedSubmit() {
    if (_selectedServiceType == null || _selectedServiceType!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a service type.'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (_selectedTime == null || _selectedTime!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose your preferred time.'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (_locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter service location.'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    _showConfirmationSheet();
  }

  Future<void> _submitBookingRequest() async {
    final providerId = widget.providerId ??
        _provider.id ??
        '6aae448a527875a24459c632';
    final selectedText = _selectedServiceType!.trim();

    // Resolve MongoDB ObjectId (must be a 24-character hexadecimal string)
    String resolvedServiceTypeId = '';

    if (_isValidObjectId(selectedText)) {
      resolvedServiceTypeId = selectedText.trim();
    } else if (_serviceTypeMap.containsKey(selectedText) &&
        _isValidObjectId(_serviceTypeMap[selectedText])) {
      resolvedServiceTypeId = _serviceTypeMap[selectedText]!;
    } else if (_knownCategoryNameToIdMap.containsKey(selectedText)) {
      resolvedServiceTypeId = _knownCategoryNameToIdMap[selectedText]!;
    } else if (widget.provider?.serviceTypeId != null &&
        _isValidObjectId(widget.provider!.serviceTypeId)) {
      resolvedServiceTypeId = widget.provider!.serviceTypeId!;
    } else {
      for (final entry in _serviceTypeMap.entries) {
        if (selectedText.toLowerCase().contains(entry.key.toLowerCase()) ||
            entry.key.toLowerCase().contains(selectedText.toLowerCase())) {
          if (_isValidObjectId(entry.value)) {
            resolvedServiceTypeId = entry.value;
            break;
          }
        }
      }
      if (resolvedServiceTypeId.isEmpty) {
        for (final entry in _knownCategoryNameToIdMap.entries) {
          if (selectedText.toLowerCase().contains(entry.key.toLowerCase()) ||
              entry.key.toLowerCase().contains(selectedText.toLowerCase())) {
            resolvedServiceTypeId = entry.value;
            break;
          }
        }
      }
    }

    if (resolvedServiceTypeId.isEmpty) {
      resolvedServiceTypeId = '6a8e703241a4558c444a1e99';
    }

    final scheduledDate = _selectedDate ??
        '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';

    final request = CreateBookingRequestModel(
      provider: providerId,
      serviceType: resolvedServiceTypeId,
      scheduledDate: scheduledDate,
      scheduledTime: _selectedTime!,
      locationText: _locationController.text.trim(),
      instructions: _instructionsController.text.trim(),
    );

    final bookingNotifier = context.read<BookingNotifier>();
    final result = await bookingNotifier.submitBooking(
      request: request,
      fallbackProvider: _provider,
    );

    if (!mounted) return;

    if (result != null) {
      context.pushReplacement(
        BookingDetailsScreen.routeName,
        extra: result,
      );
    } else {
      final error =
          bookingNotifier.errorMessage ?? 'Failed to submit booking request.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  void _showConfirmationSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => AppConfirmBottomSheet(
        icon: AppIcon(
          assetPath: AssetsPath.bookServiceIconInformationLarge,
          size: ResponsiveHelper.iconSize(60),
        ),
        title: AppText.readyToRequest,
        description: Text(
          AppText
              .pleaseReviewYourBookingDetailsBeforeSendingYourServiceRequestToTheProvider,
          textAlign: TextAlign.center,
          style: context.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        confirmColor: AppColors.brandPrimary,
        onConfirm: () {
          Navigator.of(sheetContext).pop();
          _submitBookingRequest();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.watch<BookingNotifier>().isSubmitting;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(16),
                vertical: ResponsiveHelper.padding(12),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: BgIcon(
                      assetPath: AssetsPath.providerDetailsIconBack,
                      bgSize: ResponsiveHelper.iconSize(44),
                      radius: ResponsiveHelper.borderRadius(22),
                      bgColor: AppColors.white,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        AppText.bookAService,
                        style: context.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlackPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.iconSize(44)),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(16),
                ),
                child: Container(
                  padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Provider Card
                      _ProviderCard(provider: _provider),
                      SizedBox(height: ResponsiveHelper.spacing(20)),

                      // Service Type Dropdown
                      AppDropdownField(
                        label: AppText.serviceType,
                        hint: AppText.selectServiceType,
                        value: _selectedServiceType,
                        onTap: _pickServiceType,
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(18)),

                      // Choose Your Time (Time Picker)
                      AppDropdownField(
                        label: 'Choose Your Time',
                        hint: 'Choose Your Preferred Time',
                        value: _displayTimeText,
                        onTap: _pickTime,
                        trailingIcon: Icon(
                          Icons.access_time_outlined,
                          color: AppColors.textGrey,
                          size: ResponsiveHelper.iconSize(20),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(18)),

                      // Service Location Field
                      AppBoxTextField(
                        label: AppText.serviceLocation,
                        hint: AppText.enterServiceAddress,
                        controller: _locationController,
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(18)),

                      // Booking Instructions Field
                      AppBoxTextField(
                        label: AppText.bookingInstructions,
                        hint: AppText
                            .egDescribeTheIssueAccessInstructionsOrSpecificRequirements,
                        controller: _instructionsController,
                        minLines: 4,
                        maxLines: 6,
                        trailing: AppIcon(
                          assetPath: AssetsPath.bookServiceIconResizeHandle,
                          size: ResponsiveHelper.iconSize(10),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(24)),

                      // Submit Request Button
                      SizedBox(
                        width: double.infinity,
                        height: ResponsiveHelper.height(52),
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : _onPressedSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandPrimary,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(12),
                              ),
                            ),
                          ),
                          child: isSubmitting
                              ? SizedBox(
                                  width: ResponsiveHelper.width(22),
                                  height: ResponsiveHelper.width(22),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.2,
                                  ),
                                )
                              : Text(
                                  AppText.submitRequest,
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(16),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(10)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final HomeProviderData provider;

  const _ProviderCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F4F1),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(14),
        ),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(10),
                ),
                child: provider.photo.startsWith('http')
                    ? Image.network(
                        provider.photo,
                        width: ResponsiveHelper.width(48),
                        height: ResponsiveHelper.height(48),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => AppIcon(
                          assetPath: AssetsPath.providerRobert,
                          width: ResponsiveHelper.width(48),
                          height: ResponsiveHelper.height(48),
                          fit: BoxFit.cover,
                        ),
                      )
                    : AppIcon(
                        assetPath: provider.photo.isNotEmpty
                            ? provider.photo
                            : AssetsPath.providerRobert,
                        width: ResponsiveHelper.width(48),
                        height: ResponsiveHelper.height(48),
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: AppIcon(
                  assetPath: AssetsPath.bookServiceIconVerifiedBadgeSmall,
                  size: ResponsiveHelper.iconSize(16),
                ),
              ),
            ],
          ),
          SizedBox(width: ResponsiveHelper.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.name,
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlackPrimary,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(4)),
                Row(
                  children: [
                    AppIcon(
                      assetPath: AssetsPath.bookServiceIconStarSmall,
                      size: ResponsiveHelper.iconSize(12),
                    ),
                    SizedBox(width: ResponsiveHelper.spacing(4)),
                    Text(
                      provider.rating,
                      style: context.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push(
              ProviderDetailsScreen.routeName,
              extra: provider,
            ),
            child: Container(
              width: ResponsiveHelper.width(36),
              height: ResponsiveHelper.height(36),
              decoration: BoxDecoration(
                color: const Color(0xFFDCE7FC),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(8),
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.remove_red_eye_outlined,
                size: ResponsiveHelper.iconSize(18),
                color: const Color(0xFF4C7CE5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
