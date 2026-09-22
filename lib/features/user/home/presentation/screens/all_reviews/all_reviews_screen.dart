import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';
import 'package:nchito/features/user/home/presentation/widgets/review_card.dart';
import 'package:nchito/features/user/reviews/presentation/providers/customer_review_notifier.dart';

/// Full review list — reached from Provider Details' Reviews eye icon.
class AllReviewsScreen extends StatefulWidget {
  static const String routeName = '/all-reviews';

  final String reviewCount;
  final String? providerId;

  const AllReviewsScreen({super.key, required this.reviewCount, this.providerId});

  @override
  State<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.providerId != null && widget.providerId!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context
            .read<CustomerReviewNotifier>()
            .fetchReviews(providerId: widget.providerId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopAppbar(title: '${AppText.allReviews} [ ${widget.reviewCount} ]'),
            Expanded(
              child: widget.providerId == null || widget.providerId!.isEmpty
                  ? _buildStaticFallback()
                  : Consumer<CustomerReviewNotifier>(
                      builder: (context, notifier, child) {
                        if (notifier.isLoading && notifier.reviews.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.brandPrimary,
                            ),
                          );
                        }
                        if (notifier.errorMessage != null &&
                            notifier.reviews.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(
                                ResponsiveHelper.padding(24),
                              ),
                              child: Text(
                                notifier.errorMessage!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.red,
                                  fontSize: ResponsiveHelper.fontSize(14),
                                ),
                              ),
                            ),
                          );
                        }
                        if (notifier.reviews.isEmpty) {
                          return Center(
                            child: Text(
                              'No reviews yet.',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(14),
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.padding(24),
                            vertical: ResponsiveHelper.padding(8),
                          ),
                          itemCount: notifier.reviews.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: ResponsiveHelper.spacing(12)),
                          itemBuilder: (context, index) => ReviewCard(
                            review: notifier.reviews[index].toReviewData(),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reached without a provider id (an old/degraded navigation) — keeps the
  /// screen usable instead of an empty state.
  Widget _buildStaticFallback() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(24),
        vertical: ResponsiveHelper.padding(8),
      ),
      itemCount: homeReviews.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: ResponsiveHelper.spacing(12)),
      itemBuilder: (context, index) => ReviewCard(review: homeReviews[index]),
    );
  }
}
