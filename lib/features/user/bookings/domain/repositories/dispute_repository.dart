import '../../data/models/customer_dispute_model.dart';

abstract class DisputeRepository {
  Future<CustomerDisputeModel> createDispute({
    required String booking,
    required String reason,
    required String description,
    List<String>? evidenceFiles,
  });

  Future<CustomerDisputesListResponseModel> getCustomerDisputes({int? page});

  Future<CustomerDisputeModel> getDisputeDetail(String disputeId);

  Future<CustomerDisputeModel> cancelDispute(
    String disputeId, {
    String? booking,
    String? reason,
    String? description,
  });

  Future<CustomerDisputeModel> respondDispute(
    String disputeId, {
    String? booking,
    String? reason,
    String? description,
    String? message,
    List<String>? evidenceFiles,
  });
}
