import 'package:flutter/material.dart';

import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';

/// Generic "pick one from a list" bottom sheet — pass a [title] and
/// [options], tapping one immediately pops the sheet with that value.
/// Used for the Filter modal's Service Type and Sort By pickers.
class AppSelectSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selected;

  const AppSelectSheet({
    super.key,
    required this.title,
    required this.options,
    this.selected,
  });

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required List<String> options,
    String? selected,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) =>
          AppSelectSheet(title: title, options: options, selected: selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: ResponsiveHelper.height(80)),
        padding: EdgeInsets.all(ResponsiveHelper.padding(24)),
        decoration: BoxDecoration(
          color: AppColors.bgApp,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ResponsiveHelper.borderRadius(24)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.labelMedium),
            SizedBox(height: ResponsiveHelper.spacing(16)),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, _) =>
                    SizedBox(height: ResponsiveHelper.spacing(12)),
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option == selected;
                  return _SelectOptionTile(
                    label: option,
                    isSelected: isSelected,
                    onTap: () => Navigator.of(context).pop(option),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(16),
          vertical: ResponsiveHelper.padding(14),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandSoft : AppColors.bgCard,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(12),
          ),
          border: Border.all(
            color: isSelected
                ? AppColors.brandPrimary
                : AppColors.borderDefault,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: context.bodyLarge),
            Container(
              width: ResponsiveHelper.width(20),
              height: ResponsiveHelper.width(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.brandPrimary : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.brandPrimary
                      : AppColors.textGrey,
                  width: ResponsiveHelper.borderWidth(1.5),
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: ResponsiveHelper.iconSize(14),
                      color: AppColors.textOnPrimary,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
