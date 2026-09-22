import '../../data/models/booking_model.dart';
import '../repositories/booking_repository.dart';

class GetCustomerBookingsUseCase {
  final BookingRepository repository;

  GetCustomerBookingsUseCase(this.repository);

  Future<CustomerBookingsResponseModel> call({
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
    return repository.getCustomerBookings(
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
