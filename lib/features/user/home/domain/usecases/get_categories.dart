import '../entities/category.dart';
import '../repositories/home_repository.dart';

class GetCategories {
  const GetCategories(this._repository);

  final HomeRepository _repository;

  Future<List<Category>> call() {
    return _repository.getCategories();
  }
}
