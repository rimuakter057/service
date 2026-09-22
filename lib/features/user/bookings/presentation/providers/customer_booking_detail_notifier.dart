import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/customer_booking_detail_model.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/usecases/get_customer_booking_detail_usecase.dart';
class CustomerBookingDetailNotifier extends ChangeNotifier {
  CustomerBookingDetailNotifier({
    BookingRepository? repository,
    GetCustomerBookingDetailUseCase? getCustomerBookingDetailUseCase,
  })  : _repository = repository ?? BookingRepositoryImpl(),
        _getBookingDetail = getCustomerBookingDetailUseCase ??
            GetCustomerBookingDetailUseCase(repository ?? BookingRepositoryImpl());

  final BookingRepository _repository;
  final GetCustomerBookingDetailUseCase _getBookingDetail;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _actionErrorMessage;
  String? get actionErrorMessage => _actionErrorMessage;

  CustomerBookingDetailModel? _bookingDetail;
  CustomerBookingDetailModel? get bookingDetail => _bookingDetail;

  String? _currentBookingId;
  String? get currentBookingId => _currentBookingId;

  Future<void> fetchBookingDetail(String bookingId, {bool refresh = false}) async {
    if (_currentBookingId == bookingId && _bookingDetail != null && !refresh) {
      return;
    }

    _currentBookingId = bookingId;
    _bookingDetail = null;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookingDetail = await _getBookingDetail(bookingId);
      _errorMessage = null;
    } on Failure catch (failure) {
      _errorMessage = failure.message;
    } catch (e) {
      _errorMessage = 'Failed to load booking details. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _executeAction(
    Future<CustomerBookingDetailModel> Function() action, {
    required String defaultError,
  }) async {
    _isActionLoading = true;
    _actionErrorMessage = null;
    notifyListeners();

    try {
      final updated = await action();
      _bookingDetail = updated;
      _actionErrorMessage = null;
      return true;
    } on Failure catch (failure) {
      _actionErrorMessage = failure.message;
      return false;
    } catch (e) {
      _actionErrorMessage = defaultError;
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelBooking(String bookingId, {String? reason}) async {
    return _executeAction(
      () => _repository.cancelBooking(bookingId, reason: reason),
      defaultError: 'Failed to cancel booking. Please try again.',
    );
  }

  Future<bool> declineQuote(String bookingId, {required String reason}) async {
    return _executeAction(
      () => _repository.declineQuote(bookingId, reason: reason),
      defaultError: 'Failed to decline quote. Please try again.',
    );
  }

  Future<bool> acceptBooking(String bookingId, {String? amount, String? note}) async {
    return _executeAction(
      () => _repository.acceptBooking(bookingId, amount: amount, note: note),
      defaultError: 'Failed to accept quote. Please try again.',
    );
  }

  Future<bool> completeBooking(String bookingId) async {
    return _executeAction(
      () => _repository.completeBooking(bookingId),
      defaultError: 'Failed to complete booking. Please try again.',
    );
  }

  Future<bool> rejectBooking(String bookingId, {String? reason}) async {
    return _executeAction(
      () => _repository.rejectBooking(bookingId, reason: reason),
      defaultError: 'Failed to reject booking. Please try again.',
    );
  }

  Future<bool> rescheduleBooking(
    String bookingId, {
    required String scheduledDate,
    required String scheduledTime,
    String? reason,
  }) async {
    return _executeAction(
      () => _repository.rescheduleBooking(
        bookingId,
        scheduledDate: scheduledDate,
        scheduledTime: scheduledTime,
        reason: reason,
      ),
      defaultError: 'Failed to reschedule booking. Please try again.',
    );
  }

  Future<bool> rescheduleRespond(String bookingId, {required bool accept}) async {
    return _executeAction(
      () => _repository.rescheduleRespond(bookingId, accept: accept),
      defaultError: 'Failed to respond to reschedule. Please try again.',
    );
  }

  Future<bool> resendCompletionCode(String bookingId) async {
    return _executeAction(
      () => _repository.resendCompletionCode(bookingId),
      defaultError: 'Failed to resend completion code. Please try again.',
    );
  }

  Future<bool> startBooking(String bookingId) async {
    return _executeAction(
      () => _repository.startBooking(bookingId),
      defaultError: 'Failed to start booking. Please try again.',
    );
  }

  Future<bool> verifyCompletion(String bookingId) async {
    return _executeAction(
      () => _repository.verifyCompletion(bookingId),
      defaultError: 'Failed to verify completion. Please try again.',
    );
  }

  void clear() {
    _bookingDetail = null;
    _errorMessage = null;
    _actionErrorMessage = null;
    _isLoading = false;
    _isActionLoading = false;
    _currentBookingId = null;
    notifyListeners();
  }
}
