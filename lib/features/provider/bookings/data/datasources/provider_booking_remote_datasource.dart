import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/api_url.dart';
import '../models/provider_booking_model.dart';
import '../models/provider_booking_detail_model.dart';

abstract class ProviderBookingRemoteDataSource {
  Future<ProviderBookingsResponseModel> getProviderBookings({
    String? group,
    String? status,
    String? date,
    String? dateFrom,
    String? dateTo,
    bool? today,
    String? search,
    String? ordering,
    int? page,
    int? pageSize,
  });
  Future<ProviderBookingDetailModel> getProviderBookingDetail(String bookingId);
  Future<ProviderBookingDetailModel> acceptBooking(String bookingId,
      {String? amount, String? note});
  Future<ProviderBookingDetailModel> cancelBooking(String bookingId,
      {String? reason});
  Future<ProviderBookingDetailModel> completeBooking(String bookingId);
  Future<ProviderBookingDetailModel> declineQuote(String bookingId,
      {required String reason});
  Future<ProviderBookingDetailModel> rejectBooking(String bookingId,
      {String? reason});
  Future<ProviderBookingDetailModel> rescheduleBooking(
    String bookingId, {
    required String scheduledDate,
    required String scheduledTime,
    String? reason,
  });
  Future<ProviderBookingDetailModel> rescheduleRespond(String bookingId,
      {required bool accept});
  Future<ProviderBookingDetailModel> resendCompletionCode(String bookingId);
  Future<ProviderBookingDetailModel> startBooking(String bookingId);
  Future<ProviderBookingDetailModel> verifyCompletion(String bookingId,
      {String? code});
}

class ProviderBookingRemoteDataSourceImpl
    implements ProviderBookingRemoteDataSource {
  ProviderBookingRemoteDataSourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  @override
  Future<ProviderBookingsResponseModel> getProviderBookings({
    String? group,
    String? status,
    String? date,
    String? dateFrom,
    String? dateTo,
    bool? today,
    String? search,
    String? ordering,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, dynamic>{};
    if (group != null && group.trim().isNotEmpty) queryParams['group'] = group.trim();
    if (status != null && status.trim().isNotEmpty) queryParams['status'] = status.trim();
    if (date != null && date.trim().isNotEmpty) queryParams['date'] = date.trim();
    if (dateFrom != null && dateFrom.trim().isNotEmpty) queryParams['date_from'] = dateFrom.trim();
    if (dateTo != null && dateTo.trim().isNotEmpty) queryParams['date_to'] = dateTo.trim();
    if (today != null) queryParams['today'] = today;
    if (search != null && search.trim().isNotEmpty) queryParams['search'] = search.trim();
    if (ordering != null && ordering.trim().isNotEmpty) queryParams['ordering'] = ordering.trim();
    if (page != null) queryParams['page'] = page;
    if (pageSize != null) queryParams['page_size'] = pageSize;

    final response = await _apiClient.get(
      ApiUrl.providerBookings,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ProviderBookingsResponseModel.fromJson(
        responseData,
        requestedPage: page ?? 1,
        requestedPageSize: pageSize ?? 10,
      );
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<ProviderBookingDetailModel> getProviderBookingDetail(
      String bookingId) async {
    final response =
        await _apiClient.get(ApiUrl.providerBookingDetails(bookingId));
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ProviderBookingDetailModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  ProviderBookingDetailModel _parseDetailResponse(
      dynamic responseData, String bookingId) {
    if (responseData is Map<String, dynamic>) {
      return ProviderBookingDetailModel.fromJson(responseData);
    }
    return ProviderBookingDetailModel(
      id: bookingId,
      status: 'pending',
      serviceTitle: '',
    );
  }

  @override
  Future<ProviderBookingDetailModel> acceptBooking(
    String bookingId, {
    String? amount,
    String? note,
  }) async {
    final body = <String, dynamic>{};
    if (amount != null && amount.trim().isNotEmpty) body['amount'] = amount.trim();
    if (note != null && note.trim().isNotEmpty) body['note'] = note.trim();

    final response = await _apiClient.post(
      ApiUrl.providerBookingAccept(bookingId),
      data: body.isNotEmpty ? body : null,
    );
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<ProviderBookingDetailModel> cancelBooking(
    String bookingId, {
    String? reason,
  }) async {
    final body = <String, dynamic>{};
    if (reason != null && reason.trim().isNotEmpty) {
      body['cancellation_reason'] = reason.trim();
      body['reason'] = reason.trim();
    }
    final response = await _apiClient.post(
      ApiUrl.providerBookingCancel(bookingId),
      data: body.isNotEmpty ? body : null,
    );
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<ProviderBookingDetailModel> completeBooking(String bookingId) async {
    final response =
        await _apiClient.post(ApiUrl.providerBookingComplete(bookingId));
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<ProviderBookingDetailModel> declineQuote(
    String bookingId, {
    required String reason,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.providerBookingDeclineQuote(bookingId),
      data: {'reason': reason.trim()},
    );
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<ProviderBookingDetailModel> rejectBooking(
    String bookingId, {
    String? reason,
  }) async {
    final body = <String, dynamic>{};
    if (reason != null && reason.trim().isNotEmpty) {
      body['rejection_reason'] = reason.trim();
      body['reason'] = reason.trim();
    }
    final response = await _apiClient.post(
      ApiUrl.providerBookingReject(bookingId),
      data: body.isNotEmpty ? body : null,
    );
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<ProviderBookingDetailModel> rescheduleBooking(
    String bookingId, {
    required String scheduledDate,
    required String scheduledTime,
    String? reason,
  }) async {
    final body = <String, dynamic>{
      'scheduled_date': scheduledDate.trim(),
      'scheduled_time': scheduledTime.trim(),
    };
    if (reason != null && reason.trim().isNotEmpty) body['reason'] = reason.trim();

    final response = await _apiClient.post(
      ApiUrl.providerBookingReschedule(bookingId),
      data: body,
    );
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<ProviderBookingDetailModel> rescheduleRespond(
    String bookingId, {
    required bool accept,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.providerBookingRescheduleRespond(bookingId),
      data: {'accept': accept},
    );
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<ProviderBookingDetailModel> resendCompletionCode(
      String bookingId) async {
    final response = await _apiClient
        .post(ApiUrl.providerBookingResendCompletionCode(bookingId));
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<ProviderBookingDetailModel> startBooking(String bookingId) async {
    final response =
        await _apiClient.post(ApiUrl.providerBookingStart(bookingId));
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<ProviderBookingDetailModel> verifyCompletion(
    String bookingId, {
    String? code,
  }) async {
    final body = <String, dynamic>{};
    if (code != null && code.trim().isNotEmpty) body['code'] = code.trim();

    final response = await _apiClient.post(
      ApiUrl.providerBookingVerifyCompletion(bookingId),
      data: body.isNotEmpty ? body : null,
    );
    return _parseDetailResponse(response.data, bookingId);
  }
}
