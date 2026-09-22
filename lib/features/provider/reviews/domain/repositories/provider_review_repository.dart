import '../../data/models/provider_review_model.dart';

abstract class ProviderReviewRepository {
  Future<ProviderReviewsResponseModel> getReviews({
    required String providerId,
    int? page,
  });

  Future<ProviderReviewBreakdownModel> getBreakdown({
    required String providerId,
  });

  Future<ProviderReviewModel> getReviewDetail(String reviewId);

  Future<ProviderReviewModel> replyToReview(
    String reviewId, {
    required String message,
  });

  Future<void> reportReview(String reviewId, {String? reason});
}
