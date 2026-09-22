import 'package:nchito/core/errors/exceptions.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../domain/repositories/customer_review_repository.dart';
import '../datasources/customer_review_remote_datasource.dart';
import '../models/customer_review_model.dart';

class CustomerReviewRepositoryImpl implements CustomerReviewRepository {
  CustomerReviewRepositoryImpl({CustomerReviewRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? CustomerReviewRemoteDataSourceImpl();

  final CustomerReviewRemoteDataSource _remoteDataSource;

  @override
  Future<CustomerReviewsResponseModel> getReviews({
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
  Future<CustomerReviewModel> createReview({
    required String booking,
    required int rating,
    String? comment,
  }) async {
    try {
      return await _remoteDataSource.createReview(
        booking: booking,
        rating: rating,
        comment: comment,
      );
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to submit review. Please try again.');
    }
  }
}
