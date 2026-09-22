import 'provider_booking_detail_model.dart';

class ProviderDisputeEvidenceModel {
  final String id;
  final String file;
  final String? caption;
  final String? createdAt;

  const ProviderDisputeEvidenceModel({
    required this.id,
    required this.file,
    this.caption,
    this.createdAt,
  });

  factory ProviderDisputeEvidenceModel.fromJson(Map<String, dynamic> json) {
    return ProviderDisputeEvidenceModel(
      id: json['id']?.toString() ?? '',
      file: json['file']?.toString() ?? '',
      caption: json['caption']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class ProviderDisputeResponseItemModel {
  final String id;
  final String? message;
  final ProviderBookingPartyModel? authorDetail;
  final String? submittedAt;
  final List<ProviderDisputeEvidenceModel> evidence;

  const ProviderDisputeResponseItemModel({
    required this.id,
    this.message,
    this.authorDetail,
    this.submittedAt,
    this.evidence = const [],
  });

  factory ProviderDisputeResponseItemModel.fromJson(Map<String, dynamic> json) {
    return ProviderDisputeResponseItemModel(
      id: json['id']?.toString() ?? '',
      message: json['message']?.toString(),
      authorDetail: json['author_detail'] is Map<String, dynamic>
          ? ProviderBookingPartyModel.fromJson(
              json['author_detail'] as Map<String, dynamic>)
          : null,
      submittedAt: json['submitted_at']?.toString(),
      evidence: (json['evidence'] as List<dynamic>?)
              ?.map((e) => ProviderDisputeEvidenceModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class ProviderDisputeModel {
  final String id;
  final String? reference;
  final String? booking;
  final String? bookingReference;
  final String? serviceTitle;
  final String? raisedBy;
  final ProviderBookingPartyModel? raisedByDetail;
  final String? reason;
  final String? description;
  final String status;
  final String? statusMessage;
  final bool awaitingResponse;
  final String? responseRequestedAt;
  final String? responseDueAt;
  final String? resolution;
  final String? resolutionNote;
  final String? refundAmount;
  final String? resolvedAt;
  final bool canRespond;
  final String? responseButtonLabel;
  final List<ProviderDisputeResponseItemModel> responses;
  final List<ProviderDisputeEvidenceModel> evidence;
  final String? createdAt;
  final Map<String, dynamic>? rawJson;

  const ProviderDisputeModel({
    required this.id,
    this.reference,
    this.booking,
    this.bookingReference,
    this.serviceTitle,
    this.raisedBy,
    this.raisedByDetail,
    this.reason,
    this.description,
    this.status = 'open',
    this.statusMessage,
    this.awaitingResponse = false,
    this.responseRequestedAt,
    this.responseDueAt,
    this.resolution,
    this.resolutionNote,
    this.refundAmount,
    this.resolvedAt,
    this.canRespond = false,
    this.responseButtonLabel,
    this.responses = const [],
    this.evidence = const [],
    this.createdAt,
    this.rawJson,
  });

  factory ProviderDisputeModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return ProviderDisputeModel(
      id: data['id']?.toString() ?? '',
      reference: data['reference']?.toString(),
      booking: data['booking']?.toString(),
      bookingReference: data['booking_reference']?.toString(),
      serviceTitle: data['service_title']?.toString(),
      raisedBy: data['raised_by']?.toString(),
      raisedByDetail: data['raised_by_detail'] is Map<String, dynamic>
          ? ProviderBookingPartyModel.fromJson(
              data['raised_by_detail'] as Map<String, dynamic>)
          : null,
      reason: data['reason']?.toString(),
      description: data['description']?.toString(),
      status: data['status']?.toString() ?? 'open',
      statusMessage: data['status_message']?.toString(),
      awaitingResponse: data['awaiting_response'] as bool? ?? false,
      responseRequestedAt: data['response_requested_at']?.toString(),
      responseDueAt: data['response_due_at']?.toString(),
      resolution: data['resolution']?.toString(),
      resolutionNote: data['resolution_note']?.toString(),
      refundAmount: data['refund_amount']?.toString(),
      resolvedAt: data['resolved_at']?.toString(),
      canRespond: data['can_respond'] as bool? ?? false,
      responseButtonLabel: data['response_button_label']?.toString(),
      responses: (data['responses'] as List<dynamic>?)
              ?.map((e) => ProviderDisputeResponseItemModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      evidence: (data['evidence'] as List<dynamic>?)
              ?.map((e) => ProviderDisputeEvidenceModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: data['created_at']?.toString(),
      rawJson: json,
    );
  }

  String get formattedSubmittedOn {
    if (createdAt == null || createdAt!.isEmpty) {
      return '27 Aug 2026 - 06:20 AM';
    }
    try {
      final dt = DateTime.parse(createdAt!).toLocal();
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final day = dt.day.toString().padLeft(2, '0');
      final month = months[dt.month - 1];
      final year = dt.year.toString();
      final hour12 = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$day $month $year - ${hour12.toString().padLeft(2, '0')}:$minute $period';
    } catch (_) {
      return createdAt!;
    }
  }
}

class ProviderDisputesListResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<ProviderDisputeModel> results;

  const ProviderDisputesListResponseModel({
    required this.count,
    this.next,
    this.previous,
    this.results = const [],
  });

  factory ProviderDisputesListResponseModel.fromJson(Map<String, dynamic> json) {
    // The list endpoint wraps its items in `data`, not `results` (unlike
    // the paginated booking endpoints) — confirmed against the live API.
    final rawList =
        (json['results'] ?? json['data']) as List<dynamic>? ?? const [];
    return ProviderDisputesListResponseModel(
      count: (json['count'] as num?)?.toInt() ?? rawList.length,
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
      results: rawList
          .map((e) => ProviderDisputeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
