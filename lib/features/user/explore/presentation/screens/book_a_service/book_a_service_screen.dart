import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
import 'package:nchito/features/user/bookings/presentation/screens/booking_confirmed/booking_confirmed_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_details/provider_details_screen.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

const List<String> _serviceTypeOptions = [
  'Electrical',
  'Moving',
  'Painting',
];

const List<String> _availableSlotOptions = [
  '8:00 AM – 10:00 AM',
  '10:30 AM – 12:30 PM',
  '1:00 PM – 3:00 PM',
  '3:30 PM – 5:30 PM',
];

class BookAServiceScreen extends StatefulWidget {
  static const String routeName = '/book-a-service';

  final HomeProviderData? provider;

  const BookAServiceScreen({super.key, this.provider});

  @override
  State<BookAServiceScreen> createState() => _BookAServiceScreenState();
}

class _BookAServiceScreenState extends State<BookAServiceScreen> {
  String? _selectedServiceType;
  String? _selectedSlot;

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  HomeProviderData get _provider => widget.provider ?? robertJuniorProvider;

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
    if (result != null) setState(() => _selectedSlot = result);
  }

  void _showConfirmationSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AppConfirmBottomSheet(
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
        onConfirm: () => context.push(BookingConfirmedScreen.routeName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      ElevatedButton(
                        onPressed: _showConfirmationSheet,
                        child: const Text(AppText.submitRequest),
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
                child: AppIcon(
                  assetPath: provider.photo,
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
