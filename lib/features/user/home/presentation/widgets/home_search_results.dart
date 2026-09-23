import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_provider_card/app_provider_card.dart';
import 'package:nchito/features/user/home/data/models/catalog_search_model.dart';
import 'package:nchito/features/user/home/presentation/providers/home_search_notifier.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_details/provider_details_screen.dart';

class HomeSearchResults extends StatelessWidget {
  final HomeSearchNotifier searchNotifier;

  const HomeSearchResults({
    super.key,
    required this.searchNotifier,
  });

  @override
  Widget build(BuildContext context) {
    if (searchNotifier.isLoading && searchNotifier.searchResult == null) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.padding(48),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.brandPrimary,
          ),
        ),
      );
    }

    if (searchNotifier.errorMessage != null &&
        searchNotifier.searchResult == null) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.padding(32),
        ),
        child: Center(
          child: Column(
            children: [
              Text(
                searchNotifier.errorMessage!,
                style: context.bodyMedium.copyWith(color: AppColors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveHelper.spacing(12)),
              TextButton(
                onPressed: () => searchNotifier.searchImmediately(
                  searchNotifier.searchQuery,
                ),
                child: Text(
                  'Retry',
                  style: context.bodyMedium.copyWith(
                    color: AppColors.brandPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final services = searchNotifier.services;
    final providers = searchNotifier.providers;

    if (services.isEmpty && providers.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.padding(40),
          horizontal: ResponsiveHelper.padding(16),
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                width: ResponsiveHelper.width(64),
                height: ResponsiveHelper.width(64),
                decoration: const BoxDecoration(
                  color: AppColors.brandSoft,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: AppIcon(
                    assetPath: AssetsPath.iconSearch,
                    size: ResponsiveHelper.iconSize(28),
                    color: AppColors.brandPrimary,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(16)),
              Text(
                'No results found',
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlackPrimary,
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(6)),
              Text(
                'No services or providers match "${searchNotifier.searchQuery}".',
                style: context.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (searchNotifier.isLoading)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: LinearProgressIndicator(
              color: AppColors.brandPrimary,
              backgroundColor: AppColors.brandSoft,
            ),
          ),
        if (services.isNotEmpty) ...[
          Text(
            'Services (${services.length})',
            style: context.labelMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textBlackPrimary,
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(12)),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: ResponsiveHelper.spacing(12)),
            itemBuilder: (context, index) {
              final service = services[index];
              return _buildServiceCard(context, service);
            },
          ),
          SizedBox(height: ResponsiveHelper.spacing(24)),
        ],
        if (providers.isNotEmpty) ...[
          Text(
            'Providers (${providers.length})',
            style: context.labelMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textBlackPrimary,
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(12)),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: providers.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: ResponsiveHelper.spacing(12),
              crossAxisSpacing: ResponsiveHelper.spacing(12),
              childAspectRatio: 170 / 226,
            ),
            itemBuilder: (context, index) {
              final providerItem = providers[index];
              final entry = providerItem.toExploreEntry();
              final homeData = entry.provider;
              return AppProviderCard(
                photo: homeData.photo,
                name: homeData.name,
                service: homeData.service,
                price: homeData.price,
                rating: homeData.rating,
                badgeIconAsset: entry.badge.iconAsset,
                badgeBgColor: entry.badge.bgColor,
                badgeIconColor: entry.badge.iconColor,
                onTap: () {
                  context.push(
                    ProviderDetailsScreen.routeName,
                    extra: {
                      'provider': homeData,
                      'isFavorite': providerItem.isFavorited,
                    },
                  );
                },
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, CatalogServiceModel service) {
    return InkWell(
      onTap: () {
        final homeData = service.toHomeProviderData();
        context.push(
          ProviderDetailsScreen.routeName,
          extra: {
            'provider': homeData,
            'isFavorite': service.isFavorited,
          },
        );
      },
      borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(14)),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius:
              BorderRadius.circular(ResponsiveHelper.borderRadius(14)),
          border: Border.all(
            color: AppColors.borderDefault.withValues(alpha: 0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: ResponsiveHelper.width(46),
              height: ResponsiveHelper.width(46),
              decoration: BoxDecoration(
                color: AppColors.brandSoft,
                borderRadius:
                    BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
              ),
              child: Center(
                child: AppIcon(
                  assetPath: AssetsPath.iconSearch,
                  size: ResponsiveHelper.iconSize(20),
                  color: AppColors.brandPrimary,
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          service.title,
                          style: context.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlackPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (service.categoryName.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.padding(8),
                            vertical: ResponsiveHelper.padding(3),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.brandSoft,
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(6),
                            ),
                          ),
                          child: Text(
                            service.categoryName,
                            style: context.labelSmall.copyWith(
                              color: AppColors.brandPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: ResponsiveHelper.fontSize(10),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(4)),
                  if (service.providerName.isNotEmpty)
                    Text(
                      service.providerName,
                      style: context.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: ResponsiveHelper.spacing(6)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${service.currency} ${service.effectivePrice}',
                        style: context.titleSmall.copyWith(
                          color: AppColors.brandPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: ResponsiveHelper.iconSize(16),
                            color: Colors.amber,
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(2)),
                          Text(
                            service.ratingAverage.toStringAsFixed(1),
                            style: context.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBlackPrimary,
                            ),
                          ),
                          if (service.durationMinutes > 0) ...[
                            SizedBox(width: ResponsiveHelper.spacing(8)),
                            Text(
                              '• ${service.durationMinutes} min',
                              style: context.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
