import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/provider_dispute_model.dart';
import '../../data/repositories/provider_dispute_repository_impl.dart';
import '../../domain/repositories/provider_dispute_repository.dart';

/// Mirrors `CustomerDisputeNotifier` for the provider's side of a dispute
/// — listing disputes raised against the provider's bookings and
/// responding to / cancelling one.
class ProviderDisputeNotifier extends ChangeNotifier {
  ProviderDisputeNotifier({ProviderDisputeRepository? repository})
      : _repository = repository ?? ProviderDisputeRepositoryImpl();

  final ProviderDisputeRepository _repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _actionErrorMessage;
  String? get actionErrorMessage => _actionErrorMessage;

  List<ProviderDisputeModel> _disputes = [];
  List<ProviderDisputeModel> get disputes => _disputes;

  ProviderDisputeModel? _activeDispute;
  ProviderDisputeModel? get activeDispute => _activeDispute;

  String? _currentDisputeId;
  String? get currentDisputeId => _currentDisputeId;

  Future<void> fetchDisputes({int? page, bool refresh = false}) async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _repository.getProviderDisputes(page: page);
      _disputes = res.results;
      _errorMessage = null;
    } on Failure catch (f) {
      _errorMessage = f.message;
    } catch (e) {
      _errorMessage = 'Failed to load disputes. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDisputeDetail(String disputeId, {bool refresh = false}) async {
    if (_currentDisputeId == disputeId && _activeDispute != null && !refresh) {
      return;
    }

    _currentDisputeId = disputeId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _activeDispute = await _repository.getDisputeDetail(disputeId);
      _errorMessage = null;
    } on Failure catch (f) {
      _errorMessage = f.message;
    } catch (e) {
      _errorMessage = 'Failed to load dispute details. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelDispute(String disputeId, {String? reason}) async {
    _isActionLoading = true;
    _actionErrorMessage = null;
    notifyListeners();

    try {
      final updated = await _repository.cancelDispute(disputeId, reason: reason);
      _activeDispute = updated;
      _actionErrorMessage = null;
      return true;
    } on Failure catch (f) {
      _actionErrorMessage = f.message;
      return false;
    } catch (e) {
      _actionErrorMessage = 'Failed to cancel dispute. Please try again.';
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> respondDispute(
    String disputeId, {
    required String message,
    List<String>? evidenceFiles,
  }) async {
    _isActionLoading = true;
    _actionErrorMessage = null;
    notifyListeners();

    try {
      final updated = await _repository.respondDispute(
        disputeId,
        message: message,
        evidenceFiles: evidenceFiles,
      );
      _activeDispute = updated;
      _actionErrorMessage = null;
      return true;
    } on Failure catch (f) {
      _actionErrorMessage = f.message;
      return false;
    } catch (e) {
      _actionErrorMessage = 'Failed to respond to dispute. Please try again.';
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _disputes = [];
    _activeDispute = null;
    _currentDisputeId = null;
    _errorMessage = null;
    _actionErrorMessage = null;
    _isLoading = false;
    _isActionLoading = false;
    notifyListeners();
  }
}
