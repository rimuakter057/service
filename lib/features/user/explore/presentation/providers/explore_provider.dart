import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/explore_provider_model.dart';
import '../../data/repositories/explore_repository_impl.dart';
import '../../domain/repositories/explore_repository.dart';
import '../../domain/usecases/get_explore_providers.dart';
import 'package:nchito/core/services/location_service.dart';
import '../widgets/explore_sample_data.dart';

class ExploreProviderNotifier extends ChangeNotifier {
  ExploreProviderNotifier({ExploreRepository? repository})
      : _repository = repository ?? ExploreRepositoryImpl(),
        _getExploreProviders =
            GetExploreProviders(repository ?? ExploreRepositoryImpl());

  final ExploreRepository _repository;
  final GetExploreProviders _getExploreProviders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _loadMoreErrorMessage;
  String? get loadMoreErrorMessage => _loadMoreErrorMessage;

  ExploreProvidersResponseModel? _response;
  ExploreProvidersResponseModel? get response => _response;

  List<ExploreProviderItemModel> _providers = [];
  List<ExploreProviderItemModel> get providers => _providers;

  List<ExploreProviderEntry> get exploreEntries =>
      _providers.map((p) => p.toExploreEntry()).toList();

  String _emptyMessage = "We Couldn't Find Any Matches.";
  String get emptyMessage => _emptyMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  final int _pageSize = 10;
  int get pageSize => _pageSize;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  bool _hasNextPage = false;
  bool get hasNextPage => _hasNextPage;

  Timer? _debounceTimer;

  // Active filters
  String? _currentCategory;
  String? _currentCity;
  double? _currentMinPrice;
  double? _currentMaxPrice;
  double? _currentMinRating;
  String? _currentSort;
  String? _currentDate;
  double? _currentLat;
  double? _currentLng;

  static const double defaultLat = -15.3875;
  static const double defaultLng = 28.3228;

  String? get currentCategory => _currentCategory;
  String? get currentCity => _currentCity;
  double? get currentMinPrice => _currentMinPrice;
  double? get currentMaxPrice => _currentMaxPrice;
  double? get currentMinRating => _currentMinRating;
  String? get currentSort => _currentSort;
  String? get currentDate => _currentDate;
  double? get currentLat => _currentLat;
  double? get currentLng => _currentLng;

  bool get hasActiveFilters =>
      (_currentCategory != null && _currentCategory!.isNotEmpty) ||
      (_currentCity != null && _currentCity!.isNotEmpty) ||
      (_currentMinPrice != null && _currentMinPrice! > 0) ||
      (_currentMaxPrice != null && _currentMaxPrice! < 500) ||
      (_currentMinRating != null && _currentMinRating! > 0) ||
      (_currentSort != null &&
          _currentSort!.isNotEmpty &&
          _currentSort != 'recommended') ||
      (_currentDate != null && _currentDate!.isNotEmpty);

  /// Apply all filters and refresh page 1
  Future<void> applyFilters({
    String? category,
    String? city,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sort,
    String? date,
    double? lat,
    double? lng,
  }) async {
    _currentCategory = category;
    _currentCity = city;
    _currentMinPrice = minPrice;
    _currentMaxPrice = maxPrice;
    _currentMinRating = minRating;
    _currentSort = sort;
    _currentDate = date;
    _currentLat = lat;
    _currentLng = lng;

    await fetchProviders(refresh: true);
  }

  /// Reset all filters back to default and refresh
  Future<void> resetFilters() async {
    _currentCategory = null;
    _currentCity = null;
    _currentMinPrice = null;
    _currentMaxPrice = null;
    _currentMinRating = null;
    _currentSort = null;
    _currentDate = null;
    _currentLat = null;
    _currentLng = null;

    await fetchProviders(refresh: true);
  }

  /// Reset everything (search and all filters) to fetch all data on refresh
  Future<void> refreshAll() async {
    _searchQuery = '';
    _currentCategory = null;
    _currentCity = null;
    _currentMinPrice = null;
    _currentMaxPrice = null;
    _currentMinRating = null;
    _currentSort = null;
    _currentDate = null;
    _currentLat = null;
    _currentLng = null;

    await fetchProviders(search: '', refresh: true);
  }

