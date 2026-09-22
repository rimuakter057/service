import 'package:nchito/core/errors/exceptions.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';
import '../models/booking_model.dart';
import '../models/customer_booking_detail_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({BookingRemoteDataSource? remoteDataSource})
      : _remoteDataSource =
            remoteDataSource ?? BookingRemoteDataSourceImpl();

  final BookingRemoteDataSource _remoteDataSource;

  @override
  Future<BookingResponseModel> createBooking(
      CreateBookingRequestModel request) async {
    try {
      return await _remoteDataSource.createBooking(request);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to submit booking request. Please try again.');
    }
  }

  @override
  Future<Map<String, dynamic>> getBookingForm(
    String providerId, {
    String? date,
  }) async {
    try {
      return await _remoteDataSource.getBookingForm(providerId, date: date);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load booking form options.');
    }
  }

  @override
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
  }) async {
    try {
      return await _remoteDataSource.getCustomerBookings(
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
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load customer bookings. Please try again.');
    }
  }

  @override
  Future<CustomerBookingDetailModel> getCustomerBookingDetail(
      String bookingId) async {
    try {
      return await _remoteDataSource.getCustomerBookingDetail(bookingId);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load booking details. Please try again.');
    }
  }

  @override
  Future<CustomerBookingDetailModel> acceptBooking(
    String bookingId, {
    String? amount,
    String? note,
  }) async {
    try {
      return await _remoteDataSource.acceptBooking(bookingId,
          amount: amount, note: note);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to accept quote. Please try again.');
    }
  }

  @override
  Future<CustomerBookingDetailModel> cancelBooking(
    String bookingId, {
    String? reason,
  }) async {
    try {
      return await _remoteDataSource.cancelBooking(bookingId, reason: reason);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to cancel booking. Please try again.');
    }
  }

  @override
  Future<CustomerBookingDetailModel> completeBooking(String bookingId) async {
    try {
      return await _remoteDataSource.completeBooking(bookingId);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to complete booking. Please try again.');
    }
  }

  @override
  Future<CustomerBookingDetailModel> declineQuote(
    String bookingId, {
    required String reason,
  }) async {
    try {
      return await _remoteDataSource.declineQuote(bookingId, reason: reason);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to decline quote. Please try again.');
    }
  }

  @override
  Future<CustomerBookingDetailModel> rejectBooking(
    String bookingId, {
    String? reason,
  }) async {
    try {
      return await _remoteDataSource.rejectBooking(bookingId, reason: reason);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to reject booking. Please try again.');
    }
  }

  @override
  Future<CustomerBookingDetailModel> rescheduleBooking(
    String bookingId, {
    required String scheduledDate,
    required String scheduledTime,
    String? reason,
  }) async {
    try {
      return await _remoteDataSource.rescheduleBooking(
        bookingId,
        scheduledDate: scheduledDate,
        scheduledTime: scheduledTime,
        reason: reason,
      );
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to reschedule booking. Please try again.');
    }
  }

  @override
  Future<CustomerBookingDetailModel> rescheduleRespond(
    String bookingId, {
    required bool accept,
  }) async {
    try {
      return await _remoteDataSource.rescheduleRespond(bookingId,
          accept: accept);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to respond to reschedule. Please try again.');
    }
  }

  @override
  Future<CustomerBookingDetailModel> resendCompletionCode(
      String bookingId) async {
    try {
      return await _remoteDataSource.resendCompletionCode(bookingId);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to resend completion code. Please try again.');
    }
  }

  @override
  Future<CustomerBookingDetailModel> startBooking(String bookingId) async {
    try {
      return await _remoteDataSource.startBooking(bookingId);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to start booking. Please try again.');
    }
  }

  @override
  Future<CustomerBookingDetailModel> verifyCompletion(String bookingId) async {
    try {
      return await _remoteDataSource.verifyCompletion(bookingId);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to verify completion. Please try again.');
    }
  }
}
