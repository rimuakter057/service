import 'package:flutter/material.dart';

import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';

/// Reusable dropdown/picker field with label above and a rounded container below
/// displaying the selected value (or hint) with a chevron down icon.
/// Used across FilterBottomSheet, BookAServiceScreen, and other form screens.
class AppDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final VoidCallback onTap;

  const AppDropdownField({
    super.key,
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
        Text(
          label,
          style: context.labelLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textBlackPrimary,
          ),
        ),
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
              color: const Color(0xFFF6F4F1),
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textGrey,
                  size: ResponsiveHelper.iconSize(22),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
