import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import 'package:nchito/core/services/location_service.dart';
import 'package:nchito/features/user/explore/data/models/explore_provider_model.dart';
import 'package:nchito/features/user/explore/data/repositories/explore_repository_impl.dart';
import 'package:nchito/features/user/explore/domain/repositories/explore_repository.dart';
import 'package:nchito/features/user/explore/domain/usecases/get_explore_providers.dart';
import 'package:nchito/features/user/explore/presentation/widgets/explore_sample_data.dart';

class NearProvidersNotifier extends ChangeNotifier {
  NearProvidersNotifier({ExploreRepository? repository})
      : _getExploreProviders =
            GetExploreProviders(repository ?? ExploreRepositoryImpl());

  final GetExploreProviders _getExploreProviders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _loadMoreErrorMessage;
  String? get loadMoreErrorMessage => _loadMoreErrorMessage;

  List<ExploreProviderItemModel> _providers = [];
  List<ExploreProviderItemModel> get providers => _providers;

  List<ExploreProviderEntry> get providerEntries =>
      _providers.map((p) => p.toExploreEntry()).toList();

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

  String _city = 'Lusaka';
  String get city => _city;

  double? _lat;
  double? get lat => _lat;

  double? _lng;
  double? get lng => _lng;

  void setCity(String newCity) {
    if (_city != newCity) {
      _city = newCity;
      fetchNearProviders(refresh: true);
    }
  }

  void setLocation({double? lat, double? lng}) {
    _lat = lat;
    _lng = lng;
    fetchNearProviders(refresh: true);
  }

  /// Initial or refreshed fetch of near providers with current GPS coordinates
  Future<void> fetchNearProviders({bool refresh = false}) async {
    _currentPage = 1;
    _isLoading = true;
    _errorMessage = null;
    _loadMoreErrorMessage = null;
    if (refresh) {
      _providers = [];
    }
    notifyListeners();

    try {
      // Obtain device GPS location if not already obtained
      if (_lat == null || _lng == null) {
        final position = await LocationService.getCurrentPosition();
        if (position != null) {
          _lat = position.latitude;
          _lng = position.longitude;
        }
      }

      final res = await _getExploreProviders(
        city: (_lat == null || _lng == null)
            ? (_city.isNotEmpty ? _city : null)
            : null,
        sort: (_lat != null && _lng != null) ? 'nearest' : null,
        lat: _lat,
        lng: _lng,
        page: 1,
        pageSize: _pageSize,
      );

      _providers = res.data;
      _totalCount = res.count;
      _currentPage = res.currentPage;
      _totalPages = res.totalPages;
      _hasNextPage = res.next != null || _currentPage < _totalPages;
      _errorMessage = null;
    } on Failure catch (failure) {
      _errorMessage = failure.message;
    } catch (e) {
      _errorMessage = 'Failed to load nearby providers. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads next page of near providers and appends to the list
  Future<void> loadMore() async {
    if (_isLoading || _isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;
    _loadMoreErrorMessage = null;
    notifyListeners();

    final nextPage = _currentPage + 1;

    try {
      final res = await _getExploreProviders(
        city: (_lat == null || _lng == null)
            ? (_city.isNotEmpty ? _city : null)
            : null,
        sort: (_lat != null && _lng != null) ? 'nearest' : null,
        lat: _lat,
        lng: _lng,
        page: nextPage,
        pageSize: _pageSize,
      );

      final existingIds = _providers.map((p) => p.id).toSet();
      final newItems = res.data.where((p) => !existingIds.contains(p.id));
      _providers.addAll(newItems);

      _currentPage = res.currentPage > 0 ? res.currentPage : nextPage;
      _totalPages = res.totalPages;
      _totalCount = res.count;
      _hasNextPage = res.next != null || _currentPage < _totalPages;
      _loadMoreErrorMessage = null;
    } on Failure catch (failure) {
      _loadMoreErrorMessage = failure.message;
    } catch (e) {
      _loadMoreErrorMessage = 'Failed to load more nearby providers.';
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}
