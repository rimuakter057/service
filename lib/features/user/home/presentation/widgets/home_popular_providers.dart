import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_provider_card/app_provider_card.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/user/explore/presentation/widgets/explore_sample_data.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_details/provider_details_screen.dart';

/// Horizontal-scrolling "Popular Near You" provider list on Home.
/// Uses the same [exploreProviderResults] data (with badge) as the Explore screen.
class HomePopularProviders extends StatelessWidget {
  const HomePopularProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.height(250),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: exploreProviderResults.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: ResponsiveHelper.spacing(12)),
        itemBuilder: (context, index) {
          final entry = exploreProviderResults[index];
          final provider = entry.provider;
          return SizedBox(
            width: ResponsiveHelper.width(160),
            child: AppProviderCard(
              photo: provider.photo,
              name: provider.name,
              service: provider.service,
              price: provider.price,
              rating: provider.rating,
              badgeIconAsset: entry.badge.iconAsset,
              badgeBgColor: entry.badge.bgColor,
              badgeIconColor: entry.badge.iconColor,
              onTap: () => context.push(
                ProviderDetailsScreen.routeName,
                extra: provider,
              ),
            ),
          );
        },
      ),
    );
  }
}
