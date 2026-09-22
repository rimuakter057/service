import '../../data/models/customer_booking_detail_model.dart';
import '../repositories/booking_repository.dart';

class GetCustomerBookingDetailUseCase {
  final BookingRepository repository;

  GetCustomerBookingDetailUseCase(this.repository);

  Future<CustomerBookingDetailModel> call(String bookingId) {
    return repository.getCustomerBookingDetail(bookingId);
  }
}
