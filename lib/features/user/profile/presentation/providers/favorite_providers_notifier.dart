import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import 'package:nchito/features/user/explore/data/models/explore_provider_model.dart';
import 'package:nchito/features/user/explore/data/repositories/explore_repository_impl.dart';
import 'package:nchito/features/user/explore/domain/repositories/explore_repository.dart';
import 'package:nchito/features/user/explore/presentation/widgets/explore_sample_data.dart';

class FavoriteProvidersNotifier extends ChangeNotifier {
  FavoriteProvidersNotifier({ExploreRepository? repository})
      : _repository = repository ?? ExploreRepositoryImpl();

  final ExploreRepository _repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ExploreProviderItemModel> _favorites = [];
  List<ExploreProviderItemModel> get favorites => _favorites;

  List<ExploreProviderEntry> get exploreEntries =>
      _favorites.map((p) => p.toExploreEntry()).toList();

  bool get isEmpty => _favorites.isEmpty;

  Future<void> fetchFavorites({bool refresh = false}) async {
    if (_isLoading && !refresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.getFavorites(page: 1, pageSize: 50);
      _favorites = response.data;
      _errorMessage = null;
    } on Failure catch (f) {
      _errorMessage = f.message;
    } catch (e) {
      _errorMessage = 'Failed to load favorite providers.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleFavorite(String providerId) async {
    final index = _favorites.indexWhere((p) => p.id == providerId);

    if (index != -1) {
      // It is currently in favorites, remove it optimistically
      final removed = _favorites.removeAt(index);
      notifyListeners();

      try {
        final success = await _repository.removeFavorite(providerId);
        if (!success) {
          _favorites.insert(index, removed);
          notifyListeners();
          return false;
        }
        return true;
      } catch (_) {
        _favorites.insert(index, removed);
        notifyListeners();
        return false;
      }
    } else {
      // It is not in favorites, add it
      try {
        final success = await _repository.addFavorite(providerId);
        if (success) {
          await fetchFavorites(refresh: true);
        }
        return success;
      } catch (_) {
        return false;
      }
    }
  }
}
