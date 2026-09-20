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
];

const List<String> _availableSlotOptions = [
  '8:00 AM – 10:00 AM',
  '10:30 AM – 12:30 PM',
  '1:00 PM – 3:00 PM',
  '3:30 PM – 5:30 PM',
];

const Map<String, String> _slotToTimeMap = {
  '8:00 AM – 10:00 AM': '08:00:00',
  '10:30 AM – 12:30 PM': '10:30:00',
  '1:00 PM – 3:00 PM': '13:00:00',
  '3:30 PM – 5:30 PM': '15:30:00',
};

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
  String? _selectedSlot;
  String? _selectedTime;
  String? _selectedDate;
  List<String> _serviceTypeOptions = _defaultServiceTypeOptions;

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  HomeProviderData get _provider => widget.provider ?? robertJuniorProvider;

  @override
  void initState() {
    super.initState();
    _selectedSlot = widget.selectedSlot ?? _availableSlotOptions.first;
    _selectedTime = widget.selectedTime ??
        _slotToTimeMap[_selectedSlot] ??
        '08:00:00';

    final now = DateTime.now();
    _selectedDate = widget.selectedDate ??
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // Populate service type options from provider if available
    final providerServiceTypes = <String>[];
    if (widget.provider != null) {
      if (widget.provider!.tags.isNotEmpty) {
        for (final tag in widget.provider!.tags) {
          final label = tag.label.trim();
          if (label.isNotEmpty && !providerServiceTypes.contains(label)) {
            providerServiceTypes.add(label);
          }
        }
      }
      if (widget.provider!.service.trim().isNotEmpty &&
          !providerServiceTypes.contains(widget.provider!.service.trim())) {
        providerServiceTypes.add(widget.provider!.service.trim());
      }
    }

    if (providerServiceTypes.isNotEmpty) {
      _serviceTypeOptions = providerServiceTypes;
      _selectedServiceType = providerServiceTypes.first;
    } else {
      _serviceTypeOptions = _defaultServiceTypeOptions;
      _selectedServiceType = _serviceTypeOptions.first;
    }

    if (widget.provider != null && widget.provider!.area.isNotEmpty) {
      _locationController.text = widget.provider!.area;
    } else {
      _locationController.text = '12 Kabulonga Road, Lusaka';
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

  Future<void> _pickAvailableSlot() async {
    final result = await AppSelectSheet.show(
      context,
      title: AppText.availableSlot,
      options: _availableSlotOptions,
      selected: _selectedSlot,
    );
    if (result != null) {
      setState(() {
        _selectedSlot = result;
        _selectedTime = _slotToTimeMap[result] ?? '08:00:00';
      });
    }
  }

  Future<void> _submitBookingRequest() async {
    final providerId = widget.providerId ??
        _provider.id ??
        '6aae448a527875a24459c632';
    final selectedServiceText = (_selectedServiceType != null &&
            _selectedServiceType!.trim().isNotEmpty)
        ? _selectedServiceType!.trim()
        : (_serviceTypeOptions.isNotEmpty
            ? _serviceTypeOptions.first
            : 'Moving & Relocation');
    final scheduledDate = _selectedDate ??
        '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
    final scheduledTime = _selectedTime ??
        _slotToTimeMap[_selectedSlot] ??
        '08:00:00';
    final location = _locationController.text.trim().isNotEmpty
        ? _locationController.text.trim()
        : '12 Kabulonga Road, Lusaka';
    final instructions = _instructionsController.text.trim().isNotEmpty
        ? _instructionsController.text.trim()
        : 'Service request booking sent. Waiting for quote.';

    final request = CreateBookingRequestModel(
      provider: providerId,
      serviceType: selectedServiceText,
      scheduledDate: scheduledDate,
      scheduledTime: scheduledTime,
      locationText: location,
      instructions: instructions,
    );

    final bookingNotifier = context.read<BookingNotifier>();
    final result = await bookingNotifier.submitBooking(
      request: request,
      fallbackProvider: _provider,
    );

    if (!mounted) return;

    if (result != null) {
      // Navigate directly to booking details with the API response data as requested
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

                      // Available Slot Dropdown
                      AppDropdownField(
                        label: AppText.availableSlot,
                        hint: AppText.selectAvailableSlot,
                        value: _selectedSlot,
                        onTap: _pickAvailableSlot,
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
                          onPressed: isSubmitting ? null : _showConfirmationSheet,
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
