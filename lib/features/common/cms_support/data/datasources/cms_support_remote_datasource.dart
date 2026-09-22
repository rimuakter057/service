import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/api_url.dart';
import '../models/company_info_model.dart';
import '../models/faq_model.dart';

abstract class CmsSupportRemoteDataSource {
  Future<CompanyInfoModel> getCompanyInfo({required bool isProvider});

  Future<FaqListResponseModel> getFaqs({
    required bool isProvider,
    String? search,
    int? page,
    int? pageSize,
    String? ordering,
  });
}

class CmsSupportRemoteDataSourceImpl implements CmsSupportRemoteDataSource {
  final ApiClient _apiClient;

  CmsSupportRemoteDataSourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<CompanyInfoModel> getCompanyInfo({required bool isProvider}) async {
    final endpoint =
        isProvider ? ApiUrl.providerCompany : ApiUrl.customerCompany;

    final response = await _apiClient.get(endpoint);
    final responseData = response.data;

    if (responseData is Map<String, dynamic>) {
      final parsed = CompanyResponseModel.fromJson(responseData);
      return parsed.data;
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<FaqListResponseModel> getFaqs({
    required bool isProvider,
    String? search,
    int? page,
    int? pageSize,
    String? ordering,
  }) async {
    final endpoint = isProvider ? ApiUrl.providerFaqs : ApiUrl.customerFaqs;

    final Map<String, dynamic> queryParams = {};
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }
    if (page != null) {
      queryParams['page'] = page;
    }
    if (pageSize != null) {
      queryParams['page_size'] = pageSize;
    }
    if (ordering != null && ordering.trim().isNotEmpty) {
      queryParams['ordering'] = ordering.trim();
    }

    final response = await _apiClient.get(
      endpoint,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return FaqListResponseModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }
}
