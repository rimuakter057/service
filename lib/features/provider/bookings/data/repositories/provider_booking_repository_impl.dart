import 'package:nchito/core/errors/exceptions.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../domain/repositories/provider_booking_repository.dart';
import '../datasources/provider_booking_remote_datasource.dart';
import '../models/provider_booking_model.dart';
import '../models/provider_booking_detail_model.dart';

class ProviderBookingRepositoryImpl implements ProviderBookingRepository {
  ProviderBookingRepositoryImpl({ProviderBookingRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ProviderBookingRemoteDataSourceImpl();

  final ProviderBookingRemoteDataSource _remoteDataSource;

  @override
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
  }) async {
    try {
      return await _remoteDataSource.getProviderBookings(
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
      throw UnknownFailure('Failed to load bookings. Please try again.');
    }
  }

  @override
  Future<ProviderBookingDetailModel> getProviderBookingDetail(String bookingId) async {
    try {
      return await _remoteDataSource.getProviderBookingDetail(bookingId);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load booking details. Please try again.');
    }
  }

  @override
  Future<ProviderBookingDetailModel> acceptBooking(String bookingId, {String? amount, String? note}) async {
    try {
      return await _remoteDataSource.acceptBooking(bookingId, amount: amount, note: note);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to accept booking. Please try again.');
    }
  }

  @override
  Future<ProviderBookingDetailModel> cancelBooking(String bookingId, {String? reason}) async {
    try {
      return await _remoteDataSource.cancelBooking(bookingId, reason: reason);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to cancel booking. Please try again.');
    }
  }

  @override
  Future<ProviderBookingDetailModel> completeBooking(String bookingId) async {
    try {
      return await _remoteDataSource.completeBooking(bookingId);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to complete booking. Please try again.');
    }
  }

  @override
  Future<ProviderBookingDetailModel> declineQuote(String bookingId, {required String reason}) async {
    try {
      return await _remoteDataSource.declineQuote(bookingId, reason: reason);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to decline quote. Please try again.');
    }
  }

  @override
  Future<ProviderBookingDetailModel> rejectBooking(String bookingId, {String? reason}) async {
    try {
      return await _remoteDataSource.rejectBooking(bookingId, reason: reason);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to reject booking. Please try again.');
    }
  }

  @override
  Future<ProviderBookingDetailModel> rescheduleBooking(
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
  Future<ProviderBookingDetailModel> rescheduleRespond(String bookingId, {required bool accept}) async {
    try {
      return await _remoteDataSource.rescheduleRespond(bookingId, accept: accept);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to respond to reschedule. Please try again.');
    }
  }

  @override
  Future<ProviderBookingDetailModel> resendCompletionCode(String bookingId) async {
    try {
      return await _remoteDataSource.resendCompletionCode(bookingId);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to resend completion code. Please try again.');
    }
  }

  @override
  Future<ProviderBookingDetailModel> startBooking(String bookingId) async {
    try {
      return await _remoteDataSource.startBooking(bookingId);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to start booking. Please try again.');
    }
  }

  @override
  Future<ProviderBookingDetailModel> verifyCompletion(String bookingId, {String? code}) async {
    try {
      return await _remoteDataSource.verifyCompletion(bookingId, code: code);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to verify completion. Please try again.');
    }
  }
}
