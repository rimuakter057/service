import 'package:flutter_test/flutter_test.dart';
import 'package:nchito/features/user/bookings/data/models/booking_model.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';

void main() {
  group('BookingModel tests', () {
    test('CreateBookingRequestModel serializes to exact Swagger JSON', () {
      const request = CreateBookingRequestModel(
        provider: '6aae448a527875a24459c632',
        serviceType: '6a8e703141a4558c444a1e95',
        scheduledDate: '2025-10-26',
        scheduledTime: '08:00:00',
        locationText: '12 Kabulonga Road, Lusaka',
        instructions: 'Kitchen socket sparks. Gate code 4410.',
      );

      final json = request.toJson();

      expect(json['provider'], '6aae448a527875a24459c632');
      expect(json['service_type'], '6a8e703141a4558c444a1e95');
      expect(json['scheduled_date'], '2025-10-26');
      expect(json['scheduled_time'], '08:00:00');
      expect(json['location_text'], '12 Kabulonga Road, Lusaka');
      expect(json['instructions'], 'Kitchen socket sparks. Gate code 4410.');
      expect(json.containsKey('service'), isFalse);
    });

    test('BookingResponseModel parses 201 response and converts to BookingHistoryData', () {
      final json = {
        'id': 'booking_123',
        'provider': '6aae448a527875a24459c632',
        'provider_name': 'Daniel Sakala',
        'service_type': '6a8e703141a4558c444a1e95',
        'service_type_name': 'Electrical',
        'scheduled_date': '2025-10-26',
        'scheduled_time': '08:00:00',
        'location_text': '12 Kabulonga Road, Lusaka',
        'instructions': 'Kitchen socket sparks. Gate code 4410.',
        'status': 'pending',
      };

      final model = BookingResponseModel.fromJson(json);

      expect(model.id, 'booking_123');
      expect(model.providerId, '6aae448a527875a24459c632');
      expect(model.providerName, 'Daniel Sakala');
      expect(model.serviceTypeName, 'Electrical');
      expect(model.scheduledDate, '2025-10-26');
      expect(model.scheduledTime, '08:00:00');
      expect(model.status, 'pending');

      final historyData = model.toBookingHistoryData();

      expect(historyData.providerName, 'Daniel Sakala');
      expect(historyData.service, 'Electrical');
      expect(historyData.day, '26');
      expect(historyData.month, 'Oct');
      expect(historyData.time, '8:00 AM');
      expect(historyData.status, AppText.pending);
      expect(historyData.location, '12 Kabulonga Road, Lusaka');
      expect(historyData.details, 'Kitchen socket sparks. Gate code 4410.');
    });

    test('CustomerBookingsResponseModel parses Swagger ongoing bookings JSON and maps to HomeBookingData', () {
      final json = {
        "count": 123,
        "next": "http://api.example.org/accounts/?page=4",
        "previous": "http://api.example.org/accounts/?page=2",
        "results": [
          {
            "id": "booking_ongoing_1",
            "reference": "REF-7890",
            "service_title": "Deep House Cleaning",
            "service_type": "srv_type_1",
            "service_type_name": "Cleaning",
            "provider": "prov_1",
            "provider_name": "Robert Junior",
            "provider_avatar": "https://example.com/avatar.jpg",
            "customer": "cust_1",
            "customer_name": "Alice Smith",
            "scheduled_date": "2026-09-21",
            "scheduled_time": "02:51:06.375Z",
            "location_text": "12 Kabulonga, Lusaka",
            "service_cost": "150.00",
            "platform_fee": "15.00",
            "total_cost": "165.00",
            "currency": "ZMW",
            "is_quoted": true,
            "status": "in_progress",
            "status_display": "In Progress",
            "status_label": "In Progress",
            "has_review": false,
            "created_at": "2026-09-21T02:51:06.375Z"
          }
        ]
      };

      final responseModel = CustomerBookingsResponseModel.fromJson(json);

      expect(responseModel.count, 123);
      expect(responseModel.next, "http://api.example.org/accounts/?page=4");
      expect(responseModel.previous, "http://api.example.org/accounts/?page=2");
      expect(responseModel.results.length, 1);

      final booking = responseModel.results.first;
      expect(booking.id, "booking_ongoing_1");
      expect(booking.reference, "REF-7890");
      expect(booking.serviceTitle, "Deep House Cleaning");
      expect(booking.providerName, "Robert Junior");
      expect(booking.displayPrice, "ZMW 165");

      final homeData = booking.toHomeBookingData();
      expect(homeData.providerName, "Robert Junior");
      expect(homeData.service, "Deep House Cleaning");
      expect(homeData.price, "ZMW 165");
      expect(homeData.status, "In Progress");
      expect(homeData.location, "12 Kabulonga, Lusaka");
      expect(homeData.date, "21 Sep 2026");
      expect(homeData.provider.name, "Robert Junior");
      expect(homeData.provider.photo, "https://example.com/avatar.jpg");
    });
  });
}
