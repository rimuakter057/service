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
      );

      _bookings = response.results;
      _totalCount = response.count;
      _totalPages = response.totalPages;
      _currentPage = response.currentPage;
      _hasNextPage = response.next != null && response.next!.isNotEmpty;
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
        page: nextPage,
        pageSize: _pageSize,
      );

      _bookings.addAll(response.results);
      _currentPage = response.currentPage;
      _totalPages = response.totalPages;
      _hasNextPage = response.next != null && response.next!.isNotEmpty;
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
    _debounceTimer?.cancel();
    await fetchBookings(refresh: true);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
