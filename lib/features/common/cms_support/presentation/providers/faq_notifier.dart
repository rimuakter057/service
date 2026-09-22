import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/faq_model.dart';
import '../../data/repositories/cms_support_repository_impl.dart';
import '../../domain/repositories/cms_support_repository.dart';

class BaseFaqNotifier extends ChangeNotifier {
  final CmsSupportRepository _repository;
  final bool isProvider;

  BaseFaqNotifier({
    CmsSupportRepository? repository,
    required this.isProvider,
  }) : _repository = repository ?? CmsSupportRepositoryImpl();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<FaqItemModel> _faqs = [];
  List<FaqItemModel> get faqs => _faqs;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Timer? _debounceTimer;

  Future<void> fetchFaqs({
    String? search,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _faqs.isNotEmpty && search == null) return;

    _isLoading = true;
    _errorMessage = null;
    if (search != null) {
      _searchQuery = search;
    }
    notifyListeners();

    try {
      final response = await _repository.getFaqs(
        isProvider: isProvider,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      _faqs = response.items;
      _errorMessage = null;
    } on Failure catch (f) {
      _errorMessage = f.message;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      fetchFaqs(search: query, forceRefresh: true);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

class FaqNotifier extends BaseFaqNotifier {
  FaqNotifier({super.repository}) : super(isProvider: false);
}

class ProviderFaqNotifier extends BaseFaqNotifier {
  ProviderFaqNotifier({super.repository}) : super(isProvider: true);
}
