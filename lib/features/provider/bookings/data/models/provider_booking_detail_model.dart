import 'package:flutter/material.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/provider/bookings/presentation/widgets/provider_booking_sample_data.dart';

class ProviderBookingStatusEventModel {
  final String id;
  final String fromStatus;
  final String toStatus;
  final String? actorName;
  final String? note;
  final String? createdAt;

  const ProviderBookingStatusEventModel({
    required this.id,
    required this.fromStatus,
    required this.toStatus,
    this.actorName,
    this.note,
    this.createdAt,
  });

  factory ProviderBookingStatusEventModel.fromJson(Map<String, dynamic> json) {
    return ProviderBookingStatusEventModel(
      id: json['id']?.toString() ?? '',
      fromStatus: json['from_status']?.toString() ?? '',
      toStatus: json['to_status']?.toString() ?? '',
      actorName: json['actor_name']?.toString(),
      note: json['note']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class ProviderBookingAttachmentModel {
  final String id;
  final String file;
  final String? caption;
  final String? createdAt;

  const ProviderBookingAttachmentModel({
    required this.id,
    required this.file,
    this.caption,
    this.createdAt,
  });

  factory ProviderBookingAttachmentModel.fromJson(Map<String, dynamic> json) {
    return ProviderBookingAttachmentModel(
      id: json['id']?.toString() ?? '',
      file: json['file']?.toString() ?? '',
      caption: json['caption']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class ProviderBookingQuoteModel {
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

  const ProviderBookingQuoteModel({
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

  factory ProviderBookingQuoteModel.fromJson(Map<String, dynamic> json) {
    return ProviderBookingQuoteModel(
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

/// The review embedded directly on a booking detail response (`review:
/// {exists, id, author_name, author_avatar, rating, rating_display,
/// comment, created_at, reply}`) — confirmed live. Cheaper than a
/// separate reviews-list call when a screen just needs "does this
/// booking have a review, and what does it say".
class BookingEmbeddedReviewModel {
  final bool exists;
  final String? id;
  final String? authorName;
  final String? authorAvatar;
  final int rating;
  final String? ratingDisplay;
  final String? comment;
  final String? createdAt;
  final String? replyMessage;

  const BookingEmbeddedReviewModel({
    this.exists = false,
    this.id,
    this.authorName,
    this.authorAvatar,
    this.rating = 0,
    this.ratingDisplay,
    this.comment,
    this.createdAt,
    this.replyMessage,
  });

  factory BookingEmbeddedReviewModel.fromJson(Map<String, dynamic> json) {
    final reply = json['reply'];
    return BookingEmbeddedReviewModel(
      exists: json['exists'] as bool? ?? false,
      id: json['id']?.toString(),
      authorName: json['author_name']?.toString(),
      authorAvatar: json['author_avatar']?.toString(),
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      ratingDisplay: json['rating_display']?.toString(),
      comment: json['comment']?.toString(),
      createdAt: json['created_at']?.toString(),
      replyMessage: reply is Map<String, dynamic>
          ? reply['message']?.toString()
          : null,
    );
  }
}

/// The counterparty on a booking detail — from the provider's perspective
/// this is the customer, but the API returns the same generic shape
/// (`id`, `full_name`, `avatar`, `role`, `email`, `contact_phone`) it uses
/// for the customer app's `counterparty`.
class ProviderBookingPartyModel {
  final String id;
  final String? fullName;
  final String? avatar;
  final String? role;
  final String? email;
  final String? contactPhone;

  const ProviderBookingPartyModel({
    required this.id,
    this.fullName,
    this.avatar,
    this.role,
    this.email,
    this.contactPhone,
  });

  factory ProviderBookingPartyModel.fromJson(Map<String, dynamic> json) {
    return ProviderBookingPartyModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString(),
      avatar: json['avatar']?.toString(),
      role: json['role']?.toString(),
      email: json['email']?.toString(),
      contactPhone: json['contact_phone']?.toString(),
    );
  }
}

class ProviderBookingDetailModel {
  final String id;
  final String? reference;
  final String? serviceTitle;
  final String? serviceType;
  final String? serviceTypeName;
  final String? provider;
  final String? providerName;
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
  final ProviderBookingPartyModel? customerDetail;
  final String? service;
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
  final List<ProviderBookingStatusEventModel> statusEvents;
  final List<ProviderBookingAttachmentModel> attachments;
  final String? disputeStatus;
  final bool isCancellable;
  final bool isDisputable;
  final String? completionCode;
  final ProviderBookingPartyModel? counterparty;
  final bool isCompletionVerified;
  final BookingEmbeddedReviewModel? review;
  final dynamic availableActions;
  final dynamic dispute;
  final dynamic cancellation;
  final dynamic rescheduleRequest;
  final List<ProviderBookingQuoteModel> quotes;
  final ProviderBookingQuoteModel? currentQuote;
  final String? paymentState;
  final Map<String, dynamic>? rawJson;

  const ProviderBookingDetailModel({
    required this.id,
    this.reference,
    this.serviceTitle,
    this.serviceType,
    this.serviceTypeName,
    this.provider,
    this.providerName,
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
    this.quotes = const [],
    this.currentQuote,
    this.paymentState,
    this.rawJson,
  });

  factory ProviderBookingDetailModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return ProviderBookingDetailModel(
      id: data['id']?.toString() ?? '',
      reference: data['reference']?.toString(),
      serviceTitle: data['service_title']?.toString(),
      serviceType: data['service_type']?.toString(),
      serviceTypeName: data['service_type_name']?.toString(),
      provider: data['provider']?.toString(),
      providerName: data['provider_name']?.toString(),
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
          ? ProviderBookingPartyModel.fromJson(
              data['customer_detail'] as Map<String, dynamic>)
          : null,
      service: data['service']?.toString(),
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
              ?.map((e) => ProviderBookingStatusEventModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      attachments: (data['attachments'] as List<dynamic>?)
              ?.map((e) => ProviderBookingAttachmentModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      disputeStatus: data['dispute_status']?.toString(),
      isCancellable: data['is_cancellable'] as bool? ?? false,
      isDisputable: data['is_disputable'] as bool? ?? false,
      completionCode: data['completion_code']?.toString(),
      counterparty: data['counterparty'] is Map<String, dynamic>
          ? ProviderBookingPartyModel.fromJson(
              data['counterparty'] as Map<String, dynamic>)
          : null,
      isCompletionVerified: data['is_completion_verified'] as bool? ?? false,
      review: data['review'] is Map<String, dynamic>
          ? BookingEmbeddedReviewModel.fromJson(
              data['review'] as Map<String, dynamic>)
          : null,
      availableActions: data['available_actions'],
      dispute: data['dispute'],
      cancellation: data['cancellation'],
      rescheduleRequest: data['reschedule_request'],
      quotes: (data['quotes'] as List<dynamic>?)
              ?.map((e) =>
                  ProviderBookingQuoteModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentQuote: data['current_quote'] is Map<String, dynamic>
          ? ProviderBookingQuoteModel.fromJson(
              data['current_quote'] as Map<String, dynamic>)
          : null,
      paymentState: data['payment_state']?.toString(),
      rawJson: json,
    );
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

  /// Short "15 Mar 2026" date, for compact cards (e.g. a review's date).
  static String formattedShortDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) return '';
    try {
      final dt = DateTime.parse(rawDate).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
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
    if (currentQuote != null && currentQuote!.total != null) {
      return '$cur ${currentQuote!.total}';
    }
    return isQuoted ? '$cur 0' : 'Pending Quote';
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

  /// Maps to the presentation-layer [ProviderBookingData] the provider
  /// bookings screens already know how to render.
  ProviderBookingData toProviderBookingData() {
    final resolvedCustomerName = customerName?.isNotEmpty == true
        ? customerName!
        : (customerDetail?.fullName?.isNotEmpty == true
            ? customerDetail!.fullName!
            : (counterparty?.fullName?.isNotEmpty == true
                ? counterparty!.fullName!
                : 'Customer'));

    final resolvedServiceName = serviceTitle?.isNotEmpty == true
        ? serviceTitle!
        : (serviceTypeName?.isNotEmpty == true
            ? serviceTypeName!
            : (service?.isNotEmpty == true ? service! : 'Service'));

    final resolvedStatus = statusLabel?.isNotEmpty == true
        ? statusLabel!
        : (statusDisplay?.isNotEmpty == true
            ? statusDisplay!
            : _capitalize(status));

    final avatar = customerDetail?.avatar?.trim().isNotEmpty == true
        ? customerDetail!.avatar!.trim()
        : (counterparty?.avatar?.trim().isNotEmpty == true
            ? counterparty!.avatar!.trim()
            : AssetsPath.avatarUser);

    final phoneOrEmail = customerDetail?.contactPhone?.trim().isNotEmpty == true
        ? customerDetail!.contactPhone!.trim()
        : (counterparty?.contactPhone?.trim().isNotEmpty == true
            ? counterparty!.contactPhone!.trim()
            : (counterparty?.email ?? ''));

    return ProviderBookingData(
      id: id,
      customerName: resolvedCustomerName,
      service: resolvedServiceName,
      price: displayPrice,
      iconAsset: AssetsPath.categoryCleaning,
      iconBgColor: const Color(0xFFDBEAFE),
      day: () {
        try {
          return DateTime.parse(scheduledDate ?? '').day.toString().padLeft(2, '0');
        } catch (_) {
          return '--';
        }
      }(),
      month: () {
        try {
          const monthNames = [
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
          ];
          return monthNames[DateTime.parse(scheduledDate ?? '').month - 1];
        } catch (_) {
          return '';
        }
      }(),
      time: _formatDisplayTime(scheduledTime),
      status: resolvedStatus,
      location: (locationText != null && locationText!.isNotEmpty)
          ? locationText!
          : 'Lusaka, Zambia',
      fullDate: _formatDisplayDate(scheduledDate),
      fullTime: _formatDisplayTime(scheduledTime),
      details: (instructions != null && instructions!.isNotEmpty)
          ? instructions!
          : (reference?.isNotEmpty == true
              ? 'Booking reference: $reference'
              : 'Service booking request.'),
      customerPhoto: avatar,
      customerEmailOrPhone: phoneOrEmail,
    );
  }
}
