import '../../data/models/booking_model.dart';

abstract class BookingRepository {
  Future<BookingResponseModel> createBooking(CreateBookingRequestModel request);
  Future<Map<String, dynamic>> getBookingForm(String providerId, {String? date});
  Future<CustomerBookingsResponseModel> getCustomerBookings({
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
  });
}
