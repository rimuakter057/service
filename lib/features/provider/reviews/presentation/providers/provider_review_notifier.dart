import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/provider_review_model.dart';
import '../../data/repositories/provider_review_repository_impl.dart';
import '../../domain/repositories/provider_review_repository.dart';

/// The logged-in provider's own reviews + rating breakdown, plus the
/// reply/report actions on an individual review.
class ProviderReviewNotifier extends ChangeNotifier {
  ProviderReviewNotifier({ProviderReviewRepository? repository})
      : _repository = repository ?? ProviderReviewRepositoryImpl();

  final ProviderReviewRepository _repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _actionErrorMessage;
  String? get actionErrorMessage => _actionErrorMessage;

  List<ProviderReviewModel> _reviews = [];
  List<ProviderReviewModel> get reviews => _reviews;

  ProviderReviewBreakdownModel _breakdown = const ProviderReviewBreakdownModel();
  ProviderReviewBreakdownModel get breakdown => _breakdown;

  Future<void> fetchReviews({required String providerId, int? page}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _repository.getReviews(providerId: providerId, page: page);
      _reviews = res.results;
      _errorMessage = null;
    } on Failure catch (f) {
      _errorMessage = f.message;
    } catch (e) {
      _errorMessage = 'Failed to load reviews. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBreakdown({required String providerId}) async {
    try {
      _breakdown = await _repository.getBreakdown(providerId: providerId);
      notifyListeners();
    } on Failure catch (_) {
      // Breakdown is supplementary (star histogram) — a silent failure
      // just leaves the default zeroed breakdown in place.
    } catch (_) {}
  }

  Future<bool> replyToReview(String reviewId, {required String message}) async {
    _isActionLoading = true;
    _actionErrorMessage = null;
    notifyListeners();

    try {
      final updated = await _repository.replyToReview(reviewId, message: message);
      final index = _reviews.indexWhere((r) => r.id == reviewId);
      if (index != -1) _reviews[index] = updated;
      _actionErrorMessage = null;
      return true;
    } on Failure catch (f) {
      _actionErrorMessage = f.message;
      return false;
    } catch (e) {
      _actionErrorMessage = 'Failed to send reply. Please try again.';
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> reportReview(String reviewId, {String? reason}) async {
    _isActionLoading = true;
    _actionErrorMessage = null;
    notifyListeners();

    try {
      await _repository.reportReview(reviewId, reason: reason);
      _actionErrorMessage = null;
      return true;
    } on Failure catch (f) {
      _actionErrorMessage = f.message;
      return false;
    } catch (e) {
      _actionErrorMessage = 'Failed to report review. Please try again.';
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }
}
