import 'package:flutter_test/flutter_test.dart';
import 'package:nchito/features/user/explore/data/models/explore_provider_model.dart';
import 'package:nchito/features/user/explore/domain/repositories/explore_repository.dart';
import 'package:nchito/features/user/profile/presentation/providers/favorite_providers_notifier.dart';

class MockExploreRepositoryForFavorites implements ExploreRepository {
  List<ExploreProviderItemModel> mockFavorites = [];
  bool shouldThrow = false;
  String? lastToggledId;
  bool? lastActionWasAdd;

  @override
  Future<FavoriteProvidersResponseModel> getFavorites({
    int? page,
    int? pageSize,
  }) async {
    if (shouldThrow) throw Exception('Server error');
    return FavoriteProvidersResponseModel(
      success: true,
      count: mockFavorites.length,
      data: List.from(mockFavorites),
    );
  }

  @override
  Future<bool> addFavorite(String providerId) async {
    if (shouldThrow) throw Exception('Server error');
    lastToggledId = providerId;
    lastActionWasAdd = true;
    return true;
  }

  @override
  Future<bool> removeFavorite(String providerId) async {
    if (shouldThrow) throw Exception('Server error');
    lastToggledId = providerId;
    lastActionWasAdd = false;
    return true;
  }

  @override
  Future<ExploreFiltersResponseModel> getFilters() async {
    return const ExploreFiltersResponseModel(
      success: true,
      categories: [],
      cities: [],
      minPrice: 0,
      maxPrice: 500,
      sortOptions: [],
      ratingOptions: [],
    );
  }

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
    return ExploreProvidersResponseModel(
      success: true,
      count: 0,
      totalPages: 1,
      currentPage: 1,
      pageSize: 10,
      title: 'Explore',
      emptyMessage: 'None',
      data: [],
    );
  }
}

void main() {
  group('FavoriteProviders & Null-Handling Tests', () {
    test('ExploreProviderItemModel safely handles all null fields with default values', () {
      final jsonWithNulls = <String, dynamic>{
        'id': null,
        'full_name': null,
        'business_name': null,
        'avatar': null,
        'headline': null,
        'service_types': null,
        'service_type_names': null,
        'service_type_chips': null,
        'service_area': null,
        'city': null,
        'starting_price': null,
        'currency': null,
        'rating_average': null,
        'rating_count': null,
        'total_jobs_completed': null,
        'is_verified': null,
        'is_accepting_bookings': null,
        'is_favorited': null,
      };

      final model = ExploreProviderItemModel.fromJson(jsonWithNulls);

      expect(model.id, '');
      expect(model.fullName, 'Service Provider');
      expect(model.businessName, '');
      expect(model.avatar, isNull);
      expect(model.headline, 'Experienced Service Specialist');
      expect(model.serviceArea, 'Lusaka');
      expect(model.city, 'Lusaka');
      expect(model.startingPrice, '0.00');
      expect(model.currency, 'ZMW');
      expect(model.ratingAverage, 0.0);
      expect(model.ratingCount, 0);
      expect(model.totalJobsCompleted, 0);
      expect(model.isVerified, false);
      expect(model.isAcceptingBookings, true);
      expect(model.isFavorited, false);

      final entry = model.toExploreEntry();
      expect(entry.provider.name, 'Service Provider');
      expect(entry.provider.area, 'Lusaka, Zambia');
    });

    test('FavoriteProvidersResponseModel unwraps nested provider object correctly', () {
      final jsonResponse = {
        'success': true,
        'count': 1,
        'data': [
          {
            'id': 'fav_1',
            'provider': {
              'id': 'prov_123',
              'full_name': 'Alice Cleaner',
              'service_type_names': ['Cleaning'],
              'starting_price': '150.00',
            }
          }
        ]
      };

      final response = FavoriteProvidersResponseModel.fromJson(jsonResponse);
      expect(response.count, 1);
      expect(response.data.first.id, 'prov_123');
      expect(response.data.first.fullName, 'Alice Cleaner');
      expect(response.data.first.isFavorited, true);
    });

    test('FavoriteProvidersNotifier fetches favorites successfully', () async {
      final mockRepo = MockExploreRepositoryForFavorites();
      mockRepo.mockFavorites = [
        ExploreProviderItemModel.fromJson({
          'id': 'p1',
          'full_name': 'John Plumber',
          'is_favorited': true,
        }),
      ];

      final notifier = FavoriteProvidersNotifier(repository: mockRepo);
      expect(notifier.isLoading, false);
      expect(notifier.isEmpty, true);

      await notifier.fetchFavorites();

      expect(notifier.isLoading, false);
      expect(notifier.isEmpty, false);
      expect(notifier.favorites.length, 1);
      expect(notifier.exploreEntries.first.provider.name, 'John Plumber');
      expect(notifier.errorMessage, isNull);
    });

    test('FavoriteProvidersNotifier handles fetch failure', () async {
      final mockRepo = MockExploreRepositoryForFavorites();
      mockRepo.shouldThrow = true;

      final notifier = FavoriteProvidersNotifier(repository: mockRepo);
      await notifier.fetchFavorites();

      expect(notifier.isLoading, false);
      expect(notifier.isEmpty, true);
      expect(notifier.errorMessage, isNotNull);
    });

    test('FavoriteProvidersNotifier toggleFavorite removes item from list optimistically', () async {
      final mockRepo = MockExploreRepositoryForFavorites();
      mockRepo.mockFavorites = [
        ExploreProviderItemModel.fromJson({
          'id': 'p1',
          'full_name': 'John Plumber',
          'is_favorited': true,
        }),
      ];

      final notifier = FavoriteProvidersNotifier(repository: mockRepo);
      await notifier.fetchFavorites();
      expect(notifier.favorites.length, 1);

      final success = await notifier.toggleFavorite('p1');
      expect(success, true);
      expect(notifier.favorites.isEmpty, true);
      expect(mockRepo.lastToggledId, 'p1');
      expect(mockRepo.lastActionWasAdd, false);
    });
  });
}