  /// Initial or refreshed fetch (loads page 1 with page_size = 10)
  Future<void> fetchProviders({
    String? search,
    String? category,
    String? city,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sort,
    String? date,
    double? lat,
    double? lng,
    bool refresh = false,
  }) async {
    if (search != null) _searchQuery = search;
    if (category != null) _currentCategory = category;
    if (city != null) _currentCity = city;
    if (minPrice != null) _currentMinPrice = minPrice;
    if (maxPrice != null) _currentMaxPrice = maxPrice;
    if (minRating != null) _currentMinRating = minRating;
    if (sort != null) _currentSort = sort;
    if (date != null) _currentDate = date;
    if (lat != null) _currentLat = lat;
    if (lng != null) _currentLng = lng;

    // If sorting by nearest, automatically acquire device lat/lng if not provided
    if (_currentSort == 'nearest') {
      if (_currentLat == null || _currentLng == null) {
        final position = await LocationService.getCurrentPosition();
        if (position != null) {
          _currentLat = position.latitude;
          _currentLng = position.longitude;
        } else {
          _currentLat = defaultLat;
          _currentLng = defaultLng;
        }
      }
    }

    _currentPage = 1;
    _isLoading = true;
    _errorMessage = null;
    _loadMoreErrorMessage = null;
    if (refresh) {
      _providers = [];
    }
    notifyListeners();

    try {
      final res = await _getExploreProviders(
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        category: _currentCategory,
        city: _currentCity,
        minPrice: _currentMinPrice,
        maxPrice: _currentMaxPrice,
        minRating: _currentMinRating,
        sort: _currentSort,
        date: _currentDate,
        lat: _currentLat,
        lng: _currentLng,
        page: 1,
        pageSize: _pageSize,
      );

      _response = res;
      _providers = res.data;
      _currentPage = res.currentPage;
      _totalPages = res.totalPages;
      _hasNextPage = res.next != null || _currentPage < _totalPages;
      if (res.emptyMessage.isNotEmpty) {
        _emptyMessage = res.emptyMessage;
      }
      _errorMessage = null;
    } on Failure catch (failure) {
      _errorMessage = failure.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads the next page (e.g. page = 2, page_size = 10) and appends to existing providers
  Future<void> loadMore() async {
    if (_isLoading || _isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;
    _loadMoreErrorMessage = null;
    notifyListeners();

    final nextPage = _currentPage + 1;

    try {
      final res = await _getExploreProviders(
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        category: _currentCategory,
        city: _currentCity,
        minPrice: _currentMinPrice,
        maxPrice: _currentMaxPrice,
        minRating: _currentMinRating,
        sort: _currentSort,
        date: _currentDate,
        lat: _currentLat,
        lng: _currentLng,
        page: nextPage,
        pageSize: _pageSize,
      );

      // Deduplicate by ID to prevent duplicate items in list
      final existingIds = _providers.map((p) => p.id).toSet();
      final newItems = res.data.where((p) => !existingIds.contains(p.id));
      _providers.addAll(newItems);

      _currentPage = res.currentPage > 0 ? res.currentPage : nextPage;
      _totalPages = res.totalPages;
      _hasNextPage = res.next != null || _currentPage < _totalPages;
      _response = res;
      _loadMoreErrorMessage = null;
    } on Failure catch (failure) {
      _loadMoreErrorMessage = failure.message;
    } catch (e) {
      _loadMoreErrorMessage = 'Failed to load more providers.';
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String providerId) async {
    final index = _providers.indexWhere((p) => p.id == providerId);
    if (index == -1) return;

    final currentItem = _providers[index];
    final newFavorited = !currentItem.isFavorited;

    // Optimistic UI update
    _providers[index] = ExploreProviderItemModel(
      id: currentItem.id,
      fullName: currentItem.fullName,
      businessName: currentItem.businessName,
      avatar: currentItem.avatar,
      headline: currentItem.headline,
      serviceTypes: currentItem.serviceTypes,
      serviceTypeNames: currentItem.serviceTypeNames,
      serviceTypeChips: currentItem.serviceTypeChips,
      serviceArea: currentItem.serviceArea,
      city: currentItem.city,
      startingPrice: currentItem.startingPrice,
      currency: currentItem.currency,
      ratingAverage: currentItem.ratingAverage,
      ratingCount: currentItem.ratingCount,
      totalJobsCompleted: currentItem.totalJobsCompleted,
      isVerified: currentItem.isVerified,
      isAcceptingBookings: currentItem.isAcceptingBookings,
      isFavorited: newFavorited,
    );
    notifyListeners();

    try {
      if (newFavorited) {
        await _repository.addFavorite(providerId);
      } else {
        await _repository.removeFavorite(providerId);
      }
    } catch (_) {
      // Revert optimistic update on failure
      if (index < _providers.length && _providers[index].id == providerId) {
        _providers[index] = currentItem;
        notifyListeners();
      }
    }
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      fetchProviders(search: query.trim(), refresh: true);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
