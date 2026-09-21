import 'package:nchito/core/errors/exceptions.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';
import '../models/booking_model.dart';

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
}
