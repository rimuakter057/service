import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/provider_booking_model.dart';
import '../../data/repositories/provider_booking_repository_impl.dart';
import '../../domain/repositories/provider_booking_repository.dart';
import '../../domain/usecases/get_provider_bookings_usecase.dart';
import '../widgets/provider_booking_sample_data.dart';

/// Mirrors `CustomerBookingsNotifier` — same loading/pagination/search/
/// filter shape, wired to `GET /provider/bookings/` instead.
class ProviderBookingsNotifier extends ChangeNotifier {
  ProviderBookingsNotifier({ProviderBookingRepository? repository})
      : _getBookings = GetProviderBookingsUseCase(
            repository ?? ProviderBookingRepositoryImpl());

  final GetProviderBookingsUseCase _getBookings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _loadMoreErrorMessage;
  String? get loadMoreErrorMessage => _loadMoreErrorMessage;

  List<ProviderBookingModel> _bookings = [];
  List<ProviderBookingModel> get bookings => _bookings;

  List<ProviderBookingData> get bookingEntries =>
      _bookings.map((b) => b.toProviderBookingData()).toList();

  String _selectedGroup = 'all';
  String get selectedGroup => _selectedGroup;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  /// YYYY-MM-DD date filter — set via calendar tap; mutually exclusive
  /// with [_filterToday].
  String? _selectedDate;
  String? get selectedDate => _selectedDate;

  /// When true, passes `today=true` to the API (Home screen's
  /// "Today's Bookings" section).  Cleared whenever [_selectedDate] is set.
  bool _filterToday = false;
  bool get filterToday => _filterToday;

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

  bool get hasDateFilter => _selectedDate != null || _filterToday;

  bool get isEmpty => !_isLoading && _bookings.isEmpty;

  Timer? _debounceTimer;

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
        date: _selectedDate,
        today: _filterToday ? true : null,
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
        date: _selectedDate,
        today: _filterToday ? true : null,
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

  /// Filter by a specific calendar date (format: YYYY-MM-DD).
  Future<void> fetchBookingsByDate(DateTime date) async {
    _selectedDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    _filterToday = false;
    await fetchBookings(refresh: true);
  }

  /// Filter with `today=true` — used on the Home screen and the
  /// "Today" shortcut on the Bookings screen.
  Future<void> fetchTodaysBookings() async {
    _filterToday = true;
    _selectedDate = null;
    await fetchBookings(refresh: true);
  }

  /// Remove date/today filter and reload all bookings.
  Future<void> clearDateFilter() async {
    _selectedDate = null;
    _filterToday = false;
    await fetchBookings(refresh: true);
  }

  Future<void> applyFilter(String groupValue) async {
    _selectedGroup = groupValue;
    await fetchBookings(refresh: true);
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      fetchBookings(refresh: true);
    });
  }

  Future<void> clearSearch() async {
    _searchQuery = '';
    _debounceTimer?.cancel();
    await fetchBookings(refresh: true);
  }

  Future<void> resetFilters() async {
    _selectedGroup = 'all';
    _searchQuery = '';
    _selectedDate = null;
    _filterToday = false;
    _debounceTimer?.cancel();
    await fetchBookings(refresh: true);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
