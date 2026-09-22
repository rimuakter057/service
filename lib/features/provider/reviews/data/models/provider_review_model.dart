import 'package:nchito/features/provider/bookings/data/models/provider_booking_detail_model.dart';

class ReviewReplyModel {
  final String? message;
  final String? createdAt;

  const ReviewReplyModel({this.message, this.createdAt});

  factory ReviewReplyModel.fromJson(Map<String, dynamic> json) {
    return ReviewReplyModel(
      message: json['message']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

/// A review left on one of the provider's completed bookings — the shape
/// returned by `GET /provider/reviews/?provider=<id>` (confirmed live).
class ProviderReviewModel {
  final String id;
  final String? booking;
  final String? bookingReference;
  final String? provider;
  final String? service;
  final ProviderBookingPartyModel? authorDetail;
  final int rating;
  final String? comment;
  final int? punctuality;
  final int? quality;
  final int? professionalism;
  final List<String> images;
  final ReviewReplyModel? reply;
  final String? createdAt;

  const ProviderReviewModel({
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

  factory ProviderReviewModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return ProviderReviewModel(
      id: data['id']?.toString() ?? '',
      booking: data['booking']?.toString(),
      bookingReference: data['booking_reference']?.toString(),
      provider: data['provider']?.toString(),
      service: data['service']?.toString(),
      authorDetail: data['author_detail'] is Map<String, dynamic>
          ? ProviderBookingPartyModel.fromJson(
              data['author_detail'] as Map<String, dynamic>)
          : null,
      rating: (data['rating'] as num?)?.toInt() ?? 0,
      comment: data['comment']?.toString(),
      punctuality: (data['punctuality'] as num?)?.toInt(),
      quality: (data['quality'] as num?)?.toInt(),
      professionalism: (data['professionalism'] as num?)?.toInt(),
      images: (data['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      reply: data['reply'] is Map<String, dynamic>
          ? ReviewReplyModel.fromJson(data['reply'] as Map<String, dynamic>)
          : null,
      createdAt: data['created_at']?.toString(),
    );
  }
}

class ProviderReviewsResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<ProviderReviewModel> results;

  const ProviderReviewsResponseModel({
    required this.count,
    this.next,
    this.previous,
    this.results = const [],
  });

  factory ProviderReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList =
        (json['results'] ?? json['data']) as List<dynamic>? ?? const [];
    return ProviderReviewsResponseModel(
      count: (json['count'] as num?)?.toInt() ?? rawList.length,
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
      results: rawList
          .map((e) => ProviderReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// `GET /provider/reviews/breakdown/?provider=<id>` — star histogram +
/// average, confirmed live (`{average, total, histogram: {"1".."5"}}`).
class ProviderReviewBreakdownModel {
  final double average;
  final int total;
  final Map<int, int> histogram;

  const ProviderReviewBreakdownModel({
    this.average = 0,
    this.total = 0,
    this.histogram = const {},
  });

  factory ProviderReviewBreakdownModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;
    final rawHistogram = data['histogram'] as Map<String, dynamic>? ?? const {};
    return ProviderReviewBreakdownModel(
      average: (data['average'] as num?)?.toDouble() ?? 0,
      total: (data['total'] as num?)?.toInt() ?? 0,
      histogram: rawHistogram.map(
        (star, count) =>
            MapEntry(int.tryParse(star) ?? 0, (count as num?)?.toInt() ?? 0),
      ),
    );
  }

  /// Count for a given star (1-5), defaulting to 0.
  int countFor(int star) => histogram[star] ?? 0;
}
