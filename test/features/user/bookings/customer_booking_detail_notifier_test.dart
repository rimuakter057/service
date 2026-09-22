import 'package:flutter_test/flutter_test.dart';
import 'package:nchito/core/errors/failures.dart';
import 'package:nchito/features/user/bookings/data/models/booking_model.dart';
import 'package:nchito/features/user/bookings/data/models/customer_booking_detail_model.dart';
import 'package:nchito/features/user/bookings/domain/repositories/booking_repository.dart';
import 'package:nchito/features/user/bookings/domain/usecases/get_customer_booking_detail_usecase.dart';
import 'package:nchito/features/user/bookings/presentation/providers/customer_booking_detail_notifier.dart';

class MockBookingRepositoryForDetail implements BookingRepository {
  CustomerBookingDetailModel? mockDetail;
  Failure? mockFailure;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<CustomerBookingDetailModel> getCustomerBookingDetail(String bookingId) async {
    if (mockFailure != null) {
      throw mockFailure!;
    }
    return mockDetail!;
  }

  @override
  Future<CustomerBookingDetailModel> cancelBooking(String bookingId, {String? reason}) async {
    if (mockFailure != null) throw mockFailure!;
    return mockDetail!;
  }

  @override
  Future<CustomerBookingDetailModel> declineQuote(String bookingId, {required String reason}) async {
    if (mockFailure != null) throw mockFailure!;
    return mockDetail!;
  }

  @override
  Future<CustomerBookingDetailModel> resendCompletionCode(String bookingId) async {
    if (mockFailure != null) throw mockFailure!;
    return mockDetail!;
  }

  @override
  Future<BookingResponseModel> createBooking(CreateBookingRequestModel request) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getBookingForm(String providerId, {String? date}) {
    throw UnimplementedError();
  }

