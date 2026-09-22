import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/customer_review_model.dart';
import '../../data/repositories/customer_review_repository_impl.dart';
import '../../domain/repositories/customer_review_repository.dart';

/// A provider's public review list (Provider Details' "Reviews" ->
/// [AllReviewsScreen]) plus submitting a new review for a completed
/// booking (Leave a Review bottom sheet).
class CustomerReviewNotifier extends ChangeNotifier {
  CustomerReviewNotifier({CustomerReviewRepository? repository})
      : _repository = repository ?? CustomerReviewRepositoryImpl();

  final CustomerReviewRepository _repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _submitErrorMessage;
  String? get submitErrorMessage => _submitErrorMessage;

  List<CustomerReviewModel> _reviews = [];
  List<CustomerReviewModel> get reviews => _reviews;

  int _count = 0;
  int get count => _count;

  String? _currentProviderId;

  Future<void> fetchReviews({required String providerId, bool refresh = false}) async {
    if (_currentProviderId == providerId && _reviews.isNotEmpty && !refresh) return;

    _currentProviderId = providerId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _repository.getReviews(providerId: providerId);
      _reviews = res.results;
      _count = res.count;
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

  Future<bool> submitReview({
    required String booking,
    required int rating,
    String? comment,
  }) async {
    _isSubmitting = true;
    _submitErrorMessage = null;
    notifyListeners();

    try {
      final review = await _repository.createReview(
        booking: booking,
        rating: rating,
        comment: comment,
      );
      _reviews.insert(0, review);
      _count += 1;
      _submitErrorMessage = null;
      return true;
    } on Failure catch (f) {
      _submitErrorMessage = f.message;
      return false;
    } catch (e) {
      _submitErrorMessage = 'Failed to submit review. Please try again.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
