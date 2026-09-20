import '../../data/models/provider_detail_model.dart';
import '../../data/models/provider_day_availability_model.dart';
import '../entities/category.dart';

abstract class HomeRepository {
  Future<List<Category>> getCategories();
  Future<ProviderDetailModel> getProviderDetails(String id);
  Future<ProviderDayAvailabilityModel> getProviderDayAvailability(
    String providerId, {
    String? date,
  });
}

