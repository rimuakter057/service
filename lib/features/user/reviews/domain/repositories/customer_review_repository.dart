import '../../data/models/customer_review_model.dart';

abstract class CustomerReviewRepository {
  Future<CustomerReviewsResponseModel> getReviews({
    required String providerId,
    int? page,
  });

  Future<CustomerReviewModel> createReview({
    required String booking,
    required int rating,
    String? comment,
  });
}
