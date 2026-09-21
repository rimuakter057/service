import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/api_url.dart';
import '../models/booking_model.dart';

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
}
