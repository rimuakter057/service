import '../../data/models/booking_model.dart';

abstract class BookingRepository {
  Future<BookingResponseModel> createBooking(CreateBookingRequestModel request);
  Future<Map<String, dynamic>> getBookingForm(String providerId, {String? date});
}
