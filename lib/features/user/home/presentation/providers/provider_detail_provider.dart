import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/provider_detail_model.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_provider_details.dart';
import '../widgets/home_sample_data.dart';

class ProviderDetailNotifier extends ChangeNotifier {
  ProviderDetailNotifier({HomeRepository? repository})
      : _getProviderDetails =
            GetProviderDetails(repository ?? HomeRepositoryImpl());

  final GetProviderDetails _getProviderDetails;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProviderDetailModel? _detailModel;
  ProviderDetailModel? get detailModel => _detailModel;

  HomeProviderData? _providerData;
  HomeProviderData? get providerData => _providerData;

  Future<void> fetchProviderDetails(String id, {HomeProviderData? fallback}) async {
    _isLoading = true;
    _errorMessage = null;
    if (fallback != null) {
      _providerData = fallback;
    }
    notifyListeners();

    try {
      final model = await _getProviderDetails(id);
      _detailModel = model;
      _providerData = model.toHomeProviderData(fallback: fallback);
      _errorMessage = null;
    } on Failure catch (failure) {
      _errorMessage = failure.message;
    } catch (e) {
      _errorMessage = 'Failed to load provider details.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
