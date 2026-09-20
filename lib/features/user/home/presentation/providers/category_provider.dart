import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_categories.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryProvider({HomeRepository? repository})
      : _getCategories = GetCategories(repository ?? HomeRepositoryImpl());

  final GetCategories _getCategories;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  static const String viewMoreId = '__view_more__';
  static const String viewLessId = '__view_less__';

  void toggleExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  void setExpanded(bool value) {
    if (_isExpanded != value) {
      _isExpanded = value;
      notifyListeners();
    }
  }

  /// Returns the categories to display on the Home screen.
  /// Initially returns 8 items (7 categories + View More).
  /// When expanded, returns all categories (+ View Less).
  List<Category> get homeDisplayedCategories {
    if (_categories.isEmpty) return [];

    if (_categories.length <= 8) {
      return _categories;
    }

    if (!_isExpanded) {
      return <Category>[
        ..._categories.take(7),
        const Category(
          id: viewMoreId,
          name: 'View More',
          slug: 'view-more',
        ),
      ];
    } else {
      return <Category>[
        ..._categories,
        const Category(
          id: viewLessId,
          name: 'View Less',
          slug: 'view-less',
        ),
      ];
    }
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _getCategories();
      _isLoading = false;
      notifyListeners();
    } on Failure catch (failure) {
      _errorMessage = failure.message;
      _isLoading = false;
      notifyListeners();
    } catch (_) {
      _errorMessage = 'Failed to load categories.';
      _isLoading = false;
      notifyListeners();
    }
  }
}
