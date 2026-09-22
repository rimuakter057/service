import 'package:flutter_test/flutter_test.dart';
import 'package:nchito/core/errors/failures.dart';
import 'package:nchito/features/user/bookings/data/models/customer_dispute_model.dart';
import 'package:nchito/features/user/bookings/domain/repositories/dispute_repository.dart';
import 'package:nchito/features/user/bookings/presentation/providers/customer_dispute_notifier.dart';

class MockDisputeRepository implements DisputeRepository {
  CustomerDisputeModel? mockDispute;
  CustomerDisputesListResponseModel? mockList;
  Failure? mockFailure;

  @override
  Future<CustomerDisputeModel> createDispute({
    required String booking,
    required String reason,
    required String description,
    List<String>? evidenceFiles,
  }) async {
    if (mockFailure != null) throw mockFailure!;
    return mockDispute!;
  }

  @override
  Future<CustomerDisputesListResponseModel> getCustomerDisputes({int? page}) async {
    if (mockFailure != null) throw mockFailure!;
    return mockList ?? CustomerDisputesListResponseModel(
      count: mockDispute != null ? 1 : 0,
      results: mockDispute != null ? [mockDispute!] : [],
    );
  }

  @override
  Future<CustomerDisputeModel> getDisputeDetail(String disputeId) async {
    if (mockFailure != null) throw mockFailure!;
    return mockDispute!;
  }

  @override
  Future<CustomerDisputeModel> cancelDispute(
    String disputeId, {
    String? booking,
    String? reason,
    String? description,
  }) async {
    if (mockFailure != null) throw mockFailure!;
    return CustomerDisputeModel(id: disputeId, status: 'cancelled');
  }

  @override
  Future<CustomerDisputeModel> respondDispute(
    String disputeId, {
    String? booking,
    String? reason,
    String? description,
    String? message,
    List<String>? evidenceFiles,
  }) async {
    if (mockFailure != null) throw mockFailure!;
    return mockDispute!;
  }
}

void main() {
  group('CustomerDisputeModel & CustomerDisputeNotifier Tests', () {
    const rawDisputeJson = {
      "id": "disp-001",
      "reference": "DISP-123",
      "booking": "book-12345",
      "booking_reference": "REF-9988",
      "service_title": "Deep Clean",
      "raised_by": "cust-001",
      "raised_by_detail": {
        "id": "cust-001",
        "full_name": "John Doe",
        "avatar": "https://example.com/avatar.jpg",
        "role": "customer"
      },
      "reason": "Damaged property",
      "description": "The technician broke a vase during cleaning.",
      "status": "open",
      "status_message": "Our team is reviewing your dispute.",
      "awaiting_response": true,
      "response_requested_at": "2026-09-22T05:29:10.298Z",
      "response_due_at": "2026-09-22T05:29:10.298Z",
      "resolution": "full_refund",
      "resolution_note": "Refund has been approved.",
      "refund_amount": "3422",
      "resolved_at": "2026-09-22T05:29:10.298Z",
      "can_respond": true,
      "response_button_label": "Submit Response",
      "responses": [
        {
          "id": "resp-001",
          "message": "We have submitted our explanation",
          "author_detail": {
            "id": "cust-001",
            "full_name": "John Doe",
            "avatar": "https://example.com/avatar.jpg",
            "role": "customer"
          },
          "submitted_at": "2026-09-22T05:29:10.298Z",
          "evidence": [
            {
              "id": "ev-1",
              "file": "https://example.com/image1.jpg",
              "caption": "Vase broken",
              "created_at": "2026-09-22T05:29:10.298Z"
            }
          ]
        }
      ],
      "evidence": [
        {
          "id": "ev-1",
          "file": "https://example.com/image1.jpg",
          "caption": "Vase broken",
          "created_at": "2026-09-22T05:29:10.298Z"
        }
      ],
      "created_at": "2026-09-22T05:29:10.298Z"
    };

    test('parses CustomerDisputeModel from JSON correctly', () {
      final model = CustomerDisputeModel.fromJson(rawDisputeJson);

      expect(model.id, equals("disp-001"));
      expect(model.reference, equals("DISP-123"));
      expect(model.booking, equals("book-12345"));
      expect(model.reason, equals("Damaged property"));
      expect(model.description, equals("The technician broke a vase during cleaning."));
      expect(model.status, equals("open"));
      expect(model.evidence.length, equals(1));
      expect(model.evidence.first.file, equals("https://example.com/image1.jpg"));
      expect(model.responses.length, equals(1));
      expect(model.formattedSubmittedOn, isNotEmpty);
    });

    test('CustomerDisputeNotifier createDispute and fetchDisputes', () async {
      final mockRepo = MockDisputeRepository();
      mockRepo.mockDispute = CustomerDisputeModel.fromJson(rawDisputeJson);

      final notifier = CustomerDisputeNotifier(repository: mockRepo);

      expect(notifier.isLoading, isFalse);
      expect(notifier.disputes, isEmpty);

      final created = await notifier.createDispute(
        booking: "book-12345",
        reason: "Damaged property",
        description: "The technician broke a vase during cleaning.",
      );

      expect(created, isNotNull);
      expect(notifier.disputes.length, equals(1));
      expect(notifier.activeDispute?.id, equals("disp-001"));

      await notifier.fetchDisputes();
      expect(notifier.disputes.length, equals(1));
    });

    test('CustomerDisputeNotifier cancelDispute', () async {
      final mockRepo = MockDisputeRepository();
      mockRepo.mockDispute = CustomerDisputeModel.fromJson(rawDisputeJson);

      final notifier = CustomerDisputeNotifier(repository: mockRepo);

      final cancelSuccess = await notifier.cancelDispute("disp-001");
      expect(cancelSuccess, isTrue);
      expect(notifier.activeDispute?.status, equals("cancelled"));
    });

    test('CustomerDisputeNotifier handles failure', () async {
      final mockRepo = MockDisputeRepository();
      mockRepo.mockFailure = const ServerFailure('Failed to load dispute');

      final notifier = CustomerDisputeNotifier(repository: mockRepo);

      await notifier.fetchDisputeDetail("disp-001");
      expect(notifier.errorMessage, contains('Failed to load dispute'));
    });
  });
}
