import 'package:flutter/material.dart';

import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';

/// Reusable boxed text input field with a label above, #F6F4F1 background container,
/// borderless TextField, and support for optional trailing widget (e.g. resize handle)
/// and multi-line inputs. Used in FilterBottomSheet, BookAServiceScreen, etc.
class AppBoxTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int? minLines;
  final int maxLines;
  final TextInputType keyboardType;
  final Widget? trailing;

  const AppBoxTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.minLines,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.trailing,
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
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF6F4F1),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.borderRadius(12),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.padding(16),
            vertical: minLines != null && minLines! > 1
                ? ResponsiveHelper.padding(12)
                : 0,
          ),
          child: Stack(
            children: [
              TextField(
                controller: controller,
                minLines: minLines,
                maxLines: maxLines,
                keyboardType: keyboardType,
                style: context.bodyMedium.copyWith(
                  color: AppColors.textBlackPrimary,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: context.bodyMedium.copyWith(
                    color: AppColors.textGrey,
                    height: minLines != null && minLines! > 1 ? 1.4 : null,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: ResponsiveHelper.padding(16),
                  ),
                ),
              ),
              if (trailing != null)
                Positioned(
                  right: 0,
                  bottom: ResponsiveHelper.padding(8),
                  child: trailing!,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
