import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/user/explore/presentation/widgets/explore_provider_grid.dart';
import 'package:nchito/features/user/explore/presentation/widgets/explore_provider_shimmer.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_details/provider_details_screen.dart';
import 'package:nchito/features/user/profile/presentation/providers/favorite_providers_notifier.dart';

/// Grid of the user's favorite/saved providers. Navigated to from
/// [ProfileScreen]'s "Favorite Providers" menu tile.
class FavoriteProvidersScreen extends StatefulWidget {
  static const String routeName = '/favorite-providers';

  const FavoriteProvidersScreen({super.key});

  @override
  State<FavoriteProvidersScreen> createState() =>
      _FavoriteProvidersScreenState();
}

class _FavoriteProvidersScreenState extends State<FavoriteProvidersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FavoriteProvidersNotifier>().fetchFavorites();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<FavoriteProvidersNotifier>();
    final entries = notifier.exploreEntries;
    final isLoading = notifier.isLoading;
    final errorMessage = notifier.errorMessage;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopAppbar(title: AppText.favoriteProviders),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.brandPrimary,
                onRefresh: () => context
                    .read<FavoriteProvidersNotifier>()
                    .fetchFavorites(refresh: true),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.padding(24),
                  ),
                  child: Column(
                    children: [
                      if (isLoading && entries.isEmpty)
                        const ExploreProviderGridShimmer()
                      else if (errorMessage != null && entries.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveHelper.spacing(60),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  errorMessage,
                                  style: context.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: ResponsiveHelper.spacing(12)),
                                TextButton(
                                  onPressed: () => context
                                      .read<FavoriteProvidersNotifier>()
                                      .fetchFavorites(refresh: true),
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
                        )
                      else if (entries.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveHelper.spacing(80),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.favorite_border_rounded,
                                  size: ResponsiveHelper.iconSize(64),
                                  color: AppColors.textGrey,
                                ),
                                SizedBox(height: ResponsiveHelper.spacing(16)),
                                Text(
                                  'No Favorite Providers Yet',
                                  style: context.labelLarge,
                                ),
                                SizedBox(height: ResponsiveHelper.spacing(8)),
                                Text(
                                  'Explore providers and tap the heart icon to save them here.',
                                  style: context.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      else ...[
                        ExploreProviderGrid(
                          entries: entries,
                          onProviderTap: (provider) => context.push(
                            ProviderDetailsScreen.routeName,
                            extra: {'provider': provider, 'isFavorite': true},
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(24)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
