import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_provider_card/app_provider_card.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

import 'explore_sample_data.dart';

/// 2-column grid of [AppProviderCard]s — the "results found" state of
/// Explore Provider.
class ExploreProviderGrid extends StatelessWidget {
  final List<ExploreProviderEntry> entries;
  final ValueChanged<HomeProviderData>? onProviderTap;
  final ValueChanged<HomeProviderData>? onBookNowTap;

  const ExploreProviderGrid({
    super.key,
    required this.entries,
    this.onProviderTap,
    this.onBookNowTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: ResponsiveHelper.spacing(10),
        crossAxisSpacing: ResponsiveHelper.spacing(10),
        childAspectRatio: onBookNowTap != null ? 170 / 262 : 170 / 226,
      ),
      itemBuilder: (context, index) {
        final entry = entries[index];
        final provider = entry.provider;
        return AppProviderCard(
          photo: provider.photo,
          name: provider.name,
          service: provider.service,
          price: provider.price,
          rating: provider.rating,
          badgeIconAsset: entry.badge.iconAsset,
          badgeBgColor: entry.badge.bgColor,
          badgeIconColor: entry.badge.iconColor,
          onTap: onProviderTap == null ? null : () => onProviderTap!(provider),
          onBookNow: onBookNowTap == null
              ? null
              : () => onBookNowTap!(provider),
        );
      },
    );
  }
}
