import '../../data/models/explore_provider_model.dart';

abstract class ExploreRepository {
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
