import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';

/// Custom empty state card for Provider My Services screen.
/// Displays briefcase icon, "No Services Yet" title, guidance text,
/// and an "Add Service" call-to-action button.
class MyServicesEmptyCard extends StatelessWidget {
  final VoidCallback onAddService;

  const MyServicesEmptyCard({
    super.key,
    required this.onAddService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(20),
        vertical: ResponsiveHelper.padding(28),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Briefcase icon container
          Container(
            width: ResponsiveHelper.width(56),
            height: ResponsiveHelper.width(56),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5EF),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(14),
              ),
            ),
            child: Icon(
              Icons.business_center_outlined,
              size: ResponsiveHelper.iconSize(26),
              color: const Color(0xFF0F3E2E),
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(16)),

          // Title
          Text(
            AppText.noServicesYet,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(18),
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: AppColors.textBlackPrimary,
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(10)),

          // Description
          Text(
            AppText
                .youHaventAddedAnyServicesToYourProfileYetCreateYourFirstServiceToStartReceivingBookingRequests,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(13),
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(20)),

          // Add Service Button
          ElevatedButton(
            onPressed: onAddService,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3E2E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(12),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(36),
                vertical: ResponsiveHelper.padding(13),
              ),
              elevation: 0,
            ),
            child: Text(
              AppText.addService,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(14.5),
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
