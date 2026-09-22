import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/company_info_model.dart';
import '../../data/repositories/cms_support_repository_impl.dart';
import '../../domain/repositories/cms_support_repository.dart';

class BaseCompanyNotifier extends ChangeNotifier {
  final CmsSupportRepository _repository;
  final bool isProvider;

  BaseCompanyNotifier({
    CmsSupportRepository? repository,
    required this.isProvider,
  }) : _repository = repository ?? CmsSupportRepositoryImpl();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  CompanyInfoModel? _companyInfo;
  CompanyInfoModel? get companyInfo => _companyInfo;

  Future<void> fetchCompanyInfo({bool forceRefresh = false}) async {
    if (_companyInfo != null && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getCompanyInfo(isProvider: isProvider);
      _companyInfo = result;
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
}

class CompanyNotifier extends BaseCompanyNotifier {
  CompanyNotifier({super.repository}) : super(isProvider: false);
}

class ProviderCompanyNotifier extends BaseCompanyNotifier {
  ProviderCompanyNotifier({super.repository}) : super(isProvider: true);
}
