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
    double? lat,
    double? lng,
    int? page,
    int? pageSize,
  });

  Future<ExploreFiltersResponseModel> getFilters();

  Future<FavoriteProvidersResponseModel> getFavorites({
    int? page,
    int? pageSize,
  });

  Future<bool> addFavorite(String providerId);

  Future<bool> removeFavorite(String providerId);
}
