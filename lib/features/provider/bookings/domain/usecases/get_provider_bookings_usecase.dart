import '../../data/models/provider_booking_model.dart';
import '../repositories/provider_booking_repository.dart';

class GetProviderBookingsUseCase {
  final ProviderBookingRepository repository;

  GetProviderBookingsUseCase(this.repository);

  Future<ProviderBookingsResponseModel> call({
    String? group,
    String? status,
    String? date,
    String? dateFrom,
    String? dateTo,
    bool? today,
    String? search,
    String? ordering,
    int? page,
    int? pageSize,
  }) {
    return repository.getProviderBookings(
      group: group,
      status: status,
      date: date,
      dateFrom: dateFrom,
      dateTo: dateTo,
      today: today,
      search: search,
      ordering: ordering,
      page: page,
      pageSize: pageSize,
    );
  }
}