  @override
  Future<CustomerBookingsResponseModel> getCustomerBookings({
    String? group,
    String? status,
    String? date,
    String? dateFrom,
    String? dateTo,
    bool? today,
    String? search,
    String? ordering,
    int? page,
    int? pageSize,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  group('CustomerBookingDetailModel & Notifier Tests', () {
    const rawSampleJson = {
      "id": "book-12345",
      "reference": "REF-9988",
      "service_title": "Deep Clean",
      "service_type": "srv-type-1",
      "service_type_name": "Home Cleaning",
      "provider": "prov-001",
      "provider_name": "Amina Mwape",
      "provider_avatar": "https://example.com/amina.jpg",
      "customer": "cust-001",
      "customer_name": "John Doe",
      "scheduled_date": "2026-09-22",
      "scheduled_time": "04:46:37.436Z",
      "location_text": "Lusaka Woodlands",
      "service_cost": "27793166.",
      "platform_fee": "-513",
      "total_cost": "872193",
      "currency": "ZMW",
      "is_quoted": true,
      "status": "completed",
      "status_display": "Completed",
      "status_label": "Completed",
      "has_review": true,
      "created_at": "2026-09-22T04:46:37.436Z",
      "customer_detail": {
        "id": "cust-001",
        "full_name": "John Doe",
        "avatar": "https://example.com/john.jpg",
        "role": "customer"
      },
      "service": "srv-001",
      "duration_minutes": 120,
      "latitude": -15.4167,
      "longitude": 28.2833,
      "instructions": "Please be on time",
      "platform_fee_percent": "5",
      "accepted_at": "2026-09-22T04:46:37.436Z",
      "rejected_at": null,
      "rejection_reason": null,
      "started_at": "2026-09-22T04:46:37.436Z",
      "completed_at": "2026-09-22T04:46:37.436Z",
      "cancelled_at": null,
      "cancelled_by": null,
      "cancellation_reason": null,
      "status_events": [
        {
          "id": "event-1",
          "from_status": "in_progress",
          "to_status": "completed",
          "actor_name": "Amina",
          "note": "Work completed successfully",
          "created_at": "2026-09-22T04:46:37.436Z"
        }
      ],
      "attachments": [
        {
          "id": "att-1",
          "file": "https://example.com/receipt.pdf",
          "caption": "Job receipt",
          "created_at": "2026-09-22T04:46:37.436Z"
        }
      ],
      "dispute_status": "none",
      "is_cancellable": false,
      "is_disputable": true,
      "completion_code": "482731",
      "counterparty": {
        "id": "prov-001",
        "full_name": "Amina Mwape",
        "avatar": "https://example.com/amina.jpg",
        "role": "provider",
        "email": "amina@example.com",
        "contact_phone": "+260971234567"
      },
      "is_completion_verified": true,
      "review": "Great job",
      "available_actions": "review",
      "dispute": null,
      "cancellation": null,
      "reschedule_request": null,
      "change_policy": null,
      "quotes": [
        {
          "id": "quote-1",
          "sequence": 1,
          "amount": "800",
          "platform_fee_percent": "5",
          "platform_fee": "40",
          "total": "840",
          "currency": "ZMW",
          "status": "accepted",
          "status_display": "Accepted",
          "sent_by_name": "Amina Mwape",
          "note": "Standard service charge",
          "decline_reason": null,
          "responded_at": "2026-09-22T04:46:37.436Z",
          "created_at": "2026-09-22T04:46:37.436Z"
        }
      ],
      "current_quote": {
        "id": "quote-1",
        "sequence": 1,
        "amount": "800",
        "platform_fee_percent": "5",
        "platform_fee": "40",
        "total": "840",
        "currency": "ZMW",
        "status": "accepted",
        "status_display": "Accepted",
        "sent_by_name": "Amina Mwape",
        "note": "Standard service charge",
        "decline_reason": null,
        "responded_at": "2026-09-22T04:46:37.436Z",
        "created_at": "2026-09-22T04:46:37.436Z"
      },
      "pricing": "fixed",
      "payment_state": "paid",
      "quoted_at": "2026-09-22T04:46:37.436Z",
      "paid_at": "2026-09-22T04:46:37.436Z"
    };

    test('parses CustomerBookingDetailModel from JSON correctly', () {
      final model = CustomerBookingDetailModel.fromJson(rawSampleJson);

      expect(model.id, equals("book-12345"));
      expect(model.reference, equals("REF-9988"));
      expect(model.serviceTitle, equals("Deep Clean"));
      expect(model.providerName, equals("Amina Mwape"));
      expect(model.completionCode, equals("482731"));
      expect(model.formattedCompletionOtp, equals("4  8  2  7  3  1"));
      expect(model.counterparty?.email, equals("amina@example.com"));
      expect(model.quotes.length, equals(1));
      expect(model.quotes.first.sequence, equals(1));
      expect(model.statusEvents.length, equals(1));
      expect(model.attachments.length, equals(1));
    });

    test('toBookingHistoryData maps correctly to UI entity', () {
      final model = CustomerBookingDetailModel.fromJson(rawSampleJson);
      final historyData = model.toBookingHistoryData();

      expect(historyData.id, equals("book-12345"));
      expect(historyData.service, equals("Deep Clean"));
      expect(historyData.providerName, equals("Amina Mwape"));
      expect(historyData.location, equals("Lusaka Woodlands"));
      expect(historyData.price, contains("872193"));
    });

    test('CustomerBookingDetailNotifier fetches successfully', () async {
      final mockRepo = MockBookingRepositoryForDetail();
      mockRepo.mockDetail = CustomerBookingDetailModel.fromJson(rawSampleJson);

      final useCase = GetCustomerBookingDetailUseCase(mockRepo);
      final notifier = CustomerBookingDetailNotifier(getCustomerBookingDetailUseCase: useCase);

      expect(notifier.isLoading, isFalse);
      expect(notifier.bookingDetail, isNull);

      await notifier.fetchBookingDetail("book-12345");

      expect(notifier.isLoading, isFalse);
      expect(notifier.bookingDetail, isNotNull);
      expect(notifier.bookingDetail?.id, equals("book-12345"));
      expect(notifier.errorMessage, isNull);
    });

    test('CustomerBookingDetailNotifier handles failure', () async {
      final mockRepo = MockBookingRepositoryForDetail();
      mockRepo.mockFailure = const ServerFailure('Failed to load booking details');

      final useCase = GetCustomerBookingDetailUseCase(mockRepo);
      final notifier = CustomerBookingDetailNotifier(getCustomerBookingDetailUseCase: useCase);

      await notifier.fetchBookingDetail("invalid-id");

      expect(notifier.isLoading, isFalse);
      expect(notifier.bookingDetail, isNull);
      expect(notifier.errorMessage, contains('Failed to load booking details'));
    });

    test('CustomerBookingDetailNotifier actions: cancelBooking, declineQuote, resendCompletionCode', () async {
      final mockRepo = MockBookingRepositoryForDetail();
      mockRepo.mockDetail = CustomerBookingDetailModel.fromJson(rawSampleJson);

      final notifier = CustomerBookingDetailNotifier(repository: mockRepo);

      final cancelSuccess = await notifier.cancelBooking("book-12345");
      expect(cancelSuccess, isTrue);
      expect(notifier.isActionLoading, isFalse);
      expect(notifier.bookingDetail?.id, equals("book-12345"));

      final declineSuccess = await notifier.declineQuote("book-12345", reason: "Price too high");
      expect(declineSuccess, isTrue);
      expect(notifier.isActionLoading, isFalse);

      final resendSuccess = await notifier.resendCompletionCode("book-12345");
      expect(resendSuccess, isTrue);
      expect(notifier.isActionLoading, isFalse);
    });
  });
}
