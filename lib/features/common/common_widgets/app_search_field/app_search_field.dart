import 'package:flutter/material.dart';

import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import '../app_icon/app_icon.dart';

/// Search input — a search icon, hint text, and rounded fill.
class AppSearchField extends StatelessWidget {
  final String hint;
  final String searchIconAsset;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const AppSearchField({
    super.key,
    required this.hint,
    required this.searchIconAsset,
    this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final double radiusValue = ResponsiveHelper.borderRadius(12);

    return TextField(
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      style: context.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.bgCard,

        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(16),
        ),
        suffixIcon: ClipRRect(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(radiusValue),
          ),
          child: Container(
            color: AppColors.brandSoft,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
              child: AppIcon(
                assetPath: searchIconAsset,
                size: ResponsiveHelper.iconSize(18),
                color: AppColors.textGrey,
              ),
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusValue),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusValue),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusValue),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}