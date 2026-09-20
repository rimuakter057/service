import 'package:flutter_test/flutter_test.dart';
import 'package:nchito/features/user/home/data/models/provider_detail_model.dart';

void main() {
  const jsonResponse = {
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
    "is_favorited": false,
    "user_detail": {
      "id": "6aae448a527875a24459c631",
      "full_name": "Thandiwe Phiri",
      "avatar": null,
      "role": "provider"
    },
    "email": null,
    "contact_phone": null,
    "contact": null,
    "service_description": "Green Thumb Gardens - reliable, insured and local.",
    "years_of_experience": 4,
    "max_travel_km": 25,
    "latitude": -15.386700000000001,
    "longitude": 28.3133,
    "status": "approved",
    "verification_status": "approved",
    "portfolio": [],
    "availability": [
      {
        "id": "6aae448a527875a24459c634",
        "weekday": 0,
        "weekday_name": "Monday",
        "is_available": true,
        "start_time": "08:00:00",
        "end_time": "17:00:00"
      },
      {
        "id": "6aae448a527875a24459c63a",
        "weekday": 6,
        "weekday_name": "Sunday",
        "is_available": false,
        "start_time": null,
        "end_time": null
      }
    ],
    "created_at": "2026-09-19T10:15:06.172000+02:00"
  };

  test('ProviderDetailModel parses JSON correctly with safe defaults for null fields', () {
    final model = ProviderDetailModel.fromJson(jsonResponse);

    expect(model.id, '6aae448a527875a24459c632');
    expect(model.fullName, 'Thandiwe Phiri');
    expect(model.businessName, 'Green Thumb Gardens');
    expect(model.avatar, isNull);
    expect(model.email, isNull);
    expect(model.contactPhone, isNull);
    expect(model.serviceArea, 'Lusaka');
    expect(model.city, 'Lusaka');
    expect(model.serviceDescription, 'Green Thumb Gardens - reliable, insured and local.');
    expect(model.ratingAverage, 5.0);
    expect(model.ratingCount, 1);
    expect(model.totalJobsCompleted, 1);
    expect(model.isVerified, true);
    expect(model.availability.length, 2);

    final providerData = model.toHomeProviderData();

    expect(providerData.id, '6aae448a527875a24459c632');
    expect(providerData.name, 'Thandiwe Phiri');
    expect(providerData.service, 'Gardening & Landscaping');
    // Null email handled with clean fallback
    expect(providerData.email.isNotEmpty, true);
    expect(providerData.email.contains('@'), true);
    // Null phone handled with clean fallback
    expect(providerData.phone.isNotEmpty, true);
    // Null avatar handled with clean fallback asset
    expect(providerData.photo.isNotEmpty, true);
    expect(providerData.rating, '5.0');
    expect(providerData.reviewCount, '1');
    expect(providerData.totalJobsCompleted, '1');
    expect(providerData.tags.isNotEmpty, true);
    expect(providerData.tags.first.label, 'Gardening & Landscaping');
  });
}
