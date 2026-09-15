import 'package:flutter/material.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

/// Section title row used above list/grid sections (e.g. "Popular Near
/// You" with a "View all" action). Pass [onViewAllTap] to show the action.
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAllTap;
  final String? actionLabel;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAllTap,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: context.labelMedium),
        if (onViewAllTap != null)
          GestureDetector(
            onTap: onViewAllTap,
            child: Text(
              actionLabel ?? AppText.viewAll,
              style: context.bodyMedium.copyWith(
                color: AppColors.blueStatusInfo,
              ),
            ),
          ),
      ],
    );
  }
}
