import '../../data/models/provider_detail_model.dart';
import '../repositories/home_repository.dart';

class GetProviderDetails {
  final HomeRepository repository;

  GetProviderDetails(this.repository);

  Future<ProviderDetailModel> call(String id) {
    return repository.getProviderDetails(id);
  }
}
