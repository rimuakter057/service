import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/catalog_search_model.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/search_catalog.dart';
import 'package:nchito/features/user/explore/data/models/explore_provider_model.dart';

class HomeSearchNotifier extends ChangeNotifier {
  HomeSearchNotifier({HomeRepository? repository})
      : _searchCatalog = SearchCatalog(repository ?? HomeRepositoryImpl());

  final SearchCatalog _searchCatalog;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CatalogSearchResultModel? _searchResult;
  CatalogSearchResultModel? get searchResult => _searchResult;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Timer? _debounceTimer;

  bool get hasActiveSearch => _searchQuery.trim().isNotEmpty;

  List<CatalogServiceModel> get services => _searchResult?.services ?? [];
  List<ExploreProviderItemModel> get providers => _searchResult?.providers ?? [];

  void onSearchChanged(String query) {
    _searchQuery = query;
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      _searchResult = null;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query.trim());
    });
  }

  Future<void> searchImmediately(String query) async {
    _debounceTimer?.cancel();
    _searchQuery = query;

    if (query.trim().isEmpty) {
      _searchResult = null;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    await _performSearch(query.trim());
  }

  Future<void> _performSearch(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _searchCatalog(query);
      _searchResult = result;
      _isLoading = false;
      notifyListeners();
    } on Failure catch (failure) {
      _errorMessage = failure.message;
      _isLoading = false;
      notifyListeners();
    } catch (_) {
      _errorMessage = 'Failed to search catalog.';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    _searchQuery = '';
    _searchResult = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
