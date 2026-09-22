import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/api_url.dart';
import '../models/provider_review_model.dart';

abstract class ProviderReviewRemoteDataSource {
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

class ProviderReviewRemoteDataSourceImpl
    implements ProviderReviewRemoteDataSource {
  ProviderReviewRemoteDataSourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  @override
  Future<ProviderReviewsResponseModel> getReviews({
    required String providerId,
    int? page,
  }) async {
    final queryParams = <String, dynamic>{'provider': providerId};
    if (page != null) queryParams['page'] = page;

    final response = await _apiClient.get(
      ApiUrl.providerReviews,
      queryParameters: queryParams,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ProviderReviewsResponseModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<ProviderReviewBreakdownModel> getBreakdown({
    required String providerId,
  }) async {
    final response = await _apiClient.get(
      ApiUrl.providerReviewsBreakdown,
      queryParameters: {'provider': providerId},
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ProviderReviewBreakdownModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<ProviderReviewModel> getReviewDetail(String reviewId) async {
    final response =
        await _apiClient.get(ApiUrl.providerReviewDetails(reviewId));
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ProviderReviewModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<ProviderReviewModel> replyToReview(
    String reviewId, {
    required String message,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.providerReviewReply(reviewId),
      data: {'message': message.trim()},
    );
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ProviderReviewModel.fromJson(responseData);
    }
    return ProviderReviewModel(id: reviewId);
  }

  @override
  Future<void> reportReview(String reviewId, {String? reason}) async {
    final body = <String, dynamic>{
      if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
    };
    await _apiClient.post(
      ApiUrl.providerReviewReport(reviewId),
      data: body.isNotEmpty ? body : null,
    );
  }
}
