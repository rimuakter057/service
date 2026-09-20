import '../../data/models/booking_model.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUseCase {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  Future<BookingResponseModel> call(CreateBookingRequestModel request) {
    return repository.createBooking(request);
  }
}
