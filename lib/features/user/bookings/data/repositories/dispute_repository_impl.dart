import 'package:nchito/core/errors/exceptions.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../domain/repositories/dispute_repository.dart';
import '../datasources/dispute_remote_datasource.dart';
import '../models/customer_dispute_model.dart';

class DisputeRepositoryImpl implements DisputeRepository {
  DisputeRepositoryImpl({DisputeRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? DisputeRemoteDataSourceImpl();

  final DisputeRemoteDataSource _remoteDataSource;

  @override
  Future<CustomerDisputeModel> createDispute({
    required String booking,
    required String reason,
    required String description,
    List<String>? evidenceFiles,
  }) async {
    try {
      return await _remoteDataSource.createDispute(
        booking: booking,
        reason: reason,
        description: description,
        evidenceFiles: evidenceFiles,
      );
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to submit dispute. Please try again.');
    }
  }

  @override
  Future<CustomerDisputesListResponseModel> getCustomerDisputes({int? page}) async {
    try {
      return await _remoteDataSource.getCustomerDisputes(page: page);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load disputes. Please try again.');
    }
  }

  @override
  Future<CustomerDisputeModel> getDisputeDetail(String disputeId) async {
    try {
      return await _remoteDataSource.getDisputeDetail(disputeId);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load dispute details. Please try again.');
    }
  }

  @override
  Future<CustomerDisputeModel> cancelDispute(
    String disputeId, {
    String? booking,
    String? reason,
    String? description,
  }) async {
    try {
      return await _remoteDataSource.cancelDispute(
        disputeId,
        booking: booking,
        reason: reason,
        description: description,
      );
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to cancel dispute. Please try again.');
    }
  }

  @override
  Future<CustomerDisputeModel> respondDispute(
    String disputeId, {
    String? booking,
    String? reason,
    String? description,
    String? message,
    List<String>? evidenceFiles,
  }) async {
    try {
      return await _remoteDataSource.respondDispute(
        disputeId,
        booking: booking,
        reason: reason,
        description: description,
        message: message,
        evidenceFiles: evidenceFiles,
      );
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to respond to dispute. Please try again.');
    }
  }
}
