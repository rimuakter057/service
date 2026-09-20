import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/features/common/common_widgets/app_shimmer/app_shimmer.dart';

/// 2-column grid of provider card shimmer placeholders displayed while loading.
class ExploreProviderGridShimmer extends StatelessWidget {
  final int itemCount;

  const ExploreProviderGridShimmer({
    super.key,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: ResponsiveHelper.spacing(10),
          crossAxisSpacing: ResponsiveHelper.spacing(10),
          childAspectRatio: 170 / 226,
        ),
        itemBuilder: (context, index) {
          return const _ProviderCardShimmer();
        },
      ),
    );
  }
}

class _ProviderCardShimmer extends StatelessWidget {
  const _ProviderCardShimmer();

  @override
  Widget build(BuildContext context) {
    return AppContainerBg(
      color: Colors.white,
      padding: EdgeInsets.zero,
      radius: ResponsiveHelper.borderRadius(12),
      border: Border.all(
        color: AppColors.borderDefault.withValues(alpha: 0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Photo placeholder
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(ResponsiveHelper.borderRadius(12)),
            ),
            child: ShimmerBox(
              width: double.infinity,
              height: ResponsiveHelper.height(134),
              borderRadius: 0,
              color: const Color(0xFFE5E7EB),
            ),
          ),

          // Info placeholder
          Padding(
            padding: EdgeInsets.all(ResponsiveHelper.padding(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge + Name row
                Row(
                  children: [
                    ShimmerBox(
                      width: ResponsiveHelper.width(32),
                      height: ResponsiveHelper.width(32),
                      borderRadius: ResponsiveHelper.borderRadius(9),
                      color: const Color(0xFFE5E7EB),
                    ),
                    SizedBox(width: ResponsiveHelper.spacing(6)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(
                            width: ResponsiveHelper.width(75),
                            height: ResponsiveHelper.height(11),
                            borderRadius: ResponsiveHelper.borderRadius(4),
                            color: const Color(0xFFE5E7EB),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(4)),
                          ShimmerBox(
                            width: ResponsiveHelper.width(50),
                            height: ResponsiveHelper.height(9),
                            borderRadius: ResponsiveHelper.borderRadius(4),
                            color: const Color(0xFFE5E7EB),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.spacing(8)),

                // Divider
                Container(
                  height: 1,
                  color: AppColors.borderDefault.withValues(alpha: 0.5),
                ),

                SizedBox(height: ResponsiveHelper.spacing(8)),

                // Price | Rating row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(
                            width: ResponsiveHelper.width(38),
                            height: ResponsiveHelper.height(7),
                            borderRadius: ResponsiveHelper.borderRadius(3),
                            color: const Color(0xFFE5E7EB),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(3)),
                          ShimmerBox(
                            width: ResponsiveHelper.width(48),
                            height: ResponsiveHelper.height(10),
                            borderRadius: ResponsiveHelper.borderRadius(4),
                            color: const Color(0xFFE5E7EB),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 0.5,
                      height: ResponsiveHelper.height(24),
                      color: AppColors.borderDefault,
                    ),
                    SizedBox(width: ResponsiveHelper.spacing(8)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(
                            width: ResponsiveHelper.width(32),
                            height: ResponsiveHelper.height(7),
                            borderRadius: ResponsiveHelper.borderRadius(3),
                            color: const Color(0xFFE5E7EB),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(3)),
                          ShimmerBox(
                            width: ResponsiveHelper.width(36),
                            height: ResponsiveHelper.height(10),
                            borderRadius: ResponsiveHelper.borderRadius(4),
                            color: const Color(0xFFE5E7EB),
                          ),
                        ],
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
}
