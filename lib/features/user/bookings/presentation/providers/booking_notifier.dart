import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/booking_model.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

class BookingNotifier extends ChangeNotifier {
  BookingNotifier({BookingRepository? repository})
      : _createBooking =
            CreateBookingUseCase(repository ?? BookingRepositoryImpl());

  final CreateBookingUseCase _createBooking;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  BookingResponseModel? _createdBooking;
  BookingResponseModel? get createdBooking => _createdBooking;

  Future<BookingHistoryData?> submitBooking({
    required CreateBookingRequestModel request,
    HomeProviderData? fallbackProvider,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _createBooking(request);
      _createdBooking = response;
      _errorMessage = null;
      final bookingData =
          response.toBookingHistoryData(fallbackProvider: fallbackProvider);
      return bookingData;
    } on Failure catch (failure) {
      _errorMessage = failure.message;
      return null;
    } catch (e) {
      _errorMessage = 'Failed to submit booking request. Please try again.';
      return null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
