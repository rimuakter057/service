import '../../data/models/booking_model.dart';
import '../../data/models/customer_booking_detail_model.dart';

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
  Future<CustomerBookingDetailModel> getCustomerBookingDetail(String bookingId);
  Future<CustomerBookingDetailModel> acceptBooking(String bookingId, {String? amount, String? note});
  Future<CustomerBookingDetailModel> cancelBooking(String bookingId, {String? reason});
  Future<CustomerBookingDetailModel> completeBooking(String bookingId);
  Future<CustomerBookingDetailModel> declineQuote(String bookingId, {required String reason});
  Future<CustomerBookingDetailModel> rejectBooking(String bookingId, {String? reason});
  Future<CustomerBookingDetailModel> rescheduleBooking(String bookingId, {required String scheduledDate, required String scheduledTime, String? reason});
  Future<CustomerBookingDetailModel> rescheduleRespond(String bookingId, {required bool accept});
  Future<CustomerBookingDetailModel> resendCompletionCode(String bookingId);
  Future<CustomerBookingDetailModel> startBooking(String bookingId);
  Future<CustomerBookingDetailModel> verifyCompletion(String bookingId);
}
