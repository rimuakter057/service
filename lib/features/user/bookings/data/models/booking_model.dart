import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

class CreateBookingRequestModel {
  final String provider;
  final String? service;
  final String serviceType;
  final String scheduledDate;
  final String scheduledTime;
  final String locationText;
  final String instructions;
  final int? durationMinutes;
  final double? latitude;
  final double? longitude;

  const CreateBookingRequestModel({
    required this.provider,
    this.service,
    required this.serviceType,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.locationText,
    required this.instructions,
    this.durationMinutes,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'provider': provider,
      'service_type': serviceType,
      'scheduled_date': scheduledDate,
      'scheduled_time': scheduledTime,
      'location_text': locationText,
      'instructions': instructions,
    };
    if (service != null && service!.trim().isNotEmpty) {
      map['service'] = service!.trim();
    }
    if (durationMinutes != null) {
      map['duration_minutes'] = durationMinutes;
    }
    if (latitude != null) {
      map['latitude'] = latitude;
    }
    if (longitude != null) {
      map['longitude'] = longitude;
    }
    return map;
  }
}

class BookingResponseModel {
  final String id;
  final String providerId;
  final String? providerName;
  final String? service;
  final String serviceType;
  final String? serviceTypeName;
  final String scheduledDate;
  final String scheduledTime;
  final String locationText;
  final String instructions;
  final String status;
  final String? price;
  final String? serviceCost;
  final Map<String, dynamic>? rawJson;

  const BookingResponseModel({
    required this.id,
    required this.providerId,
    this.providerName,
    this.service,
    required this.serviceType,
    this.serviceTypeName,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.locationText,
    required this.instructions,
    required this.status,
    this.price,
    this.serviceCost,
    this.rawJson,
  });

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    // Some endpoints wrap under 'data', some return directly
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return BookingResponseModel(
      id: data['id']?.toString() ?? '',
      providerId: data['provider']?.toString() ??
          data['provider_id']?.toString() ??
          '',
      providerName: data['provider_name']?.toString() ??
          (data['provider_detail'] is Map
              ? (data['provider_detail']['full_name'] ??
                  data['provider_detail']['business_name'])?.toString()
              : null),
      service: data['service']?.toString(),
      serviceType: data['service_type']?.toString() ?? '',
      serviceTypeName: data['service_type_name']?.toString() ??
          data['service_name']?.toString(),
      scheduledDate: data['scheduled_date']?.toString() ?? '',
      scheduledTime: data['scheduled_time']?.toString() ?? '',
      locationText: data['location_text']?.toString() ??
          data['location']?.toString() ??
          '',
      instructions: data['instructions']?.toString() ?? '',
      status: data['status']?.toString() ?? 'pending',
      price: data['price']?.toString(),
      serviceCost: data['service_cost']?.toString() ??
          data['quote_amount']?.toString(),
      rawJson: json,
    );
  }

  static String _resolveCategoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('gardening') || lower.contains('landscaping')) {
      return AssetsPath.categoryGardening;
    } else if (lower.contains('moving') || lower.contains('relocation')) {
      return AssetsPath.exploreProviderDetailsTagIconMoving1;
    } else if (lower.contains('electrical')) {
      return AssetsPath.exploreProviderDetailsTagIconElectrical;
    } else if (lower.contains('cleaning')) {
      return AssetsPath.categoryCleaning;
    } else if (lower.contains('plumbing')) {
      return AssetsPath.categoryPlumbing;
    } else if (lower.contains('painting') || lower.contains('decorating')) {
      return AssetsPath.exploreProviderDetailsTagIconPainting;
    }
    return AssetsPath.exploreProviderDetailsTagIconElectrical;
  }

  static String _formatDisplayTime(String rawTime) {
    if (rawTime.trim().isEmpty) return '8:00 AM';
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

  BookingHistoryData toBookingHistoryData({HomeProviderData? fallbackProvider}) {
    DateTime parsedDate = DateTime.now();
    try {
      if (scheduledDate.isNotEmpty) {
        parsedDate = DateTime.parse(scheduledDate);
      }
    } catch (_) {}

    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const fullMonthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    final dayStr = parsedDate.day.toString();
    final monthStr = monthNames[parsedDate.month - 1];
    final fullDateStr =
        '${parsedDate.day} ${fullMonthNames[parsedDate.month - 1]} ${parsedDate.year}';
    final timeStr = _formatDisplayTime(scheduledTime);

    final resolvedServiceName = serviceTypeName?.isNotEmpty == true
        ? serviceTypeName!
        : (service?.isNotEmpty == true
            ? service!
            : (fallbackProvider?.service.isNotEmpty == true
                ? fallbackProvider!.service
                : 'Service'));

    final resolvedProviderName = providerName?.isNotEmpty == true
        ? providerName!
        : (fallbackProvider?.name.isNotEmpty == true
            ? fallbackProvider!.name
            : 'Service Provider');

    final effectiveProvider = fallbackProvider ??
        HomeProviderData(
          id: providerId,
          photo: AssetsPath.providerRobert,
          name: resolvedProviderName,
          service: resolvedServiceName,
          price: price ?? 'ZMW 100',
          rating: '5.0',
          email: '${resolvedProviderName.toLowerCase().replaceAll(' ', '.')}@gmail.com',
          phone: '+260 97 555 1234',
          area: locationText.isNotEmpty ? locationText : 'Lusaka, Zambia',
          description: instructions.isNotEmpty ? instructions : 'Professional service provider',
          reviewCount: '1',
          totalJobsCompleted: '1',
          tags: [
            ProviderTag(
              iconAsset: _resolveCategoryIcon(resolvedServiceName),
              label: resolvedServiceName,
            ),
          ],
        );

    return BookingHistoryData(
      iconAsset: _resolveCategoryIcon(resolvedServiceName),
      iconBgColor: const Color(0xFFDBEAFE),
      providerName: resolvedProviderName,
      service: resolvedServiceName,
      price: price ?? 'Pending Quote',
      serviceCost: serviceCost,
      day: dayStr,
      month: monthStr,
      date: fullDateStr,
      time: timeStr,
      status: AppText.pending, // Newly created booking is pending
      location: locationText.isNotEmpty ? locationText : 'Lusaka, Zambia',
      details: instructions.isNotEmpty
          ? instructions
          : 'Service booking request sent to provider. Waiting for price quote.',
      provider: effectiveProvider,
    );
  }
}
