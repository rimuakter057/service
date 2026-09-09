import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_calendar/app_calendar.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// "No results" state for Explore Provider — a date picker plus a message,
/// shown in place of [ExploreProviderGrid] whenever a search/filter turns
/// up no matching providers.
class ExploreEmptyState extends StatelessWidget {
  final DateTime? initialSelectedDate;
  final ValueChanged<DateTime>? onDateSelected;

  const ExploreEmptyState({
    super.key,
    this.initialSelectedDate,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCalendar(
          initialSelectedDate: initialSelectedDate,
          onDateSelected: onDateSelected,
        ),
        SizedBox(height: ResponsiveHelper.spacing(20)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.padding(32),
          ),
          decoration: BoxDecoration(
            color: AppColors.borderDefault.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.borderRadius(16),
            ),
          ),
          child: Column(
            children: [
              AppIcon(
                assetPath: AssetsPath.exploreProviderIllustrationNoResults,
                size: ResponsiveHelper.width(56),
              ),
              SizedBox(height: ResponsiveHelper.spacing(12)),
              Text(AppText.weCouldntFindAnyMatches, style: context.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
