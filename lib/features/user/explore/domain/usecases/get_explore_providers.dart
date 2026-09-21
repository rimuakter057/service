import '../../data/models/explore_provider_model.dart';
import '../repositories/explore_repository.dart';

class GetExploreProviders {
  final ExploreRepository repository;

  GetExploreProviders(this.repository);

  Future<ExploreProvidersResponseModel> call({
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
  }) {
    return repository.getProviders(
      search: search,
      category: category,
      city: city,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
      sort: sort,
      date: date,
      lat: lat,
      lng: lng,
      page: page,
      pageSize: pageSize,
    );
  }
}
