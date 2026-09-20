import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/api_url.dart';
import '../models/explore_provider_model.dart';

abstract class ExploreRemoteDataSource {
  Future<ExploreProvidersResponseModel> getProviders({
    String? search,
    String? category,
    String? city,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sort,
    String? date,
    int? page,
    int? pageSize,
  });
}

class ExploreRemoteDataSourceImpl implements ExploreRemoteDataSource {
  ExploreRemoteDataSourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  @override
  Future<ExploreProvidersResponseModel> getProviders({
    String? search,
    String? category,
    String? city,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sort,
    String? date,
    int? page,
    int? pageSize,
  }) async {
    final Map<String, dynamic> queryParameters = {};
    if (search != null && search.trim().isNotEmpty) {
      queryParameters['search'] = search.trim();
    }
    if (category != null && category.trim().isNotEmpty) {
      queryParameters['category'] = category.trim();
    }
    if (city != null && city.trim().isNotEmpty) {
      queryParameters['city'] = city.trim();
    }
    if (minPrice != null) {
      queryParameters['min_price'] = minPrice;
    }
    if (maxPrice != null) {
      queryParameters['max_price'] = maxPrice;
    }
    if (minRating != null) {
      // In Swagger: min_rating is integer 1 to 5
      queryParameters['min_rating'] = minRating.toInt();
    }
    if (sort != null && sort.trim().isNotEmpty) {
      queryParameters['sort'] = sort.trim();
    }
    if (date != null && date.trim().isNotEmpty) {
      queryParameters['date'] = date.trim();
    }
    if (page != null) {
      queryParameters['page'] = page;
    }
    if (pageSize != null) {
      queryParameters['page_size'] = pageSize;
    }

    final response = await _apiClient.get(
      ApiUrl.customerProviders,
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ExploreProvidersResponseModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }
}
