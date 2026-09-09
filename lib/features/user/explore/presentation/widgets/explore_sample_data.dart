import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

/// Category badge shown on an [ExploreProviderCard] — icon plus the
/// background/tint colors matched to the provider's service category.
class ExploreProviderBadge {
  final String iconAsset;
  final Color bgColor;
  final Color iconColor;

  const ExploreProviderBadge({
    required this.iconAsset,
    required this.bgColor,
    required this.iconColor,
  });
}

/// Pairs a provider with the category badge shown for it in the Explore
/// results grid.
class ExploreProviderEntry {
  final HomeProviderData provider;
  final ExploreProviderBadge badge;

  const ExploreProviderEntry({required this.provider, required this.badge});
}

/// Placeholder content for Explore Provider until it's wired to real data.
const HomeProviderData jhoneDoeProvider = HomeProviderData(
  photo: AssetsPath.exploreProviderPhotoJhoneDoe,
  name: 'Jhone doe',
  service: AppText.serviceTypeMovingRelocation,
  price: 'ZMW 100',
  rating: '4.8',
  email: 'jhone@doe.com',
  phone: '+260 97 555 1234',
  area: 'Lusaka, Zambia',
  description:
      'Experienced moving and relocation specialist offering careful '
      'packing, safe transport, and hassle-free setup for homes and '
      'offices across Lusaka.',
  reviewCount: '87',
  totalJobsCompleted: '164',
  tags: [
    ProviderTag(
      iconAsset: AssetsPath.exploreProviderDetailsTagIconMoving1,
      label: AppText.serviceTypeMovingRelocation,
    ),
  ],
);

const List<ExploreProviderEntry> exploreProviderResults = [
  ExploreProviderEntry(
    provider: robertJuniorProvider,
    badge: ExploreProviderBadge(
      iconAsset: AssetsPath.categoryElectrical,
      bgColor: AppColors.orange50,
      iconColor: AppColors.orange400,
    ),
  ),
  ExploreProviderEntry(
    provider: alexJohnsonProvider,
    badge: ExploreProviderBadge(
      iconAsset: AssetsPath.categoryCleaning,
      bgColor: AppColors.brandSoft,
      iconColor: AppColors.brandPrimary,
    ),
  ),
  ExploreProviderEntry(
    provider: jhoneDoeProvider,
    badge: ExploreProviderBadge(
      iconAsset: AssetsPath.categoryMoving,
      bgColor: AppColors.teal50,
      iconColor: AppColors.cyan400,
    ),
  ),
];
