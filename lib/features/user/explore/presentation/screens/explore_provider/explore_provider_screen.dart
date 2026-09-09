import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_bottom_nav_bar/app_bottom_nav_bar.dart';
import 'package:nchito/core/common_widgets/app_button/app_button.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/core/common_widgets/app_search_field/app_search_field.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/explore/presentation/widgets/explore_empty_state.dart';
import 'package:nchito/features/user/explore/presentation/widgets/explore_provider_grid.dart';
import 'package:nchito/features/user/explore/presentation/widgets/explore_sample_data.dart';
import 'package:nchito/features/user/explore/presentation/widgets/filter_bottom_sheet.dart';
import 'package:nchito/features/user/home/presentation/screens/home_screen/home_screen.dart';
import 'package:nchito/features/user/home/presentation/screens/provider_details/provider_details_screen.dart';

/// Search + filter screen for browsing providers — reached from the bottom
/// nav's "Explore" tab. Shows [ExploreProviderGrid] when results match the
/// search query, falling back to [ExploreEmptyState] (calendar + message)
/// when nothing matches.
class ExploreProviderScreen extends StatefulWidget {
  static const String routeName = '/explore-provider';

  const ExploreProviderScreen({super.key});

  @override
  State<ExploreProviderScreen> createState() => _ExploreProviderScreenState();
}

class _ExploreProviderScreenState extends State<ExploreProviderScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  List<ExploreProviderEntry> get _filteredResults {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return exploreProviderResults;
    return exploreProviderResults
        .where(
          (entry) =>
              entry.provider.name.toLowerCase().contains(query) ||
              entry.provider.service.toLowerCase().contains(query),
        )
        .toList();
  }

  static final List<AppBottomNavItem> _navItems = [
    AppBottomNavItem(
      iconAsset: AssetsPath.exploreProviderNavHomeOutline,
      label: AppText.home,
    ),
    AppBottomNavItem(
      iconAsset: AssetsPath.exploreProviderNavExploreActive,
      label: AppText.explore,
      activeBackgroundColor: AppColors.brandPrimary,
    ),
    AppBottomNavItem(
      iconAsset: AssetsPath.navBookings,
      label: AppText.bookings,
    ),
    AppBottomNavItem(
      iconAsset: AssetsPath.navMessages,
      label: AppText.messages,
    ),
    AppBottomNavItem(iconAsset: AssetsPath.navProfile, label: AppText.profile),
  ];

  @override
  void dispose() {
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

  void _onNavTap(int index) {
    if (index == 0) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(HomeScreen.routeName);
      }
    }
    // Bookings/Messages/Profile aren't built yet.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
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
                      onTap: () => context.pop(),
                      child: BgIcon(
                        assetPath: AssetsPath.providerDetailsIconBack,
                        bgColor: AppColors.brandSoft,
                        iconColor: AppColors.brandPrimary,
                        bgSize: ResponsiveHelper.width(40),
                        radius: ResponsiveHelper.width(20),
                      ),
                    ),
                  ),
                  Text(AppText.exploreProvider, style: context.labelMedium),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppSearchField(
                            hint: AppText.search,
                            searchIconAsset:
                                AssetsPath.exploreProviderIconSearch,
                            controller: _searchController,
                            onChanged: (value) =>
                                setState(() => _query = value),
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(8)),
                        AppButton(
                          text: AppText.filter,
                          onPressed: _onFilterTap,
                          width: ResponsiveHelper.width(48),
                          height: ResponsiveHelper.height(48),
                          backgroundColor: AppColors.brandPrimary,
                          radius: ResponsiveHelper.borderRadius(12),
                          child: AppIcon(
                            assetPath: AssetsPath.exploreProviderIconFilter,
                            size: ResponsiveHelper.iconSize(18),
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),

                    _filteredResults.isEmpty
                        ? const ExploreEmptyState()
                        : ExploreProviderGrid(
                            entries: _filteredResults,
                            onProviderTap: (provider) => context.push(
                              ProviderDetailsScreen.routeName,
                              extra: provider,
                            ),
                          ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        items: _navItems,
        currentIndex: 1,
        onTap: _onNavTap,
      ),
    );
  }
}
