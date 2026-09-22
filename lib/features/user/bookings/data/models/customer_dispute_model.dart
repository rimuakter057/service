import 'customer_booking_detail_model.dart';

class DisputeEvidenceModel {
  final String id;
  final String file;
  final String? caption;
  final String? createdAt;

  const DisputeEvidenceModel({
    required this.id,
    required this.file,
    this.caption,
    this.createdAt,
  });

  factory DisputeEvidenceModel.fromJson(Map<String, dynamic> json) {
    return DisputeEvidenceModel(
      id: json['id']?.toString() ?? '',
      file: json['file']?.toString() ?? '',
      caption: json['caption']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'file': file,
        'caption': caption,
        'created_at': createdAt,
      };
}

class DisputeResponseItemModel {
  final String id;
  final String? message;
  final BookingCustomerDetailModel? authorDetail;
  final String? submittedAt;
  final List<DisputeEvidenceModel> evidence;

  const DisputeResponseItemModel({
    required this.id,
    this.message,
    this.authorDetail,
    this.submittedAt,
    this.evidence = const [],
  });

  factory DisputeResponseItemModel.fromJson(Map<String, dynamic> json) {
    return DisputeResponseItemModel(
      id: json['id']?.toString() ?? '',
      message: json['message']?.toString(),
      authorDetail: json['author_detail'] is Map<String, dynamic>
          ? BookingCustomerDetailModel.fromJson(
              json['author_detail'] as Map<String, dynamic>)
          : null,
      submittedAt: json['submitted_at']?.toString(),
      evidence: (json['evidence'] as List<dynamic>?)
              ?.map((e) =>
                  DisputeEvidenceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class CustomerDisputeModel {
  final String id;
  final String? reference;
  final String? booking;
  final String? bookingReference;
  final String? serviceTitle;
  final String? raisedBy;
  final BookingCustomerDetailModel? raisedByDetail;
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
  final List<DisputeResponseItemModel> responses;
  final List<DisputeEvidenceModel> evidence;
  final String? createdAt;
  final Map<String, dynamic>? rawJson;

  const CustomerDisputeModel({
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

  factory CustomerDisputeModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return CustomerDisputeModel(
      id: data['id']?.toString() ?? '',
      reference: data['reference']?.toString(),
      booking: data['booking']?.toString(),
      bookingReference: data['booking_reference']?.toString(),
      serviceTitle: data['service_title']?.toString(),
      raisedBy: data['raised_by']?.toString(),
      raisedByDetail: data['raised_by_detail'] is Map<String, dynamic>
          ? BookingCustomerDetailModel.fromJson(
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
              ?.map((e) => DisputeResponseItemModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      evidence: (data['evidence'] as List<dynamic>?)
              ?.map((e) =>
                  DisputeEvidenceModel.fromJson(e as Map<String, dynamic>))
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

class CustomerDisputesListResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<CustomerDisputeModel> results;

  const CustomerDisputesListResponseModel({
    required this.count,
    this.next,
    this.previous,
    this.results = const [],
  });

  factory CustomerDisputesListResponseModel.fromJson(
      Map<String, dynamic> json) {
    // The list endpoint wraps its items in `data`, not `results` (unlike
    // the paginated booking endpoints) — confirmed against the live API.
    final rawList =
        (json['results'] ?? json['data']) as List<dynamic>? ?? const [];
    return CustomerDisputesListResponseModel(
      count: (json['count'] as num?)?.toInt() ?? rawList.length,
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
      results: rawList
          .map((e) =>
              CustomerDisputeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
