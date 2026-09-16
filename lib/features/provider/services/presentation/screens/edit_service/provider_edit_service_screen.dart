import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_box_text_field/app_box_text_field.dart';
import 'package:nchito/features/common/common_widgets/app_dropdown_field/app_dropdown_field.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/features/provider/services/presentation/widgets/provider_services_sample_data.dart';
import 'package:nchito/features/provider/services/presentation/widgets/service_image_picker_row.dart';
import 'package:nchito/features/provider/services/presentation/widgets/service_type_select_bottom_sheet.dart';
import 'package:nchito/features/provider/services/presentation/widgets/update_service_confirm_bottom_sheet.dart';

/// Provider Edit Service Screen — allows modifying photos, service type,
/// starting price, estimated duration, service area, and description.
class ProviderEditServiceScreen extends StatefulWidget {
  static const String routeName = '/provider/edit-service';

  final ProviderServiceData service;

  const ProviderEditServiceScreen({
    super.key,
    required this.service,
  });

  @override
  State<ProviderEditServiceScreen> createState() =>
      _ProviderEditServiceScreenState();
}

class _ProviderEditServiceScreenState extends State<ProviderEditServiceScreen> {
  late final TextEditingController _priceController;
  late final TextEditingController _areaController;
  late final TextEditingController _descController;

  String? _selectedServiceType;
  String? _selectedDuration;

  @override
  void initState() {
    super.initState();
    _selectedServiceType = widget.service.service;
    _priceController = TextEditingController(text: widget.service.price);
    _areaController = TextEditingController(text: widget.service.area);
    _descController = TextEditingController(text: widget.service.description);
    _selectedDuration = '01:30 hrs';
  }

  @override
  void dispose() {
    _priceController.dispose();
    _areaController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onSelectServiceType() {
    ServiceTypeSelectBottomSheet.show(
      context,
      selected: _selectedServiceType,
      onSelected: (val) {
        setState(() {
          _selectedServiceType = val;
        });
      },
    );
  }

  Future<void> _onPickDuration() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 1, minute: 30),
    );

    if (picked != null) {
      setState(() {
        _selectedDuration =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')} hrs';
      });
    }
  }

  void _onSaveService() {
    UpdateServiceConfirmBottomSheet.show(
      context,
      onConfirm: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service updated successfully!'),
            backgroundColor: Color(0xFF0F3E2E),
            duration: Duration(seconds: 2),
          ),
        );
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(
              title: AppText.editService,
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
                    // Image Picker Row
                    const ServiceImagePickerRow(),
                    SizedBox(height: ResponsiveHelper.spacing(18)),

                    // Service Type Dropdown
                    AppDropdownField(
                      label: AppText.serviceType,
                      hint: AppText.selectServiceType,
                      value: _selectedServiceType,
                      onTap: _onSelectServiceType,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    // Service Price
                    AppBoxTextField(
                      label: AppText.servicePrice,
                      hint: AppText.enterYourStartingPrice,
                      controller: _priceController,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    // Enter estimated duration
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppText.enterEstimatedDuration,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(14),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlackPrimary,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(8)),
                        GestureDetector(
                          onTap: _onPickDuration,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveHelper.padding(16),
                              vertical: ResponsiveHelper.padding(16),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F4F1),
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedDuration ??
                                      AppText.selectAnAvailableTime,
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(14),
                                    fontWeight: FontWeight.w500,
                                    color: _selectedDuration != null
                                        ? AppColors.textBlackPrimary
                                        : AppColors.textGrey,
                                  ),
                                ),
                                Icon(
                                  Icons.access_time_rounded,
                                  size: ResponsiveHelper.iconSize(18),
                                  color: AppColors.textGrey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    // Service Area
                    AppBoxTextField(
                      label: AppText.serviceArea,
                      hint: AppText.enterYourServiceArea,
                      controller: _areaController,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    // Service Description
                    AppBoxTextField(
                      label: AppText.serviceDescription,
                      hint: AppText
                          .describeYourServiceAndWhatCustomersCanExpect,
                      controller: _descController,
                      minLines: 4,
                      maxLines: 6,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(24)),

                    // Update / Save Service Button
                    SizedBox(
                      width: double.infinity,
                      height: ResponsiveHelper.buttonHeight(48),
                      child: ElevatedButton(
                        onPressed: _onSaveService,
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
                          AppText.updateService,
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
}
