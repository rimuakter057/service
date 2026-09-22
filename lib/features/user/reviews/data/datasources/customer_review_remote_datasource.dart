import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/api_url.dart';
import '../models/customer_review_model.dart';

abstract class CustomerReviewRemoteDataSource {
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

class CustomerReviewRemoteDataSourceImpl implements CustomerReviewRemoteDataSource {
  CustomerReviewRemoteDataSourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  @override
  Future<CustomerReviewsResponseModel> getReviews({
    required String providerId,
    int? page,
  }) async {
    final queryParams = <String, dynamic>{'provider': providerId};
    if (page != null) queryParams['page'] = page;

    final response = await _apiClient.get(
      ApiUrl.customerReviews,
      queryParameters: queryParams,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return CustomerReviewsResponseModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<CustomerReviewModel> createReview({
    required String booking,
    required int rating,
    String? comment,
  }) async {
    final body = <String, dynamic>{
      'booking': booking,
      'rating': rating,
      if (comment != null && comment.trim().isNotEmpty) 'comment': comment.trim(),
    };

    final response = await _apiClient.post(ApiUrl.customerReviews, data: body);

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return CustomerReviewModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }
}
