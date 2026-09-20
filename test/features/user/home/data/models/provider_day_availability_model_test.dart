import 'package:flutter_test/flutter_test.dart';
import 'package:nchito/features/user/home/data/models/provider_day_availability_model.dart';

void main() {
  group('ProviderDayAvailabilityModel JSON parsing and formatting', () {
    test('parses exact Swagger sample response correctly', () {
      final json = {
        'date': '2025-10-26',
        'has_schedule': true,
        'is_full_day_blocked': false,
        'title': 'Provider Availability',
        'slots_label': 'Available Time',
        'slots': [
          {
            'start_time': '08:00:00',
            'end_time': '10:00:00',
            'is_available': true,
          },
          {
            'start_time': '10:30:00',
            'end_time': '12:30:00',
            'is_available': false,
          },
        ],
        'available_count': 1,
        'book_label': 'Book Now',
        'empty_message': 'No available time on this date. Try another day.',
      };

      final model = ProviderDayAvailabilityModel.fromJson(json);

      expect(model.date, '2025-10-26');
      expect(model.hasSchedule, isTrue);
      expect(model.isFullDayBlocked, isFalse);
      expect(model.title, 'Provider Availability');
      expect(model.slotsLabel, 'Available Time');
      expect(model.availableCount, 1);
      expect(model.bookLabel, 'Book Now');
      expect(model.emptyMessage,
          'No available time on this date. Try another day.');
      expect(model.slots.length, 2);

      // Slot 1
      final slot1 = model.slots[0];
      expect(slot1.startTime, '08:00:00');
      expect(slot1.endTime, '10:00:00');
      expect(slot1.isAvailable, isTrue);
      expect(slot1.formattedSlotLabel, '8:00 AM – 10:00 AM');
      final item1 = slot1.toTimeSlotItem();
      expect(item1.label, '8:00 AM – 10:00 AM');
      expect(item1.isAvailable, isTrue);

      // Slot 2
      final slot2 = model.slots[1];
      expect(slot2.startTime, '10:30:00');
      expect(slot2.endTime, '12:30:00');
      expect(slot2.isAvailable, isFalse);
      expect(slot2.formattedSlotLabel, '10:30 AM – 12:30 PM');
      final item2 = slot2.toTimeSlotItem();
      expect(item2.label, '10:30 AM – 12:30 PM');
      expect(item2.isAvailable, isFalse);
    });

    test('handles null and empty fields with robust defaults', () {
      final json = <String, dynamic>{};

      final model = ProviderDayAvailabilityModel.fromJson(json);

      expect(model.date, '');
      expect(model.hasSchedule, isFalse);
      expect(model.isFullDayBlocked, isFalse);
      expect(model.title, 'Provider Availability');
      expect(model.slotsLabel, 'Available Time');
      expect(model.slots, isEmpty);
      expect(model.availableCount, 0);
      expect(model.bookLabel, 'Book Now');
      expect(model.emptyMessage,
          'No available time on this date. Try another day.');
    });

    test('fallback factory produces valid default slots', () {
      final fallback =
          ProviderDayAvailabilityModel.fallback(date: '2025-10-26');

      expect(fallback.date, '2025-10-26');
      expect(fallback.hasSchedule, isTrue);
      expect(fallback.slots.length, 4);
      expect(fallback.slots[0].formattedSlotLabel, '8:00 AM – 10:00 AM');
      expect(fallback.slots[1].formattedSlotLabel, '10:30 AM – 12:30 PM');
      expect(fallback.slots[2].formattedSlotLabel, '1:00 PM – 3:00 PM');
      expect(fallback.slots[3].formattedSlotLabel, '3:30 PM – 5:30 PM');
    });

    test('parses live response with working_hours and booked correctly', () {
      final json = {
        'date': '2026-09-21',
        'has_schedule': true,
        'is_full_day_blocked': false,
        'title': 'Provider Availability',
        'working_hours': {
          'start_time': '08:00:00',
          'end_time': '17:30:00',
          'label': '8:00 AM – 5:30 PM',
        },
        'booked_label': 'Booked Time',
        'booked': [
          {
            'start_time': '08:00:00',
            'end_time': '10:00:00',
            'label': '8:00 AM – 10:00 AM',
          }
        ],
        'booked_empty_message': 'No bookings yet — any time works.',
        'can_book': true,
        'book_label': 'Book Now',
        'empty_message': '',
      };

      final model = ProviderDayAvailabilityModel.fromJson(json);

      expect(model.date, '2026-09-21');
      expect(model.workingHours, isNotNull);
      expect(model.workingHours?.label, '8:00 AM – 5:30 PM');
      expect(model.bookedLabel, 'Booked Time');
      expect(model.booked.length, 1);
      expect(model.booked.first.label, '8:00 AM – 10:00 AM');
      expect(model.canBook, isTrue);

      // Verify that 08:00 slot is marked unavailable because it was booked
      expect(model.slots.isNotEmpty, isTrue);
      final slot8am = model.slots.firstWhere((s) => s.startTime == '08:00:00');
      expect(slot8am.isAvailable, isFalse);
      final slot1030am = model.slots.firstWhere((s) => s.startTime == '10:30:00');
      expect(slot1030am.isAvailable, isTrue);
    });
  });
}
