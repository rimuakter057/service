import 'package:nchito/core/errors/exceptions.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../domain/repositories/cms_support_repository.dart';
import '../datasources/cms_support_remote_datasource.dart';
import '../models/company_info_model.dart';
import '../models/faq_model.dart';

class CmsSupportRepositoryImpl implements CmsSupportRepository {
  final CmsSupportRemoteDataSource _remoteDataSource;

  CmsSupportRepositoryImpl({CmsSupportRemoteDataSource? remoteDataSource})
      : _remoteDataSource =
            remoteDataSource ?? CmsSupportRemoteDataSourceImpl();

  @override
  Future<CompanyInfoModel> getCompanyInfo({required bool isProvider}) async {
    try {
      return await _remoteDataSource.getCompanyInfo(isProvider: isProvider);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load company info. Please try again.');
    }
  }

  @override
  Future<FaqListResponseModel> getFaqs({
    required bool isProvider,
    String? search,
    int? page,
    int? pageSize,
    String? ordering,
  }) async {
    try {
      return await _remoteDataSource.getFaqs(
        isProvider: isProvider,
        search: search,
        page: page,
        pageSize: pageSize,
        ordering: ordering,
      );
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load FAQs. Please try again.');
    }
  }
}
