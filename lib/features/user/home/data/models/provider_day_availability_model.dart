import 'package:nchito/features/common/common_widgets/app_time_slot_picker/app_time_slot_picker.dart';

class ProviderDaySlotModel {
  final String startTime;
  final String endTime;
  final bool isAvailable;

  const ProviderDaySlotModel({
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  factory ProviderDaySlotModel.fromJson(Map<String, dynamic> json) {
    return ProviderDaySlotModel(
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      isAvailable: json['is_available'] as bool? ?? false,
    );
  }

  /// Converts 24-hour time "08:00:00" to "8:00 AM", "13:30:00" to "1:30 PM"
  static String formatTime(String rawTime) {
    if (rawTime.trim().isEmpty) return '';
    try {
      final parts = rawTime.split(':');
      if (parts.isEmpty) return rawTime;
      int hour = int.parse(parts[0]);
      int minute = parts.length > 1 ? int.parse(parts[1]) : 0;
      final period = hour >= 12 ? 'PM' : 'AM';
      int displayHour = hour % 12;
      if (displayHour == 0) displayHour = 12;
      final minuteStr = minute.toString().padLeft(2, '0');
      return '$displayHour:$minuteStr $period';
    } catch (_) {
      return rawTime;
    }
  }

  /// Formatted slot label e.g. "8:00 AM – 10:00 AM"
  String get formattedSlotLabel {
    final start = formatTime(startTime);
    final end = formatTime(endTime);
    if (start.isEmpty && end.isEmpty) return 'Time Slot';
    if (start.isEmpty) return end;
    if (end.isEmpty) return start;
    return '$start – $end';
  }

  TimeSlotItem toTimeSlotItem() {
    return TimeSlotItem(
      label: formattedSlotLabel,
      isAvailable: isAvailable,
    );
  }
}

class ProviderWorkingHoursModel {
  final String startTime;
  final String endTime;
  final String label;

  const ProviderWorkingHoursModel({
    required this.startTime,
    required this.endTime,
    required this.label,
  });

  factory ProviderWorkingHoursModel.fromJson(Map<String, dynamic> json) {
    final start = json['start_time']?.toString() ?? '';
    final end = json['end_time']?.toString() ?? '';
    final rawLabel = json['label']?.toString() ?? '';
    final formattedLabel = rawLabel.isNotEmpty
        ? rawLabel
        : ((start.isNotEmpty && end.isNotEmpty)
            ? '${ProviderDaySlotModel.formatTime(start)} – ${ProviderDaySlotModel.formatTime(end)}'
            : '');

    return ProviderWorkingHoursModel(
      startTime: start,
      endTime: end,
      label: formattedLabel,
    );
  }
}

class ProviderBookedSlotModel {
  final String startTime;
  final String endTime;
  final String label;

  const ProviderBookedSlotModel({
    required this.startTime,
    required this.endTime,
    required this.label,
  });

  factory ProviderBookedSlotModel.fromJson(Map<String, dynamic> json) {
    final start = json['start_time']?.toString() ?? '';
    final end = json['end_time']?.toString() ?? '';
    final rawLabel = json['label']?.toString() ?? '';
    final formattedLabel = rawLabel.isNotEmpty
        ? rawLabel
        : ((start.isNotEmpty && end.isNotEmpty)
            ? '${ProviderDaySlotModel.formatTime(start)} – ${ProviderDaySlotModel.formatTime(end)}'
            : start);

    return ProviderBookedSlotModel(
      startTime: start,
      endTime: end,
      label: formattedLabel,
    );
  }
}

class ProviderDayAvailabilityModel {
  final String date;
  final bool hasSchedule;
  final bool isFullDayBlocked;
  final String title;
  final String slotsLabel;
  final List<ProviderDaySlotModel> slots;
  final int availableCount;
  final String bookLabel;
  final String emptyMessage;

  // Working hours and booked slots
  final ProviderWorkingHoursModel? workingHours;
  final String bookedLabel;
  final List<ProviderBookedSlotModel> booked;
  final String bookedEmptyMessage;
  final bool canBook;

  const ProviderDayAvailabilityModel({
    required this.date,
    required this.hasSchedule,
    required this.isFullDayBlocked,
    required this.title,
    required this.slotsLabel,
    required this.slots,
    required this.availableCount,
    required this.bookLabel,
    required this.emptyMessage,
    this.workingHours,
    this.bookedLabel = 'Booked Time',
    this.booked = const [],
    this.bookedEmptyMessage = 'No bookings yet — any time works.',
    this.canBook = true,
  });

  factory ProviderDayAvailabilityModel.fromJson(Map<String, dynamic> json) {
    ProviderWorkingHoursModel? parsedWorkingHours;
    if (json['working_hours'] is Map<String, dynamic>) {
      parsedWorkingHours = ProviderWorkingHoursModel.fromJson(
        json['working_hours'] as Map<String, dynamic>,
      );
    }

    final rawBooked = json['booked'];
    final List<ProviderBookedSlotModel> parsedBooked = [];
    if (rawBooked is List) {
      for (final b in rawBooked) {
        if (b is Map<String, dynamic>) {
          parsedBooked.add(ProviderBookedSlotModel.fromJson(b));
        }
      }
    }

    final rawSlots = json['slots'];
    final List<ProviderDaySlotModel> parsedSlots = [];
    if (rawSlots is List && rawSlots.isNotEmpty) {
      for (final s in rawSlots) {
        if (s is Map<String, dynamic>) {
          parsedSlots.add(ProviderDaySlotModel.fromJson(s));
        }
      }
    } else if (parsedWorkingHours != null) {
      // Derive candidate slots based on working hours, marking booked slots as unavailable
      parsedSlots.addAll(_generateSlots(parsedWorkingHours, parsedBooked));
    }

    final parsedAvailableCount = (json['available_count'] is num)
        ? (json['available_count'] as num).toInt()
        : parsedSlots.where((s) => s.isAvailable).length;

    return ProviderDayAvailabilityModel(
      date: json['date']?.toString() ?? '',
      hasSchedule: json['has_schedule'] as bool? ??
          (parsedSlots.isNotEmpty || parsedWorkingHours != null),
      isFullDayBlocked: json['is_full_day_blocked'] as bool? ?? false,
      title: json['title']?.toString() ?? 'Provider Availability',
      slotsLabel: json['slots_label']?.toString() ?? 'Available Time',
      slots: parsedSlots,
      availableCount: parsedAvailableCount,
      bookLabel: json['book_label']?.toString() ?? 'Book Now',
      emptyMessage: json['empty_message']?.toString() ??
          'No available time on this date. Try another day.',
      workingHours: parsedWorkingHours,
      bookedLabel: json['booked_label']?.toString() ?? 'Booked Time',
      booked: parsedBooked,
      bookedEmptyMessage: json['booked_empty_message']?.toString() ??
          'No bookings yet — any time works.',
      canBook: json['can_book'] as bool? ?? true,
    );
  }

  static List<ProviderDaySlotModel> _generateSlots(
    ProviderWorkingHoursModel workingHours,
    List<ProviderBookedSlotModel> booked,
  ) {
    const candidates = [
      {'start': '08:00:00', 'end': '10:00:00'},
      {'start': '10:30:00', 'end': '12:30:00'},
      {'start': '13:00:00', 'end': '15:00:00'},
      {'start': '15:30:00', 'end': '17:30:00'},
    ];

    final bookedStarts = booked.map((b) => b.startTime.trim()).toSet();
    final result = <ProviderDaySlotModel>[];

    for (final c in candidates) {
      final start = c['start']!;
      final end = c['end']!;
      final isBooked = bookedStarts.contains(start);
      result.add(
        ProviderDaySlotModel(
          startTime: start,
          endTime: end,
          isAvailable: !isBooked,
        ),
      );
    }
    return result;
  }

  /// Default fallback mock data if API response is empty or offline
  factory ProviderDayAvailabilityModel.fallback({String? date}) {
    return ProviderDayAvailabilityModel(
      date: date ?? '2025-10-26',
      hasSchedule: true,
      isFullDayBlocked: false,
      title: 'Provider Availability',
      slotsLabel: 'Available Time',
      slots: const [
        ProviderDaySlotModel(
          startTime: '08:00:00',
          endTime: '10:00:00',
          isAvailable: true,
        ),
        ProviderDaySlotModel(
          startTime: '10:30:00',
          endTime: '12:30:00',
          isAvailable: false,
        ),
        ProviderDaySlotModel(
          startTime: '13:00:00',
          endTime: '15:00:00',
          isAvailable: false,
        ),
        ProviderDaySlotModel(
          startTime: '15:30:00',
          endTime: '17:30:00',
          isAvailable: true,
        ),
      ],
      availableCount: 2,
      bookLabel: 'Book Now',
      emptyMessage: 'No available time on this date. Try another day.',
      workingHours: const ProviderWorkingHoursModel(
        startTime: '08:00:00',
        endTime: '17:30:00',
        label: '8:00 AM – 5:30 PM',
      ),
      bookedLabel: 'Booked Time',
      booked: const [
        ProviderBookedSlotModel(
          startTime: '08:00:00',
          endTime: '10:00:00',
          label: '8:00 AM – 10:00 AM',
        ),
      ],
      bookedEmptyMessage: 'No bookings yet — any time works.',
      canBook: true,
    );
  }
}
