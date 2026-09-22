import 'package:nchito/core/errors/exceptions.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../domain/repositories/provider_review_repository.dart';
import '../datasources/provider_review_remote_datasource.dart';
import '../models/provider_review_model.dart';

class ProviderReviewRepositoryImpl implements ProviderReviewRepository {
  ProviderReviewRepositoryImpl({ProviderReviewRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ProviderReviewRemoteDataSourceImpl();

  final ProviderReviewRemoteDataSource _remoteDataSource;

  @override
  Future<ProviderReviewsResponseModel> getReviews({
    required String providerId,
    int? page,
  }) async {
    try {
      return await _remoteDataSource.getReviews(providerId: providerId, page: page);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load reviews. Please try again.');
    }
  }

  @override
  Future<ProviderReviewBreakdownModel> getBreakdown({
    required String providerId,
  }) async {
    try {
      return await _remoteDataSource.getBreakdown(providerId: providerId);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load rating breakdown. Please try again.');
    }
  }

  @override
  Future<ProviderReviewModel> getReviewDetail(String reviewId) async {
    try {
      return await _remoteDataSource.getReviewDetail(reviewId);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load review. Please try again.');
    }
  }

  @override
  Future<ProviderReviewModel> replyToReview(
    String reviewId, {
    required String message,
  }) async {
    try {
      return await _remoteDataSource.replyToReview(reviewId, message: message);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to send reply. Please try again.');
    }
  }

  @override
  Future<void> reportReview(String reviewId, {String? reason}) async {
    try {
      await _remoteDataSource.reportReview(reviewId, reason: reason);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to report review. Please try again.');
    }
  }
}
