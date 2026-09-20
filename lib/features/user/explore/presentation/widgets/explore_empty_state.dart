import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_calendar/app_calendar.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// "No results" state for Explore Provider — uses empty.svg and card design,
/// shown in place of [ExploreProviderGrid] whenever a search/filter turns
/// up no matching providers.
class ExploreEmptyState extends StatelessWidget {
  final DateTime? initialSelectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final String? message;
  final bool showCalendar;

  const ExploreEmptyState({
    super.key,
    this.initialSelectedDate,
    this.onDateSelected,
    this.message,
    this.showCalendar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showCalendar) ...[
          AppCalendar(
            initialSelectedDate: initialSelectedDate,
            onDateSelected: onDateSelected,
          ),
          SizedBox(height: ResponsiveHelper.spacing(20)),
        ],
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.padding(32),
            horizontal: ResponsiveHelper.padding(16),
          ),
          decoration: BoxDecoration(
            color: AppColors.borderDefault.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.borderRadius(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(
                assetPath: AssetsPath.emptyBox,
                width: ResponsiveHelper.width(64),
                height: ResponsiveHelper.height(41),
              ),
              SizedBox(height: ResponsiveHelper.spacing(14)),
              Text(
                message ?? AppText.weCouldntFindAnyMatches,
                style: context.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
