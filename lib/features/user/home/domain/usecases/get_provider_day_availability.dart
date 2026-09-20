import '../../data/models/provider_day_availability_model.dart';
import '../repositories/home_repository.dart';

class GetProviderDayAvailability {
  final HomeRepository repository;

  GetProviderDayAvailability(this.repository);

  Future<ProviderDayAvailabilityModel> call(String providerId, {String? date}) {
    return repository.getProviderDayAvailability(providerId, date: date);
  }
}
