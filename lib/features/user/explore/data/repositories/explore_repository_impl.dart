import 'package:nchito/core/errors/exceptions.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../domain/repositories/explore_repository.dart';
import '../datasources/explore_remote_datasource.dart';
import '../models/explore_provider_model.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  ExploreRepositoryImpl({ExploreRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ExploreRemoteDataSourceImpl();

  final ExploreRemoteDataSource _remoteDataSource;

  @override
  Future<ExploreProvidersResponseModel> getProviders({
    String? search,
    String? category,
    String? city,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sort,
    String? date,
    double? lat,
    double? lng,
    int? page,
    int? pageSize,
  }) async {
    try {
      return await _remoteDataSource.getProviders(
        search: search,
        category: category,
        city: city,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
        sort: sort,
        date: date,
        lat: lat,
        lng: lng,
        page: page,
        pageSize: pageSize,
      );
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load providers. Please try again.');
    }
  }

  @override
  Future<ExploreFiltersResponseModel> getFilters() async {
    try {
      return await _remoteDataSource.getFilters();
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load filter options.');
    }
  }

  @override
  Future<FavoriteProvidersResponseModel> getFavorites({
    int? page,
    int? pageSize,
  }) async {
    try {
      return await _remoteDataSource.getFavorites(
        page: page,
        pageSize: pageSize,
      );
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load favorite providers.');
    }
  }

  @override
  Future<bool> addFavorite(String providerId) async {
    try {
      return await _remoteDataSource.addFavorite(providerId);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to add provider to favorites.');
    }
  }

  @override
  Future<bool> removeFavorite(String providerId) async {
    try {
      return await _remoteDataSource.removeFavorite(providerId);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to remove provider from favorites.');
    }
  }
}
