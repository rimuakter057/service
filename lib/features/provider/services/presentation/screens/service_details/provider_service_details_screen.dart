import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_detail_field/app_detail_field.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/features/provider/services/presentation/widgets/delete_service_confirm_bottom_sheet.dart';
import 'package:nchito/features/provider/services/presentation/widgets/provider_services_sample_data.dart';
import 'package:nchito/features/provider/services/presentation/widgets/update_service_confirm_bottom_sheet.dart';

/// Provider Service Details Screen — displays full service info, price, area,
/// category tag, description, reviews, jobs count, and delete/edit actions.
class ProviderServiceDetailsScreen extends StatelessWidget {
  static const String routeName = '/provider/service-details';

  final ProviderServiceData service;

  const ProviderServiceDetailsScreen({
    super.key,
    required this.service,
  });

  void _onDeleteService(BuildContext context) {
    DeleteServiceConfirmBottomSheet.show(
      context,
      onConfirm: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service deleted successfully!'),
            backgroundColor: Color(0xFFD93F3F),
            duration: Duration(seconds: 2),
          ),
        );
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  void _onEditService(BuildContext context) {
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldColor = const Color(0xFFF7F8F9);
    final fieldRadius = ResponsiveHelper.borderRadius(14);
    final fieldPadding = EdgeInsets.symmetric(
      horizontal: ResponsiveHelper.padding(16),
      vertical: ResponsiveHelper.padding(14),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(
              title: AppText.providerDetails,
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
                    // Provider photo thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(16),
                      ),
                      child: Image.asset(
                        service.photo,
                        width: ResponsiveHelper.width(110),
                        height: ResponsiveHelper.height(100),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: ResponsiveHelper.width(110),
                          height: ResponsiveHelper.height(100),
                          color: AppColors.brandSoft,
                          child: Icon(
                            Icons.person,
                            color: AppColors.brandPrimary,
                            size: ResponsiveHelper.iconSize(40),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    // Service Price
                    AppDetailField(
                      label: AppText.servicePrice,
                      value: service.price,
                      color: fieldColor,
                      radius: fieldRadius,
                      contentPadding: fieldPadding,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // Service Area
                    AppDetailField(
                      label: AppText.serviceArea,
                      value: service.area,
                      color: fieldColor,
                      radius: fieldRadius,
                      contentPadding: fieldPadding,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // Service Type
                    AppDetailField(
                      label: AppText.serviceType,
                      color: fieldColor,
                      radius: fieldRadius,
                      contentPadding: fieldPadding,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.padding(12),
                          vertical: ResponsiveHelper.padding(6),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF0F2),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(20),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bolt,
                              size: ResponsiveHelper.iconSize(14),
                              color: const Color(0xFFFFA726),
                            ),
                            SizedBox(width: ResponsiveHelper.spacing(6)),
                            Text(
                              service.service,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(12),
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBlackPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // Service Description
                    AppDetailField(
                      label: AppText.serviceDescription,
                      color: fieldColor,
                      radius: fieldRadius,
                      contentPadding: fieldPadding,
                      child: Text(
                        service.description,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(13),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlackPrimary,
                          height: 1.4,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // Reviews
                    AppDetailField(
                      label: AppText.reviews,
                      color: fieldColor,
                      radius: fieldRadius,
                      contentPadding: fieldPadding,
                      trailing: Container(
                        width: ResponsiveHelper.width(32),
                        height: ResponsiveHelper.width(32),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0EDFB),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(8),
                          ),
                        ),
                        child: Icon(
                          Icons.remove_red_eye_outlined,
                          size: ResponsiveHelper.iconSize(18),
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: ResponsiveHelper.iconSize(16),
                            color: const Color(0xFFFFA726),
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(4)),
                          Text(
                            '${service.rating} (${service.reviewCount})',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(13.5),
                              fontWeight: FontWeight.w700,
                              color: AppColors.textBlackPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    // Total Jobs Completed
                    AppDetailField(
                      label: AppText.totalJobsCompleted,
                      value: service.totalJobs,
                      color: fieldColor,
                      radius: fieldRadius,
                      contentPadding: fieldPadding,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),

                    // Action Buttons Row (Delete Service / Edit Service)
                    Row(
                      children: [
                        // Delete Service Button
                        Expanded(
                          child: SizedBox(
                            height: ResponsiveHelper.buttonHeight(46),
                            child: ElevatedButton.icon(
                              onPressed: () => _onDeleteService(context),
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                size: ResponsiveHelper.iconSize(18),
                                color: Colors.white,
                              ),
                              label: Text(
                                AppText.deleteService,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(13.5),
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD93F3F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.borderRadius(12),
                                  ),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(12)),

                        // Edit Service Button
                        Expanded(
                          child: SizedBox(
                            height: ResponsiveHelper.buttonHeight(46),
                            child: ElevatedButton.icon(
                              onPressed: () => _onEditService(context),
                              icon: Icon(
                                Icons.edit_outlined,
                                size: ResponsiveHelper.iconSize(18),
                                color: Colors.white,
                              ),
                              label: Text(
                                AppText.editService,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(13.5),
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F3E2E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.borderRadius(12),
                                  ),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ),
                      ],
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
