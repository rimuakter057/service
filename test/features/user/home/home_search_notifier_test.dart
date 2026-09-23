import 'package:flutter_test/flutter_test.dart';
import 'package:nchito/features/user/home/data/models/catalog_search_model.dart';
import 'package:nchito/features/user/home/domain/repositories/home_repository.dart';
import 'package:nchito/features/user/home/presentation/providers/home_search_notifier.dart';
import 'package:nchito/features/user/home/data/models/provider_detail_model.dart';
import 'package:nchito/features/user/home/data/models/provider_day_availability_model.dart';
import 'package:nchito/features/user/home/domain/entities/category.dart';

class MockHomeRepository implements HomeRepository {
  String? lastQuery;
  CatalogSearchResultModel resultToReturn = const CatalogSearchResultModel(
    services: [],
    providers: [],
  );

  @override
  Future<CatalogSearchResultModel> searchCatalog(String query) async {
    lastQuery = query;
    return resultToReturn;
  }

  @override
  Future<List<Category>> getCategories() async => [];

  @override
  Future<ProviderDetailModel> getProviderDetails(String id) =>
      throw UnimplementedError();

  @override
  Future<ProviderDayAvailabilityModel> getProviderDayAvailability(
    String providerId, {
    String? date,
  }) =>
      throw UnimplementedError();
}

void main() {
  group('CatalogSearchResultModel tests', () {
    test('fromJson correctly parses services and providers', () {
      final json = {
        "success": true,
        "message": "Success",
        "data": {
          "services": [
            {
              "id": "s1",
              "title": "Deep house cleaning",
              "slug": "deep-house-cleaning-1",
              "short_description": "Spotless home cleaning",
              "thumbnail": null,
              "category": "cat1",
              "category_name": "Cleaning",
              "provider_id": "p1",
              "provider_name": "Alex Cleaning Co.",
              "pricing_type": "fixed",
              "base_price": "100.00",
              "discount_price": null,
              "effective_price": "100.00",
              "currency": "ZMW",
              "unit_label": "",
              "duration_minutes": 120,
              "service_area": "Lusaka",
              "rating_average": 4.5,
              "rating_count": 2,
              "booking_count": 2,
              "is_featured": true,
              "status": "active",
              "status_display": "Active",
              "is_favorited": false
            }
          ],
          "providers": [
            {
              "id": "p1",
              "full_name": "Alex Johnson",
              "business_name": "Alex Cleaning Co.",
              "avatar": null,
              "headline": "Spotless home cleaning",
              "service_types": ["cat1"],
              "service_type_names": ["Cleaning"],
              "service_type_chips": [
                {
                  "id": "cat1",
                  "name": "Cleaning",
                  "slug": "cleaning",
                  "icon": null
                }
              ],
              "service_area": "Lusaka",
              "city": "Lusaka",
              "starting_price": "100.00",
              "currency": "ZMW",
              "rating_average": 4.5,
              "rating_count": 2,
              "total_jobs_completed": 2,
              "is_verified": true,
              "is_accepting_bookings": true,
              "is_favorited": false
            }
          ]
        }
      };

      final result = CatalogSearchResultModel.fromJson(json);
      expect(result.services.length, 1);
      expect(result.services.first.title, 'Deep house cleaning');
      expect(result.services.first.providerName, 'Alex Cleaning Co.');
      expect(result.services.first.effectivePrice, '100.00');

      expect(result.providers.length, 1);
      expect(result.providers.first.businessName, 'Alex Cleaning Co.');
      expect(result.providers.first.ratingAverage, 4.5);
    });
  });

  group('HomeSearchNotifier tests', () {
    late MockHomeRepository mockRepository;
    late HomeSearchNotifier notifier;

    setUp(() {
      mockRepository = MockHomeRepository();
      notifier = HomeSearchNotifier(repository: mockRepository);
    });

    tearDown(() {
      notifier.dispose();
    });

    test('initial state has empty query and no active search', () {
      expect(notifier.searchQuery, '');
      expect(notifier.hasActiveSearch, false);
      expect(notifier.isLoading, false);
      expect(notifier.searchResult, isNull);
    });

    test('searchImmediately fetches results and updates state', () async {
      mockRepository.resultToReturn = CatalogSearchResultModel(
        services: [
          CatalogServiceModel(
            id: 's1',
            title: 'Cleaning Service',
            slug: 'cleaning',
            shortDescription: 'Clean',
            category: 'cat1',
            categoryName: 'Cleaning',
            providerId: 'p1',
            providerName: 'Alex Co',
            pricingType: 'fixed',
            basePrice: '100',
            effectivePrice: '100',
            currency: 'ZMW',
            unitLabel: '',
            durationMinutes: 60,
            serviceArea: 'Lusaka',
            ratingAverage: 5.0,
            ratingCount: 1,
            bookingCount: 1,
            isFeatured: true,
            status: 'active',
            statusDisplay: 'Active',
            isFavorited: false,
          ),
        ],
        providers: [],
      );

      await notifier.searchImmediately('clean');

      expect(notifier.searchQuery, 'clean');
      expect(notifier.hasActiveSearch, true);
      expect(notifier.isLoading, false);
      expect(notifier.services.length, 1);
      expect(notifier.services.first.title, 'Cleaning Service');
      expect(mockRepository.lastQuery, 'clean');
    });

    test('clearSearch resets query and search result', () async {
      await notifier.searchImmediately('clean');
      expect(notifier.hasActiveSearch, true);

      notifier.clearSearch();

      expect(notifier.searchQuery, '');
      expect(notifier.hasActiveSearch, false);
      expect(notifier.searchResult, isNull);
    });
  });
}
