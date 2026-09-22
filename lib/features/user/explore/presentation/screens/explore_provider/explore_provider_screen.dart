import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nchito/features/common/common_widgets/app_bottom_nav_bar/app_bottom_nav_bar.dart';
import 'package:nchito/features/common/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/features/common/common_widgets/app_search_bar/app_search_bar.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/explore/presentation/providers/explore_provider.dart';
import 'package:nchito/features/user/explore/presentation/widgets/explore_empty_state.dart';
import 'package:nchito/features/user/explore/presentation/widgets/explore_provider_grid.dart';
import 'package:nchito/features/user/explore/presentation/widgets/explore_provider_shimmer.dart';
import 'package:nchito/features/user/explore/presentation/widgets/filter_bottom_sheet.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_details/provider_details_screen.dart';

/// Search + filter screen for browsing providers with infinite scroll pagination.
class ExploreProviderScreen extends StatefulWidget {
  static const String routeName = '/explore-provider';

  const ExploreProviderScreen({super.key});

  @override
  State<ExploreProviderScreen> createState() => _ExploreProviderScreenState();
}

class _ExploreProviderScreenState extends State<ExploreProviderScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ExploreProviderNotifier>().fetchProviders();
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // Trigger loading next page when user scrolls near the bottom
    if (currentScroll >= (maxScroll - 200)) {
      context.read<ExploreProviderNotifier>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onFilterTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exploreNotifier = context.watch<ExploreProviderNotifier>();
    final entries = exploreNotifier.exploreEntries;
    final isLoading = exploreNotifier.isLoading;
    final errorMessage = exploreNotifier.errorMessage;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(24),
                vertical: ResponsiveHelper.padding(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: BgIcon(
                        assetPath: AssetsPath.providerDetailsIconBack,
                        bgColor: AppColors.brandSoft,
                        iconColor: AppColors.brandPrimary,
                        bgSize: ResponsiveHelper.width(40),
                        radius: ResponsiveHelper.width(20),
                      ),
                    ),
                  ),
                  Text(
                    exploreNotifier.response?.title ?? AppText.exploreProvider,
                    style: context.labelMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.brandPrimary,
                onRefresh: () async {
                  _searchController.clear();
                  await context.read<ExploreProviderNotifier>().refreshAll();
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.padding(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSearchBar(
                        controller: _searchController,
                        onChanged: (value) => context
                            .read<ExploreProviderNotifier>()
                            .onSearchChanged(value),
                        onFilterTap: _onFilterTap,
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(20)),

                      if (isLoading && entries.isEmpty)
                        const ExploreProviderGridShimmer()
                      else if (errorMessage != null && entries.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveHelper.spacing(40),
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
                                      .read<ExploreProviderNotifier>()
                                      .fetchProviders(
                                        search: _searchController.text.trim(),
                                        refresh: true,
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
                        )
                      else if (entries.isEmpty)
                        ExploreEmptyState(
                          message: exploreNotifier.emptyMessage,
                        )
                      else ...[
                        ExploreProviderGrid(
                          entries: entries,
                          onProviderTap: (provider) {
                            bool isFav = false;
                            try {
                              isFav = exploreNotifier.providers
                                  .firstWhere((p) => p.id == provider.id)
                                  .isFavorited;
                            } catch (_) {}
                            context.push(
                              ProviderDetailsScreen.routeName,
                              extra: {
                                'provider': provider,
                                'isFavorite': isFav,
                              },
                            );
                          },
                        ),
                        // Shimmer placeholder cards while loading more pages
                        if (exploreNotifier.isLoadingMore) ...[
                          SizedBox(height: ResponsiveHelper.spacing(10)),
                          const ExploreProviderGridShimmer(itemCount: 2),
                        ],
                        // Error retry banner for loadMore failures
                        if (exploreNotifier.loadMoreErrorMessage != null) ...[
                          SizedBox(height: ResponsiveHelper.spacing(12)),
                          Center(
                            child: TextButton(
                              onPressed: () => context
                                  .read<ExploreProviderNotifier>()
                                  .loadMore(),
                              child: Text(
                                'Failed to load more. Tap to retry.',
                                style: context.bodySmall.copyWith(
                                  color: AppColors.brandPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                      SizedBox(height: ResponsiveHelper.spacing(20)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 1),
    );
  }
}
