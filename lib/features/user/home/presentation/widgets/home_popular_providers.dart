import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_provider_card/app_provider_card.dart';
import 'package:nchito/features/user/explore/presentation/widgets/explore_sample_data.dart';
import 'package:nchito/features/user/home/presentation/providers/near_providers_notifier.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_details/provider_details_screen.dart';

/// Horizontal-scrolling "Popular Near You" provider list on Home with pagination.
/// Fetches nearby providers from `/api/v1/customer/providers/?sort=nearest&city=...`.
class HomePopularProviders extends StatefulWidget {
  const HomePopularProviders({super.key});

  @override
  State<HomePopularProviders> createState() => _HomePopularProvidersState();
}

class _HomePopularProvidersState extends State<HomePopularProviders> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = context.read<NearProvidersNotifier>();
      if (notifier.providers.isEmpty && !notifier.isLoading) {
        notifier.fetchNearProviders();
      }
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // Trigger load more when 120px from the end
    if (currentScroll >= (maxScroll - 120)) {
      final notifier = context.read<NearProvidersNotifier>();
      if (!notifier.isLoading && !notifier.isLoadingMore && notifier.hasNextPage) {
        notifier.loadMore();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NearProvidersNotifier>(
      builder: (context, notifier, _) {
        // Initial loading state
        if (notifier.isLoading && notifier.providers.isEmpty) {
          return SizedBox(
            height: ResponsiveHelper.height(250),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (_, __) =>
                  SizedBox(width: ResponsiveHelper.spacing(12)),
              itemBuilder: (_, __) => _buildSkeletonCard(),
            ),
          );
        }

        // Error state when no data loaded
        if (notifier.errorMessage != null && notifier.providers.isEmpty) {
          return SizedBox(
            height: ResponsiveHelper.height(250),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    notifier.errorMessage!,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(12),
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(8)),
                  TextButton(
                    onPressed: () => notifier.fetchNearProviders(refresh: true),
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(12),
                        fontWeight: FontWeight.w600,
                        color: AppColors.brandPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Use real provider entries if available, otherwise sample fallback
        final entries = notifier.providerEntries.isNotEmpty
            ? notifier.providerEntries
            : exploreProviderResults;

        final itemCount = entries.length + (notifier.isLoadingMore ? 1 : 0);

        return SizedBox(
          height: ResponsiveHelper.height(250),
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            separatorBuilder: (context, index) =>
                SizedBox(width: ResponsiveHelper.spacing(12)),
            itemBuilder: (context, index) {
              if (index >= entries.length) {
                // Loading indicator card at horizontal end
                return _buildLoadingMoreCard();
              }

              final entry = entries[index];
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
      },
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      width: ResponsiveHelper.width(160),
      height: ResponsiveHelper.height(250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
        border: Border.all(
          color: AppColors.borderDefault.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: ResponsiveHelper.height(134),
            decoration: BoxDecoration(
              color: AppColors.borderDefault.withValues(alpha: 0.3),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(ResponsiveHelper.borderRadius(12)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveHelper.padding(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: ResponsiveHelper.width(100),
                  height: ResponsiveHelper.height(12),
                  decoration: BoxDecoration(
                    color: AppColors.borderDefault.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(6)),
                Container(
                  width: ResponsiveHelper.width(70),
                  height: ResponsiveHelper.height(10),
                  decoration: BoxDecoration(
                    color: AppColors.borderDefault.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(12)),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: AppColors.borderDefault.withValues(alpha: 0.3),
                ),
                SizedBox(height: ResponsiveHelper.spacing(8)),
                Row(
                  children: [
                    Container(
                      width: ResponsiveHelper.width(50),
                      height: ResponsiveHelper.height(10),
                      decoration: BoxDecoration(
                        color: AppColors.borderDefault.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: ResponsiveHelper.width(30),
                      height: ResponsiveHelper.height(10),
                      decoration: BoxDecoration(
                        color: AppColors.borderDefault.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreCard() {
    return Container(
      width: ResponsiveHelper.width(80),
      height: ResponsiveHelper.height(250),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
        border: Border.all(
          color: AppColors.borderDefault.withValues(alpha: 0.2),
        ),
      ),
      child: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandPrimary),
        ),
      ),
    );
  }
}
