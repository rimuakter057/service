import '../../data/models/company_info_model.dart';
import '../../data/models/faq_model.dart';

abstract class CmsSupportRepository {
  Future<CompanyInfoModel> getCompanyInfo({required bool isProvider});

  Future<FaqListResponseModel> getFaqs({
    required bool isProvider,
    String? search,
    int? page,
    int? pageSize,
    String? ordering,
  });
}
