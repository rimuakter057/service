import 'package:flutter/material.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

class ReviewAuthorModel {
  final String? id;
  final String? fullName;
  final String? avatar;
  final String? role;

  const ReviewAuthorModel({this.id, this.fullName, this.avatar, this.role});

  factory ReviewAuthorModel.fromJson(Map<String, dynamic> json) {
    return ReviewAuthorModel(
      id: json['id']?.toString(),
      fullName: json['full_name']?.toString(),
      avatar: json['avatar']?.toString(),
      role: json['role']?.toString(),
    );
  }
}

class ReviewReplyModel {
  final String? message;
  final ReviewAuthorModel? authorDetail;
  final String? createdAt;

  const ReviewReplyModel({this.message, this.authorDetail, this.createdAt});

  factory ReviewReplyModel.fromJson(Map<String, dynamic> json) {
    return ReviewReplyModel(
      message: json['message']?.toString(),
      authorDetail: json['author_detail'] is Map<String, dynamic>
          ? ReviewAuthorModel.fromJson(json['author_detail'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at']?.toString(),
    );
  }
}

/// A review on a provider — same resource shape whether reached via
/// `/customer/reviews/` (browsing a provider before booking) or
/// `/provider/reviews/` (a provider's own dashboard). Confirmed live.
class CustomerReviewModel {
  final String id;
  final String? booking;
  final String? bookingReference;
  final String? provider;
  final String? service;
  final ReviewAuthorModel? authorDetail;
  final int rating;
  final String? comment;
  final int? punctuality;
  final int? quality;
  final int? professionalism;
  final List<String> images;
  final ReviewReplyModel? reply;
  final String? createdAt;

  const CustomerReviewModel({
    required this.id,
    this.booking,
    this.bookingReference,
    this.provider,
    this.service,
    this.authorDetail,
    this.rating = 0,
    this.comment,
    this.punctuality,
    this.quality,
    this.professionalism,
    this.images = const [],
    this.reply,
    this.createdAt,
  });

  factory CustomerReviewModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return CustomerReviewModel(
      id: data['id']?.toString() ?? '',
      booking: data['booking']?.toString(),
      bookingReference: data['booking_reference']?.toString(),
      provider: data['provider']?.toString(),
      service: data['service']?.toString(),
      authorDetail: data['author_detail'] is Map<String, dynamic>
          ? ReviewAuthorModel.fromJson(data['author_detail'] as Map<String, dynamic>)
          : null,
      rating: (data['rating'] as num?)?.toInt() ?? 0,
      comment: data['comment']?.toString(),
      punctuality: (data['punctuality'] as num?)?.toInt(),
      quality: (data['quality'] as num?)?.toInt(),
      professionalism: (data['professionalism'] as num?)?.toInt(),
      images: (data['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          const [],
      reply: data['reply'] is Map<String, dynamic>
          ? ReviewReplyModel.fromJson(data['reply'] as Map<String, dynamic>)
          : null,
      createdAt: data['created_at']?.toString(),
    );
  }

  static String _initialsOf(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  static String _formattedDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  /// Maps to [ReviewData] so the existing [ReviewCard] widget can render
  /// this without any design changes.
  ReviewData toReviewData() {
    final name = authorDetail?.fullName?.isNotEmpty == true
        ? authorDetail!.fullName!
        : 'Customer';
    return ReviewData(
      initials: _initialsOf(name),
      avatarColor: const Color(0xFF6366F1),
      name: name,
      rating: '$rating/5.0',
      date: _formattedDate(createdAt),
      comment: comment?.isNotEmpty == true ? comment! : 'No comment left.',
    );
  }
}

class CustomerReviewsResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<CustomerReviewModel> results;

  const CustomerReviewsResponseModel({
    required this.count,
    this.next,
    this.previous,
    this.results = const [],
  });

  factory CustomerReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = (json['results'] ?? json['data']) as List<dynamic>? ?? const [];
    return CustomerReviewsResponseModel(
      count: (json['count'] as num?)?.toInt() ?? rawList.length,
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
      results: rawList
          .map((e) => CustomerReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
