import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import 'package:nchito/features/user/bookings/data/models/booking_model.dart';
import 'package:nchito/features/user/bookings/data/repositories/booking_repository_impl.dart';
import 'package:nchito/features/user/bookings/domain/repositories/booking_repository.dart';
import 'package:nchito/features/user/bookings/domain/usecases/get_customer_bookings_usecase.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

class OngoingBookingsNotifier extends ChangeNotifier {
  OngoingBookingsNotifier({BookingRepository? repository})
      : _getBookings =
            GetCustomerBookingsUseCase(repository ?? BookingRepositoryImpl());

  final GetCustomerBookingsUseCase _getBookings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _loadMoreErrorMessage;
  String? get loadMoreErrorMessage => _loadMoreErrorMessage;

  List<BookingResponseModel> _rawBookings = [];
  List<BookingResponseModel> get rawBookings => _rawBookings;

  List<HomeBookingData> get homeBookings =>
      _rawBookings.map((b) => b.toHomeBookingData()).toList();

  int _currentPage = 1;
  int get currentPage => _currentPage;

  final int _pageSize = 5;
  int get pageSize => _pageSize;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  int _totalCount = 0;
  int get totalCount => _totalCount;

  bool _hasNextPage = false;
  bool get hasNextPage => _hasNextPage;

  /// Initial or refreshed fetch of ongoing bookings
  Future<void> fetchOngoingBookings({bool refresh = false}) async {
    _currentPage = 1;
    _isLoading = true;
    _errorMessage = null;
    _loadMoreErrorMessage = null;
    if (refresh) {
      _rawBookings = [];
    }
    notifyListeners();

    try {
      final res = await _getBookings(
        group: 'ongoing',
        page: 1,
        pageSize: _pageSize,
      );

      _rawBookings = res.results;
      _totalCount = res.count;
      _currentPage = res.currentPage;
      _totalPages = res.totalPages;
      _hasNextPage = res.next != null || _currentPage < _totalPages;
      _errorMessage = null;
    } on Failure catch (failure) {
      _errorMessage = failure.message;
    } catch (e) {
      _errorMessage = 'Failed to load ongoing bookings. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads next page of ongoing bookings and appends to the list
  Future<void> loadMore() async {
    if (_isLoading || _isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;
    _loadMoreErrorMessage = null;
    notifyListeners();

    final nextPage = _currentPage + 1;

    try {
      final res = await _getBookings(
        group: 'ongoing',
        page: nextPage,
        pageSize: _pageSize,
      );

      final existingIds = _rawBookings.map((b) => b.id).toSet();
      final newItems = res.results.where((b) => !existingIds.contains(b.id));
      _rawBookings.addAll(newItems);

      _currentPage = res.currentPage > 0 ? res.currentPage : nextPage;
      _totalPages = res.totalPages;
      _totalCount = res.count;
      _hasNextPage = res.next != null || _currentPage < _totalPages;
      _loadMoreErrorMessage = null;
    } on Failure catch (failure) {
      _loadMoreErrorMessage = failure.message;
    } catch (e) {
      _loadMoreErrorMessage = 'Failed to load more bookings.';
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}
