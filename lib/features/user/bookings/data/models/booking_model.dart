import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
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
  final String? reference;
  final String? serviceTitle;
  final String providerId;
  final String? providerName;
  final String? providerAvatar;
  final String? customer;
  final String? customerName;
  final String? service;
  final String serviceType;
  final String? serviceTypeName;
  final String scheduledDate;
  final String scheduledTime;
  final String locationText;
  final String instructions;
  final String? serviceCost;
  final String? platformFee;
  final String? totalCost;
  final String? currency;
  final bool isQuoted;
  final String status;
  final String? statusDisplay;
  final String? statusLabel;
  final bool hasReview;
  final String? createdAt;
  final String? price;
  final Map<String, dynamic>? rawJson;

  const BookingResponseModel({
    required this.id,
    this.reference,
    this.serviceTitle,
    required this.providerId,
    this.providerName,
    this.providerAvatar,
    this.customer,
    this.customerName,
    this.service,
    required this.serviceType,
    this.serviceTypeName,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.locationText,
    required this.instructions,
    this.serviceCost,
    this.platformFee,
    this.totalCost,
    this.currency,
    this.isQuoted = false,
    required this.status,
    this.statusDisplay,
    this.statusLabel,
    this.hasReview = false,
    this.createdAt,
    this.price,
    this.rawJson,
  });

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return BookingResponseModel(
      id: data['id']?.toString() ?? '',
      reference: data['reference']?.toString(),
      serviceTitle: data['service_title']?.toString(),
      providerId: data['provider']?.toString() ??
          data['provider_id']?.toString() ??
          '',
      providerName: data['provider_name']?.toString() ??
          (data['provider_detail'] is Map
              ? (data['provider_detail']['full_name'] ??
                      data['provider_detail']['business_name'])
                  ?.toString()
              : null),
      providerAvatar: data['provider_avatar']?.toString(),
      customer: data['customer']?.toString(),
      customerName: data['customer_name']?.toString(),
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
      serviceCost: data['service_cost']?.toString() ??
          data['quote_amount']?.toString(),
      platformFee: data['platform_fee']?.toString(),
      totalCost: data['total_cost']?.toString(),
      currency: data['currency']?.toString() ?? 'ZMW',
      isQuoted: data['is_quoted'] as bool? ?? false,
      status: data['status']?.toString() ?? 'pending',
      statusDisplay: data['status_display']?.toString(),
      statusLabel: data['status_label']?.toString(),
      hasReview: data['has_review'] as bool? ?? false,
      createdAt: data['created_at']?.toString(),
      price: data['price']?.toString(),
      rawJson: json,
    );
  }

  static String _resolveCategoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('gardening') || lower.contains('landscaping')) {
      return AssetsPath.categoryGardening;
    } else if (lower.contains('moving') || lower.contains('relocation')) {
      return AssetsPath.bookingIconMoving;
    } else if (lower.contains('electrical')) {
      return AssetsPath.bookingIconElectrical;
    } else if (lower.contains('cleaning')) {
      return AssetsPath.bookingIconCleaning;
    } else if (lower.contains('plumbing')) {
      return AssetsPath.categoryPlumbing;
    } else if (lower.contains('painting') || lower.contains('decorating')) {
      return AssetsPath.categoryPainting;
    }
    return AssetsPath.bookingIconElectrical;
  }

  static (Color bg, Color icon) _resolveCategoryColors(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('gardening') || lower.contains('landscaping')) {
      return (AppColors.lime50, AppColors.lime400);
    } else if (lower.contains('moving') || lower.contains('relocation')) {
      return (AppColors.blue50, AppColors.blue400);
    } else if (lower.contains('electrical')) {
      return (AppColors.orange50, AppColors.orange400);
    } else if (lower.contains('cleaning')) {
      return (AppColors.emerald50, AppColors.emerald400);
    } else if (lower.contains('plumbing')) {
      return (AppColors.red50, AppColors.red400);
    } else if (lower.contains('painting') || lower.contains('decorating')) {
      return (AppColors.teal50, AppColors.cyan400);
    }
    return (AppColors.orange50, AppColors.orange400);
  }

  static String _formatDisplayTime(String rawTime) {
    if (rawTime.trim().isEmpty) return '8:00 AM';
    try {
      // Handle ISO strings e.g. "02:51:06.375Z" or "2026-09-21T02:51:06.375Z"
      if (rawTime.contains('T')) {
        final dt = DateTime.parse(rawTime).toLocal();
        final period = dt.hour >= 12 ? 'PM' : 'AM';
        int displayHour = dt.hour % 12;
        if (displayHour == 0) displayHour = 12;
        final minuteStr = dt.minute.toString().padLeft(2, '0');
        return '$displayHour:$minuteStr $period';
      }
      final parts = rawTime.split(':');
      if (parts.isEmpty) return rawTime;
      int hour = int.parse(parts[0]);
      int minute = parts.length > 1 ? int.parse(parts[1].split('.')[0]) : 0;
      final period = hour >= 12 ? 'PM' : 'AM';
      int displayHour = hour % 12;
      if (displayHour == 0) displayHour = 12;
      final minuteStr = minute.toString().padLeft(2, '0');
      return '$displayHour:$minuteStr $period';
    } catch (_) {
      return rawTime;
    }
  }

  static String _formatDisplayDate(String rawDate) {
    if (rawDate.trim().isEmpty) return '21 Sep 2026';
    try {
      final dt = DateTime.parse(rawDate);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final dayStr = dt.day.toString().padLeft(2, '0');
      return '$dayStr ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return rawDate;
    }
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    final clean = s.replaceAll('_', ' ');
    return clean.split(' ').map((w) {
      if (w.isEmpty) return w;
      return '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}';
    }).join(' ');
  }

  String get displayPrice {
    final cur = (currency != null && currency!.trim().isNotEmpty)
        ? currency!.trim()
        : 'ZMW';

    if (totalCost != null && totalCost!.trim().isNotEmpty && totalCost != '0') {
      final val = double.tryParse(totalCost!);
      if (val != null) {
        if (val == val.roundToDouble()) {
          return '$cur ${val.toInt()}';
        }
        return '$cur ${val.toStringAsFixed(2)}';
      }
      return '$cur $totalCost';
    }

    if (serviceCost != null &&
        serviceCost!.trim().isNotEmpty &&
        serviceCost != '0') {
      final val = double.tryParse(serviceCost!);
      if (val != null) {
        if (val == val.roundToDouble()) {
          return '$cur ${val.toInt()}';
        }
        return '$cur ${val.toStringAsFixed(2)}';
      }
      return '$cur $serviceCost';
    }

    if (price != null && price!.trim().isNotEmpty) {
      return price!;
    }

    return isQuoted ? '$cur 0' : 'Pending Quote';
  }

  HomeBookingData toHomeBookingData({HomeProviderData? fallbackProvider}) {
    final resolvedServiceName = serviceTitle?.isNotEmpty == true
        ? serviceTitle!
        : (serviceTypeName?.isNotEmpty == true
            ? serviceTypeName!
            : (service?.isNotEmpty == true
                ? service!
                : (fallbackProvider?.service.isNotEmpty == true
                    ? fallbackProvider!.service
                    : 'Service')));

    final resolvedProviderName = providerName?.isNotEmpty == true
        ? providerName!
        : (fallbackProvider?.name.isNotEmpty == true
            ? fallbackProvider!.name
            : 'Service Provider');

    final iconAsset = _resolveCategoryIcon(resolvedServiceName);
    final (iconBg, iconColor) = _resolveCategoryColors(resolvedServiceName);

    final resolvedStatus = statusLabel?.isNotEmpty == true
        ? statusLabel!
        : (statusDisplay?.isNotEmpty == true
            ? statusDisplay!
            : _capitalize(status));

    final effectiveProvider = fallbackProvider ??
        HomeProviderData(
          id: providerId,
          photo: (providerAvatar != null && providerAvatar!.trim().isNotEmpty)
              ? providerAvatar!.trim()
              : AssetsPath.providerRobert,
          name: resolvedProviderName,
          service: resolvedServiceName,
          price: displayPrice,
          rating: '5.0',
          email:
              '${resolvedProviderName.toLowerCase().replaceAll(RegExp(r'\s+'), '.')}@gmail.com',
          phone: '+260 97 555 1234',
          area: locationText.isNotEmpty ? locationText : 'Lusaka, Zambia',
          description: instructions.isNotEmpty
              ? instructions
              : 'Professional service provider offering $resolvedServiceName.',
          reviewCount: '1',
          totalJobsCompleted: '1',
          tags: [
            ProviderTag(
              iconAsset: iconAsset,
              label: resolvedServiceName,
            ),
          ],
        );

    return HomeBookingData(
      iconAsset: iconAsset,
      iconBgColor: iconBg,
      iconColor: iconColor,
      providerName: resolvedProviderName,
      service: resolvedServiceName,
      price: displayPrice,
      date: _formatDisplayDate(scheduledDate),
      time: _formatDisplayTime(scheduledTime),
      status: resolvedStatus,
      location: locationText.isNotEmpty ? locationText : 'Lusaka, Zambia',
      details: instructions.isNotEmpty
          ? instructions
          : (reference?.isNotEmpty == true
              ? 'Booking reference: $reference'
              : 'Service booking request sent to provider.'),
      provider: effectiveProvider,
    );
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

    final resolvedServiceName = serviceTitle?.isNotEmpty == true
        ? serviceTitle!
        : (serviceTypeName?.isNotEmpty == true
            ? serviceTypeName!
            : (service?.isNotEmpty == true
                ? service!
                : (fallbackProvider?.service.isNotEmpty == true
                    ? fallbackProvider!.service
                    : 'Service')));

    final resolvedProviderName = providerName?.isNotEmpty == true
        ? providerName!
        : (fallbackProvider?.name.isNotEmpty == true
            ? fallbackProvider!.name
            : 'Service Provider');

    final effectiveProvider = fallbackProvider ??
        HomeProviderData(
          id: providerId,
          photo: (providerAvatar != null && providerAvatar!.trim().isNotEmpty)
              ? providerAvatar!.trim()
              : AssetsPath.providerRobert,
          name: resolvedProviderName,
          service: resolvedServiceName,
          price: displayPrice,
          rating: '5.0',
          email:
              '${resolvedProviderName.toLowerCase().replaceAll(RegExp(r'\s+'), '.')}@gmail.com',
          phone: '+260 97 555 1234',
          area: locationText.isNotEmpty ? locationText : 'Lusaka, Zambia',
          description: instructions.isNotEmpty
              ? instructions
              : 'Professional service provider',
          reviewCount: '1',
          totalJobsCompleted: '1',
          tags: [
            ProviderTag(
              iconAsset: _resolveCategoryIcon(resolvedServiceName),
              label: resolvedServiceName,
            ),
          ],
        );

    final resolvedStatus = statusLabel?.isNotEmpty == true
        ? statusLabel!
        : (statusDisplay?.isNotEmpty == true
            ? statusDisplay!
            : (status.toLowerCase() == 'pending'
                ? AppText.pending
                : _capitalize(status)));

    return BookingHistoryData(
      iconAsset: _resolveCategoryIcon(resolvedServiceName),
      iconBgColor: const Color(0xFFDBEAFE),
      providerName: resolvedProviderName,
      service: resolvedServiceName,
      price: displayPrice,
      serviceCost: serviceCost,
      day: dayStr,
      month: monthStr,
      date: fullDateStr,
      time: timeStr,
      status: resolvedStatus,
      location: locationText.isNotEmpty ? locationText : 'Lusaka, Zambia',
      details: instructions.isNotEmpty
          ? instructions
          : (reference?.isNotEmpty == true
              ? 'Booking reference: $reference'
              : 'Service booking request sent to provider. Waiting for price quote.'),
      provider: effectiveProvider,
    );
  }
}

class CustomerBookingsResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<BookingResponseModel> results;
  final int currentPage;
  final int totalPages;
  final int pageSize;

  const CustomerBookingsResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
    this.currentPage = 1,
    this.totalPages = 1,
    this.pageSize = 10,
  });

  factory CustomerBookingsResponseModel.fromJson(
    Map<String, dynamic> json, {
    int requestedPage = 1,
    int requestedPageSize = 10,
  }) {
    final rawList = (json['results'] ?? json['data']) as List<dynamic>? ?? [];
    final count = json['count'] as int? ?? rawList.length;
    final pageSize = json['page_size'] as int? ?? requestedPageSize;
    final totalPages = json['total_pages'] as int? ??
        (count > 0 ? (count / pageSize).ceil() : 1);
    final currentPage = json['current_page'] as int? ?? requestedPage;

    return CustomerBookingsResponseModel(
      count: count,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: rawList
          .map((e) => BookingResponseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: currentPage,
      totalPages: totalPages,
      pageSize: pageSize,
    );
  }
}
