import '../../data/models/catalog_search_model.dart';
import '../repositories/home_repository.dart';

class SearchCatalog {
  final HomeRepository repository;

  const SearchCatalog(this.repository);

  Future<CatalogSearchResultModel> call(String query) {
    return repository.searchCatalog(query);
  }
}
