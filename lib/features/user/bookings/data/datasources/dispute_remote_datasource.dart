import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/api_url.dart';
import '../models/customer_dispute_model.dart';

abstract class DisputeRemoteDataSource {
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

class DisputeRemoteDataSourceImpl implements DisputeRemoteDataSource {
  DisputeRemoteDataSourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  @override
  Future<CustomerDisputeModel> createDispute({
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

    final response = await _apiClient.post(
      ApiUrl.customerDisputes,
      data: body,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return CustomerDisputeModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<CustomerDisputesListResponseModel> getCustomerDisputes({int? page}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;

    final response = await _apiClient.get(
      ApiUrl.customerDisputes,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return CustomerDisputesListResponseModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<CustomerDisputeModel> getDisputeDetail(String disputeId) async {
    final response = await _apiClient.get(
      ApiUrl.customerDisputeDetails(disputeId),
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return CustomerDisputeModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<CustomerDisputeModel> cancelDispute(
    String disputeId, {
    String? booking,
    String? reason,
    String? description,
  }) async {
    final body = <String, dynamic>{
      if (booking != null && booking.trim().isNotEmpty) 'booking': booking.trim(),
      if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
      if (description != null && description.trim().isNotEmpty)
        'description': description.trim(),
    };

    final response = await _apiClient.post(
      ApiUrl.customerDisputeCancel(disputeId),
      data: body.isNotEmpty ? body : null,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return CustomerDisputeModel.fromJson(responseData);
    }
    return CustomerDisputeModel(id: disputeId, status: 'cancelled');
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
    final body = <String, dynamic>{
      if (booking != null && booking.trim().isNotEmpty) 'booking': booking.trim(),
      if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
      if (description != null && description.trim().isNotEmpty)
        'description': description.trim(),
      if (message != null && message.trim().isNotEmpty) 'message': message.trim(),
      if (evidenceFiles != null && evidenceFiles.isNotEmpty)
        'evidence_files': evidenceFiles,
    };

    final response = await _apiClient.post(
      ApiUrl.customerDisputeRespond(disputeId),
      data: body.isNotEmpty ? body : null,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return CustomerDisputeModel.fromJson(responseData);
    }
    return CustomerDisputeModel(id: disputeId);
  }
}
