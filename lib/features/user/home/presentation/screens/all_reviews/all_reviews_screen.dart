import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';
import 'package:nchito/features/user/home/presentation/widgets/review_card.dart';

/// Full review list — reached from Provider Details' Reviews eye icon.
class AllReviewsScreen extends StatelessWidget {
  static const String routeName = '/all-reviews';

  final String reviewCount;

  const AllReviewsScreen({super.key, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopAppbar(title: '${AppText.allReviews} [ $reviewCount ]'),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                  vertical: ResponsiveHelper.padding(8),
                ),
                itemCount: homeReviews.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: ResponsiveHelper.spacing(12)),
                itemBuilder: (context, index) =>
                    ReviewCard(review: homeReviews[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
