import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/api_url.dart';
import '../models/category_model.dart';
import '../models/provider_detail_model.dart';
import '../models/provider_day_availability_model.dart';
import '../models/catalog_search_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<ProviderDetailModel> getProviderDetails(String id);
  Future<ProviderDayAvailabilityModel> getProviderDayAvailability(
    String providerId, {
    String? date,
  });
  Future<CatalogSearchResultModel> searchCatalog(String query);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.get(ApiUrl.categories);
    final responseData = response.data;
    if (responseData is Map<String, dynamic> && responseData['data'] is List) {
      final list = responseData['data'] as List;
      return list
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<ProviderDetailModel> getProviderDetails(String id) async {
    final response = await _apiClient.get(ApiUrl.customerProviderDetails(id));
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      final map = (responseData['data'] is Map<String, dynamic>)
          ? responseData['data'] as Map<String, dynamic>
          : responseData;
      return ProviderDetailModel.fromJson(map);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<ProviderDayAvailabilityModel> getProviderDayAvailability(
    String providerId, {
    String? date,
  }) async {
    final queryParams = <String, dynamic>{};
    if (date != null && date.trim().isNotEmpty) {
      queryParams['date'] = date.trim();
    }

    final response = await _apiClient.get(
      ApiUrl.customerProviderDayAvailability(providerId),
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      final map = (responseData['data'] is Map<String, dynamic>)
          ? responseData['data'] as Map<String, dynamic>
          : responseData;
      return ProviderDayAvailabilityModel.fromJson(map);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<CatalogSearchResultModel> searchCatalog(String query) async {
    final response = await _apiClient.get(
      ApiUrl.catalogSearch,
      queryParameters: {'q': query},
    );
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return CatalogSearchResultModel.fromJson(responseData);
    }
    return const CatalogSearchResultModel(services: [], providers: []);
  }
}

