import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/features/common/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/features/common/common_widgets/app_shimmer/app_shimmer.dart';

class BookingDetailsShimmer extends StatelessWidget {
  const BookingDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final fieldColor = AppColors.bgOverlay.withValues(alpha: 0.04);
    final fieldRadius = ResponsiveHelper.borderRadius(10);
    final fieldPadding = EdgeInsets.all(ResponsiveHelper.padding(14));

    return AppShimmer(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ResponsiveHelper.spacing(8)),

                  /// Service Row Shimmer
                  Row(
                    children: [
                      ShimmerBox(
                        width: ResponsiveHelper.width(44),
                        height: ResponsiveHelper.width(44),
                        borderRadius: ResponsiveHelper.borderRadius(11),
                      ),
                      SizedBox(width: ResponsiveHelper.spacing(10)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(
                            width: ResponsiveHelper.width(140),
                            height: ResponsiveHelper.height(14),
                            borderRadius: 4,
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(6)),
                          ShimmerBox(
                            width: ResponsiveHelper.width(75),
                            height: ResponsiveHelper.height(20),
                            borderRadius: ResponsiveHelper.borderRadius(100),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(20)),

                  /// Location Field Shimmer
                  AppContainerBg(
                    width: double.infinity,
                    color: fieldColor,
                    radius: fieldRadius,
                    padding: fieldPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(
                          width: ResponsiveHelper.width(60),
                          height: ResponsiveHelper.height(11),
                          borderRadius: 3,
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(8)),
                        ShimmerBox(
                          width: ResponsiveHelper.width(200),
                          height: ResponsiveHelper.height(14),
                          borderRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(10)),

                  /// Schedule Field Shimmer
                  AppContainerBg(
                    width: double.infinity,
                    color: fieldColor,
                    radius: fieldRadius,
                    padding: fieldPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(
                          width: ResponsiveHelper.width(80),
                          height: ResponsiveHelper.height(11),
                          borderRadius: 3,
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(8)),
                        ShimmerBox(
                          width: ResponsiveHelper.width(230),
                          height: ResponsiveHelper.height(14),
                          borderRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(10)),

                  /// Provider Card Shimmer
                  AppContainerBg(
                    width: double.infinity,
                    color: fieldColor,
                    radius: fieldRadius,
                    padding: fieldPadding,
                    child: Row(
                      children: [
                        ShimmerBox(
                          width: ResponsiveHelper.width(44),
                          height: ResponsiveHelper.width(44),
                          borderRadius: ResponsiveHelper.borderRadius(8),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(10)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerBox(
                                width: ResponsiveHelper.width(110),
                                height: ResponsiveHelper.height(13),
                                borderRadius: 3,
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(6)),
                              ShimmerBox(
                                width: ResponsiveHelper.width(85),
                                height: ResponsiveHelper.height(11),
                                borderRadius: 3,
                              ),
                            ],
                          ),
                        ),
                        ShimmerBox(
                          width: ResponsiveHelper.width(36),
                          height: ResponsiveHelper.width(36),
                          borderRadius: ResponsiveHelper.borderRadius(18),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(8)),
                        ShimmerBox(
                          width: ResponsiveHelper.width(36),
                          height: ResponsiveHelper.width(36),
                          borderRadius: ResponsiveHelper.borderRadius(18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(10)),

                  /// Booking Details Field Shimmer
                  AppContainerBg(
                    width: double.infinity,
                    color: fieldColor,
                    radius: fieldRadius,
                    padding: fieldPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(
                          width: ResponsiveHelper.width(90),
                          height: ResponsiveHelper.height(11),
                          borderRadius: 3,
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(8)),
                        ShimmerBox(
                          width: double.infinity,
                          height: ResponsiveHelper.height(12),
                          borderRadius: 3,
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(6)),
                        ShimmerBox(
                          width: ResponsiveHelper.width(220),
                          height: ResponsiveHelper.height(12),
                          borderRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(10)),

                  /// Payment / Pricing Card Shimmer
                  AppContainerBg(
                    width: double.infinity,
                    color: fieldColor,
                    radius: fieldRadius,
                    padding: fieldPadding,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShimmerBox(
                              width: ResponsiveHelper.width(80),
                              height: ResponsiveHelper.height(11),
                              borderRadius: 3,
                            ),
                            ShimmerBox(
                              width: ResponsiveHelper.width(60),
                              height: ResponsiveHelper.height(11),
                              borderRadius: 3,
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShimmerBox(
                              width: ResponsiveHelper.width(70),
                              height: ResponsiveHelper.height(11),
                              borderRadius: 3,
                            ),
                            ShimmerBox(
                              width: ResponsiveHelper.width(50),
                              height: ResponsiveHelper.height(11),
                              borderRadius: 3,
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShimmerBox(
                              width: ResponsiveHelper.width(50),
                              height: ResponsiveHelper.height(13),
                              borderRadius: 3,
                            ),
                            ShimmerBox(
                              width: ResponsiveHelper.width(80),
                              height: ResponsiveHelper.height(13),
                              borderRadius: 3,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(20)),
                ],
              ),
            ),
          ),

          /// Bottom Actions Shimmer
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.padding(24),
              vertical: ResponsiveHelper.padding(16),
            ),
            child: ShimmerBox(
              width: double.infinity,
              height: ResponsiveHelper.height(48),
              borderRadius: ResponsiveHelper.borderRadius(8),
            ),
          ),
        ],
      ),
    );
  }
}
