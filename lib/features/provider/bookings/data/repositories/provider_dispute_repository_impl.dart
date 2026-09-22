import 'package:nchito/core/errors/exceptions.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../domain/repositories/provider_dispute_repository.dart';
import '../datasources/provider_dispute_remote_datasource.dart';
import '../models/provider_dispute_model.dart';

class ProviderDisputeRepositoryImpl implements ProviderDisputeRepository {
  ProviderDisputeRepositoryImpl({ProviderDisputeRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ProviderDisputeRemoteDataSourceImpl();

  final ProviderDisputeRemoteDataSource _remoteDataSource;

  @override
  Future<ProviderDisputeModel> createDispute({
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
  Future<ProviderDisputesListResponseModel> getProviderDisputes({int? page}) async {
    try {
      return await _remoteDataSource.getProviderDisputes(page: page);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load disputes. Please try again.');
    }
  }

  @override
  Future<ProviderDisputeModel> getDisputeDetail(String disputeId) async {
    try {
      return await _remoteDataSource.getDisputeDetail(disputeId);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load dispute details. Please try again.');
    }
  }

  @override
  Future<ProviderDisputeModel> cancelDispute(String disputeId, {String? reason}) async {
    try {
      return await _remoteDataSource.cancelDispute(disputeId, reason: reason);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to cancel dispute. Please try again.');
    }
  }

  @override
  Future<ProviderDisputeModel> respondDispute(
    String disputeId, {
    required String message,
    List<String>? evidenceFiles,
  }) async {
    try {
      return await _remoteDataSource.respondDispute(
        disputeId,
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
