import '../../data/models/provider_dispute_model.dart';

abstract class ProviderDisputeRepository {
  Future<ProviderDisputeModel> createDispute({
    required String booking,
    required String reason,
    required String description,
    List<String>? evidenceFiles,
  });

  Future<ProviderDisputesListResponseModel> getProviderDisputes({int? page});

  Future<ProviderDisputeModel> getDisputeDetail(String disputeId);

  Future<ProviderDisputeModel> cancelDispute(String disputeId, {String? reason});

  Future<ProviderDisputeModel> respondDispute(
    String disputeId, {
    required String message,
    List<String>? evidenceFiles,
  });
}
