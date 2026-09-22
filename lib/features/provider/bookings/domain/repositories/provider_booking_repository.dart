import '../../data/models/provider_booking_model.dart';
import '../../data/models/provider_booking_detail_model.dart';

abstract class ProviderBookingRepository {
  Future<ProviderBookingsResponseModel> getProviderBookings({
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
  Future<ProviderBookingDetailModel> getProviderBookingDetail(String bookingId);
  Future<ProviderBookingDetailModel> acceptBooking(String bookingId, {String? amount, String? note});
  Future<ProviderBookingDetailModel> cancelBooking(String bookingId, {String? reason});
  Future<ProviderBookingDetailModel> completeBooking(String bookingId);
  Future<ProviderBookingDetailModel> declineQuote(String bookingId, {required String reason});
  Future<ProviderBookingDetailModel> rejectBooking(String bookingId, {String? reason});
  Future<ProviderBookingDetailModel> rescheduleBooking(String bookingId, {required String scheduledDate, required String scheduledTime, String? reason});
  Future<ProviderBookingDetailModel> rescheduleRespond(String bookingId, {required bool accept});
  Future<ProviderBookingDetailModel> resendCompletionCode(String bookingId);
  Future<ProviderBookingDetailModel> startBooking(String bookingId);
  Future<ProviderBookingDetailModel> verifyCompletion(String bookingId, {String? code});
}
