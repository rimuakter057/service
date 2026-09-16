import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';

/// Bottom sheet dialog to select a Service Type with radio indicators.
class ServiceTypeSelectBottomSheet extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String> onSelected;

  const ServiceTypeSelectBottomSheet({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  static const List<String> serviceTypes = [
    'Cleaning',
    'Plumbing',
    'Electrical',
    'Gardening & Landscaping',
    'Home Maintenance',
    'Painting & Decorating',
    'Moving & Relocation',
    'Beauty & Personal Care',
  ];

  static Future<void> show(
    BuildContext context, {
    required String? selected,
    required ValueChanged<String> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ServiceTypeSelectBottomSheet(
        selectedType: selected,
        onSelected: (val) {
          onSelected(val);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.borderRadius(24)),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(20),
        vertical: ResponsiveHelper.padding(16),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: ResponsiveHelper.width(40),
                height: ResponsiveHelper.height(4),
                margin: EdgeInsets.only(
                  bottom: ResponsiveHelper.spacing(16),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E7EC),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(2),
                  ),
                ),
              ),
            ),
            Text(
              AppText.serviceType,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(16),
                fontWeight: FontWeight.w700,
                color: AppColors.textBlackPrimary,
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(12)),
            ...serviceTypes.asMap().entries.map((entry) {
              final index = entry.key;
              final type = entry.value;
              final isSelected = type == selectedType;

              return Column(
                children: [
                  InkWell(
                    onTap: () => onSelected(type),
                    splashColor: AppColors.brandSoft,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveHelper.padding(14),
                        horizontal: ResponsiveHelper.padding(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            type,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(14.5),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.textBlackPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          Container(
                            width: ResponsiveHelper.width(22),
                            height: ResponsiveHelper.width(22),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF0F3E2E)
                                    : const Color(0xFFD0D5DD),
                                width: isSelected ? 2 : 1.5,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: ResponsiveHelper.width(10),
                                      height: ResponsiveHelper.width(10),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF0F3E2E),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (index < serviceTypes.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF2F4F7),
                    ),
                ],
              );
            }),
            SizedBox(height: ResponsiveHelper.spacing(8)),
          ],
        ),
      ),
    );
  }
}
