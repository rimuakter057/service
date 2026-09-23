import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/booking_model.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/usecases/get_customer_bookings_usecase.dart';
import '../widgets/bookings_sample_data.dart';

class CustomerBookingsNotifier extends ChangeNotifier {
  CustomerBookingsNotifier({BookingRepository? repository})
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

  List<BookingResponseModel> _bookings = [];
  List<BookingResponseModel> get bookings => _bookings;

  List<BookingHistoryData> get bookingEntries =>
      _bookings.map((b) => b.toBookingHistoryData()).toList();

  String _selectedGroup = 'all';
  String get selectedGroup => _selectedGroup;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  final int _pageSize = 10;
  int get pageSize => _pageSize;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  int _totalCount = 0;
  int get totalCount => _totalCount;

  bool _hasNextPage = false;
  bool get hasNextPage => _hasNextPage;

  String get emptyMessage => "We Couldn't Find Any Matches.";

  bool get hasActiveFilter => _selectedGroup != 'all';

  bool get hasSearchQuery => _searchQuery.trim().isNotEmpty;

  bool get isEmpty => !_isLoading && _bookings.isEmpty;

  Timer? _debounceTimer;

  /// Initial or refreshed fetch of bookings
  Future<void> fetchBookings({bool refresh = false}) async {
    _currentPage = 1;
    _isLoading = true;
    _errorMessage = null;
    _loadMoreErrorMessage = null;
    if (refresh) {
      _bookings = [];
    }
    notifyListeners();

    try {
      final response = await _getBookings(
        group: _selectedGroup == 'all' ? null : _selectedGroup,
        search: _searchQuery.trim().isNotEmpty ? _searchQuery.trim() : null,
        page: 1,
        pageSize: _pageSize,
      );

      _bookings = response.results;
      _totalCount = response.count;
      _totalPages = response.totalPages;
      _currentPage = response.currentPage;
      _hasNextPage = (response.next != null && response.next!.isNotEmpty) ||
          (_currentPage < _totalPages);
      _errorMessage = null;
    } on Failure catch (failure) {
      _errorMessage = failure.message;
    } catch (e) {
      _errorMessage = 'Failed to load bookings. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch next page for infinite scrolling / pagination if server provides next link
  Future<void> loadMoreBookings() async {
    if (_isLoadingMore || !_hasNextPage || _isLoading) return;

    _isLoadingMore = true;
    _loadMoreErrorMessage = null;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _getBookings(
        group: _selectedGroup == 'all' ? null : _selectedGroup,
        search: _searchQuery.trim().isNotEmpty ? _searchQuery.trim() : null,
        page: nextPage,
        pageSize: _pageSize,
      );

      final existingIds = _bookings.map((b) => b.id).toSet();
      final newItems = response.results.where((b) => !existingIds.contains(b.id));
      _bookings.addAll(newItems);
      _currentPage = response.currentPage > 0 ? response.currentPage : nextPage;
      _totalPages = response.totalPages;
      _totalCount = response.count;
      _hasNextPage = (response.next != null && response.next!.isNotEmpty) ||
          (_currentPage < _totalPages);
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

  /// Apply group filter (e.g. 'all', 'pending', 'scheduled', 'completed', 'cancelled', 'rejected', etc.)
  Future<void> applyFilter(String groupValue) async {
    _selectedGroup = groupValue;
    await fetchBookings(refresh: true);
  }

  /// Search query handler with debounce
  void onSearchChanged(String query) {
    _searchQuery = query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      fetchBookings(refresh: true);
    });
  }

  /// Clear active search
  Future<void> clearSearch() async {
    _searchQuery = '';
    _debounceTimer?.cancel();
    await fetchBookings(refresh: true);
  }

  /// Reset all filters to default
  Future<void> resetFilters() async {
    _selectedGroup = 'all';
    _searchQuery = '';
    _debounceTimer?.cancel();
    await fetchBookings(refresh: true);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
