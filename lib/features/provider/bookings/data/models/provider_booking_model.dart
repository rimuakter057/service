import 'package:flutter/material.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/provider_booking_sample_data.dart';

/// A booking as seen by the provider — list item shape returned by
/// `GET /provider/bookings/`. Mirrors `BookingResponseModel` (customer
/// side) but the counterparty shown is the customer, not the provider.
class ProviderBookingModel {
  final String id;
  final String? reference;
  final String? serviceTitle;
  final String? provider;
  final String? providerName;
  final String? customer;
  final String? customerName;
  final String? customerAvatar;
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
  final Map<String, dynamic>? rawJson;

  const ProviderBookingModel({
    required this.id,
    this.reference,
    this.serviceTitle,
    this.provider,
    this.providerName,
    this.customer,
    this.customerName,
    this.customerAvatar,
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
    this.rawJson,
  });

  factory ProviderBookingModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return ProviderBookingModel(
      id: data['id']?.toString() ?? '',
      reference: data['reference']?.toString(),
      serviceTitle: data['service_title']?.toString(),
      provider: data['provider']?.toString(),
      providerName: data['provider_name']?.toString(),
      customer: data['customer']?.toString(),
      customerName: data['customer_name']?.toString() ??
          (data['customer_detail'] is Map
              ? data['customer_detail']['full_name']?.toString()
              : null),
      customerAvatar: data['customer_avatar']?.toString() ??
          (data['customer_detail'] is Map
              ? data['customer_detail']['avatar']?.toString()
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
      rawJson: json,
    );
  }

  static String _formatDisplayTime(String rawTime) {
    if (rawTime.trim().isEmpty) return '8:00 AM';
    try {
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
      return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}';
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
    return AssetsPath.bookingIconCleaning;
  }

  static Color _resolveCategoryBgColor(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('gardening') || lower.contains('landscaping')) {
      return const Color(0xFFECFCCB); // lime-50
    } else if (lower.contains('moving') || lower.contains('relocation')) {
      return const Color(0xFFDBEAFE); // blue-50
    } else if (lower.contains('electrical')) {
      return const Color(0xFFFFF7ED); // orange-50
    } else if (lower.contains('cleaning')) {
      return const Color(0xFFD1FAE5); // emerald-50
    } else if (lower.contains('plumbing')) {
      return const Color(0xFFFEE2E2); // red-50
    } else if (lower.contains('painting') || lower.contains('decorating')) {
      return const Color(0xFFCCFBF1); // teal-50
    }
    return const Color(0xFFDBEAFE); // default blue-50
  }

  String get displayPrice {
    final cur = (currency != null && currency!.trim().isNotEmpty)
        ? currency!.trim()
        : 'ZMW';
    if (totalCost != null && totalCost!.trim().isNotEmpty && totalCost != '0') {
      final val = double.tryParse(totalCost!);
      if (val != null) {
        return val == val.roundToDouble()
            ? '$cur ${val.toInt()}'
            : '$cur ${val.toStringAsFixed(2)}';
      }
      return '$cur $totalCost';
    }
    if (serviceCost != null && serviceCost!.trim().isNotEmpty && serviceCost != '0') {
      final val = double.tryParse(serviceCost!);
      if (val != null) {
        return val == val.roundToDouble()
            ? '$cur ${val.toInt()}'
            : '$cur ${val.toStringAsFixed(2)}';
      }
      return '$cur $serviceCost';
    }
    return isQuoted ? '$cur 0' : 'Pending Quote';
  }

  /// Maps to the presentation-layer [ProviderBookingData] already used by
  /// the Provider Booking Details / Home screens.
  ProviderBookingData toProviderBookingData() {
    final dayStr = () {
      try {
        return DateTime.parse(scheduledDate).day.toString().padLeft(2, '0');
      } catch (_) {
        return '--';
      }
    }();
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final monthStr = () {
      try {
        return monthNames[DateTime.parse(scheduledDate).month - 1];
      } catch (_) {
        return '';
      }
    }();

    final resolvedServiceName = serviceTitle?.isNotEmpty == true
        ? serviceTitle!
        : (serviceTypeName?.isNotEmpty == true
            ? serviceTypeName!
            : (service?.isNotEmpty == true
                ? service!
                : _capitalize(serviceType).isNotEmpty
                    ? _capitalize(serviceType)
                    : 'Service'));

    final resolvedStatus = statusLabel?.isNotEmpty == true
        ? statusLabel!
        : (statusDisplay?.isNotEmpty == true ? statusDisplay! : _capitalize(status));

    final resolvedCustomerName = customerName?.isNotEmpty == true
        ? customerName!
        : 'Customer';

    final resolvedLocation = locationText.isNotEmpty ? locationText : '–';

    final resolvedDetails = instructions.isNotEmpty
        ? instructions
        : (reference?.isNotEmpty == true
            ? 'Booking ref: $reference'
            : '–');

    final resolvedPhoto =
        (customerAvatar != null && customerAvatar!.trim().isNotEmpty)
            ? customerAvatar!.trim()
            : AssetsPath.avatarUser;

    return ProviderBookingData(
      id: id,
      customerName: resolvedCustomerName,
      service: resolvedServiceName,
      price: displayPrice,
      iconAsset: _resolveCategoryIcon(resolvedServiceName),
      iconBgColor: _resolveCategoryBgColor(resolvedServiceName),
      day: dayStr,
      month: monthStr,
      time: _formatDisplayTime(scheduledTime),
      status: resolvedStatus,
      location: resolvedLocation,
      fullDate: _formatDisplayDate(scheduledDate),
      fullTime: _formatDisplayTime(scheduledTime),
      details: resolvedDetails,
      customerPhoto: resolvedPhoto,
      customerEmailOrPhone: '',
    );
  }
}

class ProviderBookingsResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<ProviderBookingModel> results;
  final int currentPage;
  final int totalPages;
  final int pageSize;

  const ProviderBookingsResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
    this.currentPage = 1,
    this.totalPages = 1,
    this.pageSize = 10,
  });

  factory ProviderBookingsResponseModel.fromJson(
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

    return ProviderBookingsResponseModel(
      count: count,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: rawList
          .map((e) => ProviderBookingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: currentPage,
      totalPages: totalPages,
      pageSize: pageSize,
    );
  }
}
