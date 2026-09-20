import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/api_url.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingResponseModel> createBooking(CreateBookingRequestModel request);
  Future<Map<String, dynamic>> getBookingForm(String providerId, {String? date});
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
}
