import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/api_url.dart';
import '../models/provider_dispute_model.dart';

abstract class ProviderDisputeRemoteDataSource {
  /// No design screen raises a dispute from the provider side today (the
  /// provider only ever responds to one a customer opened) — kept here
  /// since the backend exposes it, ready if that changes.
  Future<ProviderDisputeModel> createDispute({
    required String booking,
    required String reason,
    required String description,
    List<String>? evidenceFiles,
  });

  Future<ProviderDisputesListResponseModel> getProviderDisputes({int? page});

  Future<ProviderDisputeModel> getDisputeDetail(String disputeId);

  Future<ProviderDisputeModel> cancelDispute(
    String disputeId, {
    String? reason,
  });

  /// Provider's reply to a customer-raised dispute. The response schema
  /// only shows a `message` (+ optional evidence) field per response item
  /// — no `booking`/`reason`/`description` like dispute creation needs.
  Future<ProviderDisputeModel> respondDispute(
    String disputeId, {
    required String message,
    List<String>? evidenceFiles,
  });
}

class ProviderDisputeRemoteDataSourceImpl
    implements ProviderDisputeRemoteDataSource {
  ProviderDisputeRemoteDataSourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  @override
  Future<ProviderDisputeModel> createDispute({
    required String booking,
    required String reason,
    required String description,
    List<String>? evidenceFiles,
  }) async {
    final body = <String, dynamic>{
      'booking': booking.trim(),
      'reason': reason.trim(),
      'description': description.trim(),
      if (evidenceFiles != null && evidenceFiles.isNotEmpty)
        'evidence_files': evidenceFiles,
    };

    final response = await _apiClient.post(ApiUrl.providerDisputes, data: body);

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ProviderDisputeModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<ProviderDisputesListResponseModel> getProviderDisputes({int? page}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;

    final response = await _apiClient.get(
      ApiUrl.providerDisputes,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ProviderDisputesListResponseModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<ProviderDisputeModel> getDisputeDetail(String disputeId) async {
    final response =
        await _apiClient.get(ApiUrl.providerDisputeDetails(disputeId));
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ProviderDisputeModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<ProviderDisputeModel> cancelDispute(
    String disputeId, {
    String? reason,
  }) async {
    final body = <String, dynamic>{
      if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
    };

    final response = await _apiClient.post(
      ApiUrl.providerDisputeCancel(disputeId),
      data: body.isNotEmpty ? body : null,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ProviderDisputeModel.fromJson(responseData);
    }
    return ProviderDisputeModel(id: disputeId, status: 'cancelled');
  }

  @override
  Future<ProviderDisputeModel> respondDispute(
    String disputeId, {
    required String message,
    List<String>? evidenceFiles,
  }) async {
    final body = <String, dynamic>{
      'message': message.trim(),
      if (evidenceFiles != null && evidenceFiles.isNotEmpty)
        'evidence_files': evidenceFiles,
    };

    final response = await _apiClient.post(
      ApiUrl.providerDisputeRespond(disputeId),
      data: body,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ProviderDisputeModel.fromJson(responseData);
    }
    return ProviderDisputeModel(id: disputeId);
  }
}
