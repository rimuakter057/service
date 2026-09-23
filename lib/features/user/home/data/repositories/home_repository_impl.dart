import 'package:nchito/core/errors/exceptions.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/provider_detail_model.dart';
import '../models/provider_day_availability_model.dart';
import '../models/catalog_search_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({HomeRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? HomeRemoteDataSourceImpl();

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<List<Category>> getCategories() async {
    try {
      final categories = await _remoteDataSource.getCategories();
      return categories;
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load categories. Please try again.');
    }
  }

  @override
  Future<ProviderDetailModel> getProviderDetails(String id) async {
    try {
      final details = await _remoteDataSource.getProviderDetails(id);
      return details;
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load provider details. Please try again.');
    }
  }

  @override
  Future<ProviderDayAvailabilityModel> getProviderDayAvailability(
    String providerId, {
    String? date,
  }) async {
    try {
      final availability = await _remoteDataSource.getProviderDayAvailability(
        providerId,
        date: date,
      );
      return availability;
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load provider availability. Please try again.');
    }
  }

  @override
  Future<CatalogSearchResultModel> searchCatalog(String query) async {
    try {
      final results = await _remoteDataSource.searchCatalog(query);
      return results;
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to search catalog. Please try again.');
    }
  }
}

