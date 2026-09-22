import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_sample_data.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

class BookingStatusEventModel {
  final String id;
  final String fromStatus;
  final String toStatus;
  final String? actorName;
  final String? note;
  final String? createdAt;

  const BookingStatusEventModel({
    required this.id,
    required this.fromStatus,
    required this.toStatus,
    this.actorName,
    this.note,
    this.createdAt,
  });

  factory BookingStatusEventModel.fromJson(Map<String, dynamic> json) {
    return BookingStatusEventModel(
      id: json['id']?.toString() ?? '',
      fromStatus: json['from_status']?.toString() ?? '',
      toStatus: json['to_status']?.toString() ?? '',
      actorName: json['actor_name']?.toString(),
      note: json['note']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class BookingAttachmentModel {
  final String id;
  final String file;
  final String? caption;
  final String? createdAt;

  const BookingAttachmentModel({
    required this.id,
    required this.file,
    this.caption,
    this.createdAt,
  });

  factory BookingAttachmentModel.fromJson(Map<String, dynamic> json) {
    return BookingAttachmentModel(
      id: json['id']?.toString() ?? '',
      file: json['file']?.toString() ?? '',
      caption: json['caption']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class BookingQuoteModel {
  final String id;
  final int sequence;
  final String amount;
  final String? platformFeePercent;
  final String? platformFee;
  final String? total;
  final String? currency;
  final String? status;
  final String? statusDisplay;
  final String? sentByName;
  final String? note;
  final String? declineReason;
  final String? respondedAt;
  final String? createdAt;

  const BookingQuoteModel({
    required this.id,
    required this.sequence,
    required this.amount,
    this.platformFeePercent,
    this.platformFee,
    this.total,
    this.currency,
    this.status,
    this.statusDisplay,
    this.sentByName,
    this.note,
    this.declineReason,
    this.respondedAt,
    this.createdAt,
  });

  factory BookingQuoteModel.fromJson(Map<String, dynamic> json) {
    return BookingQuoteModel(
      id: json['id']?.toString() ?? '',
      sequence: json['sequence'] is num
          ? (json['sequence'] as num).toInt()
          : (int.tryParse(json['sequence']?.toString() ?? '') ?? 0),
      amount: json['amount']?.toString() ?? '0',
      platformFeePercent: json['platform_fee_percent']?.toString(),
      platformFee: json['platform_fee']?.toString(),
      total: json['total']?.toString(),
      currency: json['currency']?.toString() ?? 'ZMW',
      status: json['status']?.toString(),
      statusDisplay: json['status_display']?.toString(),
      sentByName: json['sent_by_name']?.toString(),
      note: json['note']?.toString(),
      declineReason: json['decline_reason']?.toString(),
      respondedAt: json['responded_at']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class BookingCounterpartyModel {
  final String id;
  final String? fullName;
  final String? avatar;
  final String? role;
  final String? email;
  final String? contactPhone;

  const BookingCounterpartyModel({
    required this.id,
    this.fullName,
    this.avatar,
    this.role,
    this.email,
    this.contactPhone,
  });

  factory BookingCounterpartyModel.fromJson(Map<String, dynamic> json) {
    return BookingCounterpartyModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString(),
      avatar: json['avatar']?.toString(),
      role: json['role']?.toString(),
      email: json['email']?.toString(),
      contactPhone: json['contact_phone']?.toString(),
    );
  }
}

class BookingCustomerDetailModel {
  final String id;
  final String? fullName;
  final String? avatar;
  final String? role;

  const BookingCustomerDetailModel({
    required this.id,
    this.fullName,
    this.avatar,
    this.role,
  });

  factory BookingCustomerDetailModel.fromJson(Map<String, dynamic> json) {
    return BookingCustomerDetailModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString(),
      avatar: json['avatar']?.toString(),
      role: json['role']?.toString(),
    );
  }
}

class CustomerBookingDetailModel {
  final String id;
  final String? reference;
  final String? serviceTitle;
  final String? serviceType;
  final String? serviceTypeName;
  final String? provider;
  final String? providerName;
  final String? providerAvatar;
  final String? customer;
  final String? customerName;
  final String? scheduledDate;
  final String? scheduledTime;
  final String? locationText;
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
  final BookingCustomerDetailModel? customerDetail;
  final String? service;
  final int? durationMinutes;
  final double? latitude;
  final double? longitude;
  final String? instructions;
  final String? platformFeePercent;
  final String? acceptedAt;
  final String? rejectedAt;
  final String? rejectionReason;
  final String? startedAt;
  final String? completedAt;
  final String? cancelledAt;
  final String? cancelledBy;
  final String? cancellationReason;
  final List<BookingStatusEventModel> statusEvents;
  final List<BookingAttachmentModel> attachments;
  final String? disputeStatus;
  final bool isCancellable;
  final bool isDisputable;
  final String? completionCode;
  final BookingCounterpartyModel? counterparty;
  final bool isCompletionVerified;
  final dynamic review;
  final dynamic availableActions;
  final dynamic dispute;
  final dynamic cancellation;
  final dynamic rescheduleRequest;
  final dynamic changePolicy;
  final List<BookingQuoteModel> quotes;
  final BookingQuoteModel? currentQuote;
  final String? pricing;
  final String? paymentState;
  final String? quotedAt;
  final String? paidAt;
  final Map<String, dynamic>? rawJson;

  const CustomerBookingDetailModel({
    required this.id,
    this.reference,
    this.serviceTitle,
    this.serviceType,
    this.serviceTypeName,
    this.provider,
    this.providerName,
    this.providerAvatar,
    this.customer,
    this.customerName,
    this.scheduledDate,
    this.scheduledTime,
    this.locationText,
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
    this.customerDetail,
    this.service,
    this.durationMinutes,
    this.latitude,
    this.longitude,
    this.instructions,
    this.platformFeePercent,
    this.acceptedAt,
    this.rejectedAt,
    this.rejectionReason,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancelledBy,
    this.cancellationReason,
    this.statusEvents = const [],
    this.attachments = const [],
    this.disputeStatus,
    this.isCancellable = false,
    this.isDisputable = false,
    this.completionCode,
    this.counterparty,
    this.isCompletionVerified = false,
    this.review,
    this.availableActions,
    this.dispute,
    this.cancellation,
    this.rescheduleRequest,
    this.changePolicy,
    this.quotes = const [],
    this.currentQuote,
    this.pricing,
    this.paymentState,
    this.quotedAt,
    this.paidAt,
    this.rawJson,
  });

  factory CustomerBookingDetailModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return CustomerBookingDetailModel(
      id: data['id']?.toString() ?? '',
      reference: data['reference']?.toString(),
      serviceTitle: data['service_title']?.toString(),
      serviceType: data['service_type']?.toString(),
      serviceTypeName: data['service_type_name']?.toString(),
      provider: data['provider']?.toString(),
      providerName: data['provider_name']?.toString(),
      providerAvatar: data['provider_avatar']?.toString(),
      customer: data['customer']?.toString(),
      customerName: data['customer_name']?.toString(),
      scheduledDate: data['scheduled_date']?.toString(),
      scheduledTime: data['scheduled_time']?.toString(),
      locationText: data['location_text']?.toString(),
      serviceCost: data['service_cost']?.toString(),
      platformFee: data['platform_fee']?.toString(),
      totalCost: data['total_cost']?.toString(),
      currency: data['currency']?.toString() ?? 'ZMW',
      isQuoted: data['is_quoted'] as bool? ?? false,
      status: data['status']?.toString() ?? 'pending',
      statusDisplay: data['status_display']?.toString(),
      statusLabel: data['status_label']?.toString(),
      hasReview: data['has_review'] as bool? ?? false,
      createdAt: data['created_at']?.toString(),
      customerDetail: data['customer_detail'] is Map<String, dynamic>
          ? BookingCustomerDetailModel.fromJson(
              data['customer_detail'] as Map<String, dynamic>)
          : null,
      service: data['service']?.toString(),
      durationMinutes: data['duration_minutes'] is num
          ? (data['duration_minutes'] as num).toInt()
          : int.tryParse(data['duration_minutes']?.toString() ?? ''),
      latitude: data['latitude'] is num
          ? (data['latitude'] as num).toDouble()
          : double.tryParse(data['latitude']?.toString() ?? ''),
      longitude: data['longitude'] is num
          ? (data['longitude'] as num).toDouble()
          : double.tryParse(data['longitude']?.toString() ?? ''),
      instructions: data['instructions']?.toString(),
      platformFeePercent: data['platform_fee_percent']?.toString(),
      acceptedAt: data['accepted_at']?.toString(),
      rejectedAt: data['rejected_at']?.toString(),
      rejectionReason: data['rejection_reason']?.toString(),
      startedAt: data['started_at']?.toString(),
      completedAt: data['completed_at']?.toString(),
      cancelledAt: data['cancelled_at']?.toString(),
      cancelledBy: data['cancelled_by']?.toString(),
      cancellationReason: data['cancellation_reason']?.toString(),
      statusEvents: (data['status_events'] as List<dynamic>?)
              ?.map((e) =>
                  BookingStatusEventModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      attachments: (data['attachments'] as List<dynamic>?)
              ?.map((e) =>
                  BookingAttachmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      disputeStatus: data['dispute_status']?.toString(),
      isCancellable: data['is_cancellable'] as bool? ?? false,
      isDisputable: data['is_disputable'] as bool? ?? false,
      completionCode: data['completion_code']?.toString(),
      counterparty: data['counterparty'] is Map<String, dynamic>
          ? BookingCounterpartyModel.fromJson(
              data['counterparty'] as Map<String, dynamic>)
          : null,
      isCompletionVerified:
          data['is_completion_verified'] as bool? ?? false,
      review: data['review'],
      availableActions: data['available_actions'],
      dispute: data['dispute'],
      cancellation: data['cancellation'],
      rescheduleRequest: data['reschedule_request'],
      changePolicy: data['change_policy'],
      quotes: (data['quotes'] as List<dynamic>?)
              ?.map((e) =>
                  BookingQuoteModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentQuote: data['current_quote'] is Map<String, dynamic>
          ? BookingQuoteModel.fromJson(
              data['current_quote'] as Map<String, dynamic>)
          : null,
      pricing: data['pricing']?.toString(),
      paymentState: data['payment_state']?.toString(),
      quotedAt: data['quoted_at']?.toString(),
      paidAt: data['paid_at']?.toString(),
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

  static String _formatDisplayTime(String? rawTime) {
    if (rawTime == null || rawTime.trim().isEmpty) return '10:00 AM';
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

  static String _formatDisplayDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) return '22 Sep 2026';
    try {
      final dt = DateTime.parse(rawDate);
      const fullMonthNames = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return '${dt.day} ${fullMonthNames[dt.month - 1]} ${dt.year}';
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

    if (currentQuote != null && currentQuote!.total != null) {
      return '$cur ${currentQuote!.total}';
    }

    return isQuoted ? '$cur 0' : 'Pending Quote';
  }

  String? get resolvedServiceCost {
    final cur = (currency != null && currency!.trim().isNotEmpty)
        ? currency!.trim()
        : 'ZMW';
    if (serviceCost != null &&
        serviceCost!.trim().isNotEmpty &&
        serviceCost != '0') {
      final val = double.tryParse(serviceCost!);
      if (val != null) {
        return '$cur ${val == val.roundToDouble() ? val.toInt() : val.toStringAsFixed(2)}';
      }
      return '$cur $serviceCost';
    }
    if (currentQuote != null && currentQuote!.amount.isNotEmpty) {
      return '$cur ${currentQuote!.amount}';
    }
    return null;
  }

  String get formattedCompletionOtp {
    if (completionCode != null && completionCode!.trim().isNotEmpty) {
      return completionCode!.trim().split('').join('  ');
    }
    return '4  8  2  7  3  1';
  }

  String get formattedCompletedOn {
    if (completedAt != null && completedAt!.trim().isNotEmpty) {
      try {
        final dt = DateTime.parse(completedAt!).toLocal();
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        final period = dt.hour >= 12 ? 'PM' : 'AM';
        int displayHour = dt.hour % 12;
        if (displayHour == 0) displayHour = 12;
        final minuteStr = dt.minute.toString().padLeft(2, '0');
        return '${dt.day} ${months[dt.month - 1]} ${dt.year} - ${displayHour.toString().padLeft(2, '0')}:$minuteStr $period';
      } catch (_) {}
    }
    return '27 Aug 2026 - 06:20 AM';
  }

  BookingHistoryData toBookingHistoryData({HomeProviderData? fallbackProvider}) {
    DateTime parsedDate = DateTime.now();
    try {
      if (scheduledDate != null && scheduledDate!.isNotEmpty) {
        parsedDate = DateTime.parse(scheduledDate!);
      }
    } catch (_) {}

    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final dayStr = parsedDate.day.toString();
    final monthStr = monthNames[parsedDate.month - 1];
    final fullDateStr = _formatDisplayDate(scheduledDate);
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
        : (counterparty?.fullName?.isNotEmpty == true
            ? counterparty!.fullName!
            : (fallbackProvider?.name.isNotEmpty == true
                ? fallbackProvider!.name
                : 'Service Provider'));

    final effectiveProvider = fallbackProvider ??
        HomeProviderData(
          id: provider ?? counterparty?.id,
          photo: (providerAvatar != null && providerAvatar!.trim().isNotEmpty)
              ? providerAvatar!.trim()
              : (counterparty?.avatar != null && counterparty!.avatar!.trim().isNotEmpty
                  ? counterparty!.avatar!.trim()
                  : AssetsPath.providerRobert),
          name: resolvedProviderName,
          service: resolvedServiceName,
          price: displayPrice,
          rating: '5.0',
          email: counterparty?.email ??
              '${resolvedProviderName.toLowerCase().replaceAll(RegExp(r'\s+'), '.')}@gmail.com',
          phone: counterparty?.contactPhone ?? '+260 97 555 1234',
          area: (locationText != null && locationText!.isNotEmpty)
              ? locationText!
              : 'Lusaka, Zambia',
          description: (instructions != null && instructions!.isNotEmpty)
              ? instructions!
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
                : (status.toLowerCase() == 'in_progress'
                    ? AppText.inProgress
                    : _capitalize(status))));

    return BookingHistoryData(
      id: id,
      iconAsset: _resolveCategoryIcon(resolvedServiceName),
      iconBgColor: const Color(0xFFDBEAFE),
      providerName: resolvedProviderName,
      service: resolvedServiceName,
      price: displayPrice,
      serviceCost: resolvedServiceCost,
      day: dayStr,
      month: monthStr,
      date: fullDateStr,
      time: timeStr,
      status: resolvedStatus,
      location: (locationText != null && locationText!.isNotEmpty)
          ? locationText!
          : 'Lusaka, Zambia',
      details: (instructions != null && instructions!.isNotEmpty)
          ? instructions!
          : (reference?.isNotEmpty == true
              ? 'Booking reference: $reference'
              : 'Service booking request.'),
      provider: effectiveProvider,
    );
  }
}
