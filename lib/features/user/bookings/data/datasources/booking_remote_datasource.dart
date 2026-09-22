import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/api_url.dart';
import '../models/booking_model.dart';
import '../models/customer_booking_detail_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingResponseModel> createBooking(CreateBookingRequestModel request);
  Future<Map<String, dynamic>> getBookingForm(String providerId, {String? date});
  Future<CustomerBookingsResponseModel> getCustomerBookings({
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
  Future<CustomerBookingDetailModel> getCustomerBookingDetail(String bookingId);
  Future<CustomerBookingDetailModel> acceptBooking(String bookingId, {String? amount, String? note});
  Future<CustomerBookingDetailModel> cancelBooking(String bookingId, {String? reason});
  Future<CustomerBookingDetailModel> completeBooking(String bookingId);
  Future<CustomerBookingDetailModel> declineQuote(String bookingId, {required String reason});
  Future<CustomerBookingDetailModel> rejectBooking(String bookingId, {String? reason});
  Future<CustomerBookingDetailModel> rescheduleBooking(String bookingId, {required String scheduledDate, required String scheduledTime, String? reason});
  Future<CustomerBookingDetailModel> rescheduleRespond(String bookingId, {required bool accept});
  Future<CustomerBookingDetailModel> resendCompletionCode(String bookingId);
  Future<CustomerBookingDetailModel> startBooking(String bookingId);
  Future<CustomerBookingDetailModel> verifyCompletion(String bookingId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  BookingRemoteDataSourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  @override
  Future<BookingResponseModel> createBooking(
      CreateBookingRequestModel request) async {
    final response = await _apiClient.post(
      ApiUrl.customerBookings,
      data: request.toJson(),
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return BookingResponseModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<Map<String, dynamic>> getBookingForm(
    String providerId, {
    String? date,
  }) async {
    final queryParams = <String, dynamic>{};
    if (date != null && date.trim().isNotEmpty) {
      queryParams['date'] = date.trim();
    }

    final response = await _apiClient.get(
      ApiUrl.customerProviderBookingForm(providerId),
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return responseData;
    }
    return {};
  }


  @override
  Future<CustomerBookingsResponseModel> getCustomerBookings({
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
    if (group != null && group.trim().isNotEmpty) {
      queryParams['group'] = group.trim();
    }
    if (status != null && status.trim().isNotEmpty) {
      queryParams['status'] = status.trim();
    }
    if (date != null && date.trim().isNotEmpty) {
      queryParams['date'] = date.trim();
    }
    if (dateFrom != null && dateFrom.trim().isNotEmpty) {
      queryParams['date_from'] = dateFrom.trim();
    }
    if (dateTo != null && dateTo.trim().isNotEmpty) {
      queryParams['date_to'] = dateTo.trim();
    }
    if (today != null) {
      queryParams['today'] = today;
    }
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }
    if (ordering != null && ordering.trim().isNotEmpty) {
      queryParams['ordering'] = ordering.trim();
    }
    if (page != null) {
      queryParams['page'] = page;
    }
    if (pageSize != null) {
      queryParams['page_size'] = pageSize;
    }

    final response = await _apiClient.get(
      ApiUrl.customerBookings,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return CustomerBookingsResponseModel.fromJson(
        responseData,
        requestedPage: page ?? 1,
        requestedPageSize: pageSize ?? 10,
      );
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<CustomerBookingDetailModel> getCustomerBookingDetail(
      String bookingId) async {
    final response = await _apiClient.get(
      ApiUrl.customerBookingDetails(bookingId),
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return CustomerBookingDetailModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  CustomerBookingDetailModel _parseDetailResponse(dynamic responseData, String bookingId) {
    if (responseData is Map<String, dynamic>) {
      return CustomerBookingDetailModel.fromJson(responseData);
    }
    return CustomerBookingDetailModel(
      id: bookingId,
      status: 'pending',
      serviceTitle: '',
    );
  }

  @override
  Future<CustomerBookingDetailModel> acceptBooking(
    String bookingId, {
    String? amount,
    String? note,
  }) async {
    final body = <String, dynamic>{};
    if (amount != null && amount.trim().isNotEmpty) body['amount'] = amount.trim();
    if (note != null && note.trim().isNotEmpty) body['note'] = note.trim();

    final response = await _apiClient.post(
      ApiUrl.customerBookingAccept(bookingId),
      data: body.isNotEmpty ? body : null,
    );
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<CustomerBookingDetailModel> cancelBooking(
    String bookingId, {
    String? reason,
  }) async {
    final body = <String, dynamic>{};
    if (reason != null && reason.trim().isNotEmpty) {
      body['cancellation_reason'] = reason.trim();
      body['reason'] = reason.trim();
    }

    final response = await _apiClient.post(
      ApiUrl.customerBookingCancel(bookingId),
      data: body.isNotEmpty ? body : null,
    );
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<CustomerBookingDetailModel> completeBooking(String bookingId) async {
    final response = await _apiClient.post(
      ApiUrl.customerBookingComplete(bookingId),
    );
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<CustomerBookingDetailModel> declineQuote(
    String bookingId, {
    required String reason,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.customerBookingDeclineQuote(bookingId),
      data: {'reason': reason.trim()},
    );
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<CustomerBookingDetailModel> rejectBooking(
    String bookingId, {
    String? reason,
  }) async {
    final body = <String, dynamic>{};
    if (reason != null && reason.trim().isNotEmpty) {
      body['rejection_reason'] = reason.trim();
      body['reason'] = reason.trim();
    }

    final response = await _apiClient.post(
      ApiUrl.customerBookingReject(bookingId),
      data: body.isNotEmpty ? body : null,
    );
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<CustomerBookingDetailModel> rescheduleBooking(
    String bookingId, {
    required String scheduledDate,
    required String scheduledTime,
    String? reason,
  }) async {
    final body = <String, dynamic>{
      'scheduled_date': scheduledDate.trim(),
      'scheduled_time': scheduledTime.trim(),
    };
    if (reason != null && reason.trim().isNotEmpty) {
      body['reason'] = reason.trim();
    }

    final response = await _apiClient.post(
      ApiUrl.customerBookingReschedule(bookingId),
      data: body,
    );
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<CustomerBookingDetailModel> rescheduleRespond(
    String bookingId, {
    required bool accept,
  }) async {
    final response = await _apiClient.post(
      ApiUrl.customerBookingRescheduleRespond(bookingId),
      data: {'accept': accept},
    );
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<CustomerBookingDetailModel> resendCompletionCode(String bookingId) async {
    final response = await _apiClient.post(
      ApiUrl.customerBookingResendCompletionCode(bookingId),
    );
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<CustomerBookingDetailModel> startBooking(String bookingId) async {
    final response = await _apiClient.post(
      ApiUrl.customerBookingStart(bookingId),
    );
    return _parseDetailResponse(response.data, bookingId);
  }

  @override
  Future<CustomerBookingDetailModel> verifyCompletion(String bookingId) async {
    final response = await _apiClient.post(
      ApiUrl.customerBookingVerifyCompletion(bookingId),
    );
    return _parseDetailResponse(response.data, bookingId);
  }
}
