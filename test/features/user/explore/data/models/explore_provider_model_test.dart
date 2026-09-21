import 'package:flutter_test/flutter_test.dart';
import 'package:nchito/features/user/explore/data/models/explore_provider_model.dart';

void main() {
  const jsonResponse = {
    "success": true,
    "count": 6,
    "total_pages": 1,
    "current_page": 1,
    "page_size": 20,
    "next": null,
    "previous": null,
    "title": "Explore Provider",
    "applied_filters": {
      "category": null,
      "search": null,
      "city": null,
      "min_price": null,
      "max_price": null,
      "min_rating": null,
      "date": null,
      "sort": "recommended"
    },
    "empty_message": "We Couldn't Find Any Matches.",
    "data": [
      {
        "id": "6aae448a527875a24459c632",
        "full_name": "Thandiwe Phiri",
        "business_name": "Green Thumb Gardens",
        "avatar": null,
        "headline": "Lawns and gardens",
        "service_types": [
          "6a8e703141a4558c444a1e95"
        ],
        "service_type_names": [
          "Gardening & Landscaping"
        ],
        "service_type_chips": [
          {
            "id": "6a8e703141a4558c444a1e95",
            "name": "Gardening & Landscaping",
            "slug": "gardening-landscaping",
            "icon": null
          }
        ],
        "service_area": "Lusaka",
        "city": "Lusaka",
        "starting_price": "120.00",
        "currency": "ZMW",
        "rating_average": 5,
        "rating_count": 1,
        "total_jobs_completed": 1,
        "is_verified": true,
        "is_accepting_bookings": true,
        "is_favorited": false
      },
      {
        "id": "6aae4485527875a24459c60e",
        "full_name": "Robert Junior",
        "business_name": "Robert Junior Electrical",
        "avatar": null,
        "headline": "Certified home electrician",
        "service_types": [
          "6a8e703141a4558c444a1e94"
        ],
        "service_type_names": [
          "Electrical"
        ],
        "service_type_chips": [
          {
            "id": "6a8e703141a4558c444a1e94",
            "name": "Electrical",
            "slug": "electrical",
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
  };

  test('ExploreProvidersResponseModel parses JSON and maps correctly to UI entries', () {
    final model = ExploreProvidersResponseModel.fromJson(jsonResponse);

    expect(model.success, true);
    expect(model.count, 6);
    expect(model.totalPages, 1);
    expect(model.currentPage, 1);
    expect(model.pageSize, 20);
    expect(model.next, null);
    expect(model.previous, null);
    expect(model.title, 'Explore Provider');
    expect(model.emptyMessage, "We Couldn't Find Any Matches.");
    expect(model.data.length, 2);

    final item1 = model.data[0];
    expect(item1.fullName, 'Thandiwe Phiri');
    expect(item1.primaryServiceName, 'Gardening & Landscaping');
    expect(item1.displayPrice, 'ZMW 120');
    expect(item1.displayRating, '5.0');
    expect(item1.badge.iconAsset.contains('gardening'), true);
    expect(item1.photoPath.isNotEmpty, true);

    final item2 = model.data[1];
    expect(item2.fullName, 'Robert Junior');
    expect(item2.primaryServiceName, 'Electrical');
    expect(item2.displayPrice, 'ZMW 100');
    expect(item2.displayRating, '4.5');
    expect(item2.badge.iconAsset.contains('electrical'), true);

    final entry1 = item1.toExploreEntry();
    expect(entry1.provider.name, 'Thandiwe Phiri');
    expect(entry1.provider.price, 'ZMW 120');
    expect(entry1.provider.rating, '5.0');

    final entry2 = item2.toExploreEntry();
    expect(entry2.provider.name, 'Robert Junior');
    expect(entry2.provider.price, 'ZMW 100');
    expect(entry2.provider.rating, '4.5');
  });

  test('ExploreProvidersResponseModel parses DRF results JSON for near providers', () {
    final drfJson = {
      "count": 123,
      "next": "http://api.example.org/accounts/?page=4",
      "previous": "http://api.example.org/accounts/?page=2",
      "results": [
        {
          "id": "prov_123",
          "full_name": "Daniel Sakala",
          "business_name": "Sakala Electricals",
          "avatar": "https://example.com/avatar.jpg",
          "headline": "Experienced Electrician",
          "service_types": ["srv_1"],
          "service_type_names": ["Electrical"],
          "service_type_chips": [
            {
              "id": "srv_1",
              "name": "Electrical",
              "slug": "electrical",
              "icon": null
            }
          ],
          "service_area": "Kabulonga",
          "city": "Lusaka",
          "starting_price": "150.00",
          "currency": "ZMW",
          "rating_average": 4.9,
          "rating_count": 42,
          "total_jobs_completed": 88,
          "is_verified": true,
          "is_accepting_bookings": true,
          "is_favorited": true
        }
      ]
    };

    final model = ExploreProvidersResponseModel.fromJson(drfJson);

    expect(model.count, 123);
    expect(model.next, "http://api.example.org/accounts/?page=4");
    expect(model.data.length, 1);
    final item = model.data.first;
    expect(item.id, "prov_123");
    expect(item.fullName, "Daniel Sakala");
    expect(item.displayPrice, "ZMW 150");
    expect(item.displayRating, "4.9");
  });
}
