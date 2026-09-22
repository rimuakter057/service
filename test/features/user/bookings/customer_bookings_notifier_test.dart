import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nchito/features/user/bookings/data/models/booking_model.dart';
import 'package:nchito/features/user/bookings/data/models/customer_booking_detail_model.dart';
import 'package:nchito/features/user/bookings/domain/repositories/booking_repository.dart';
import 'package:nchito/features/user/bookings/presentation/providers/customer_bookings_notifier.dart';
import 'package:nchito/features/user/bookings/presentation/widgets/bookings_filter_bottom_sheet.dart';

class MockCustomerBookingRepository implements BookingRepository {
  final List<BookingResponseModel> allBookings;

  MockCustomerBookingRepository({
    required this.allBookings,
  });

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<BookingResponseModel> createBooking(CreateBookingRequestModel request) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getBookingForm(String providerId, {String? date}) {
    throw UnimplementedError();
  }

  @override
  Future<CustomerBookingDetailModel> getCustomerBookingDetail(String bookingId) {
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
  }) async {
    final curPage = page ?? 1;
    const size = 2;

    var filtered = List<BookingResponseModel>.from(allBookings);
    if (group != null && group != 'all') {
      filtered = filtered.where((b) => b.status.toLowerCase() == group.toLowerCase()).toList();
    }
    if (search != null && search.isNotEmpty) {
      filtered = filtered
          .where((b) =>
              (b.serviceTitle?.toLowerCase().contains(search.toLowerCase()) ?? false) ||
              (b.providerName?.toLowerCase().contains(search.toLowerCase()) ?? false))
          .toList();
    }

    final totalCount = filtered.length;
    final totalPages = (totalCount / size).ceil().clamp(1, 999);
    final startIndex = (curPage - 1) * size;
    final pageItems = startIndex < totalCount
        ? filtered.skip(startIndex).take(size).toList()
        : <BookingResponseModel>[];

    final hasNext = curPage < totalPages;

    return CustomerBookingsResponseModel(
      count: totalCount,
      currentPage: curPage,
      totalPages: totalPages,
      pageSize: size,
      next: hasNext ? "http://api.example.org/?page=${curPage + 1}" : null,
      previous: curPage > 1 ? "http://api.example.org/?page=${curPage - 1}" : null,
      results: pageItems,
    );
  }
}

void main() {
  group('CustomerBookingsNotifier', () {
    late MockCustomerBookingRepository mockRepo;
    late List<BookingResponseModel> testBookings;

    setUp(() {
      testBookings = [
        BookingResponseModel(
          id: '1',
          providerId: 'p1',
          providerName: 'Alex Cleaner',
          serviceTitle: 'House Cleaning',
          serviceType: 'srv1',
          serviceTypeName: 'Cleaning',
          customer: 'c1',
          customerName: 'Customer',
          scheduledDate: '2026-09-22',
          scheduledTime: '10:00:00',
          locationText: 'Lusaka',
          instructions: 'Clean carefully',
          serviceCost: '100.00',
          platformFee: '5.00',
          totalCost: '105.00',
          status: 'pending',
          statusDisplay: 'Pending',
          statusLabel: 'Pending',
          isQuoted: false,
          hasReview: false,
          createdAt: '2026-09-20T10:00:00Z',
          reference: 'NCH-001',
        ),
        BookingResponseModel(
          id: '2',
          providerId: 'p2',
          providerName: 'Green Gardens',
          serviceTitle: 'Garden Mowing',
          serviceType: 'srv2',
          serviceTypeName: 'Gardening',
          customer: 'c1',
          customerName: 'Customer',
          scheduledDate: '2026-09-23',
          scheduledTime: '11:00:00',
          locationText: 'Lusaka',
          instructions: 'Mow front lawn',
          serviceCost: '120.00',
          platformFee: '6.00',
          totalCost: '126.00',
          status: 'completed',
          statusDisplay: 'Completed',
          statusLabel: 'Completed',
          isQuoted: true,
          hasReview: true,
          createdAt: '2026-09-21T10:00:00Z',
          reference: 'NCH-002',
        ),
        BookingResponseModel(
          id: '3',
          providerId: 'p3',
          providerName: 'Banda Plumbing',
          serviceTitle: 'Pipe Repair',
          serviceType: 'srv3',
          serviceTypeName: 'Plumbing',
          customer: 'c1',
          customerName: 'Customer',
          scheduledDate: '2026-09-24',
          scheduledTime: '14:00:00',
          locationText: 'Lusaka',
          instructions: 'Fix kitchen sink',
          serviceCost: '150.00',
          platformFee: '8.00',
          totalCost: '158.00',
          status: 'pending',
          statusDisplay: 'Pending',
          statusLabel: 'Pending',
          isQuoted: false,
          hasReview: false,
          createdAt: '2026-09-21T11:00:00Z',
          reference: 'NCH-003',
        ),
      ];

      mockRepo = MockCustomerBookingRepository(
        allBookings: testBookings,
      );
    });

    test('initial state', () {
      final notifier = CustomerBookingsNotifier(repository: mockRepo);
      expect(notifier.isLoading, isFalse);
      expect(notifier.bookings, isEmpty);
      expect(notifier.selectedGroup, 'all');
      expect(notifier.hasActiveFilter, isFalse);
    });

    test('fetches bookings', () async {
      final notifier = CustomerBookingsNotifier(repository: mockRepo);
      await notifier.fetchBookings();

      expect(notifier.isLoading, isFalse);
      expect(notifier.bookings.length, 2);
      expect(notifier.currentPage, 1);
      expect(notifier.hasNextPage, isTrue);

      await notifier.loadMoreBookings();
      expect(notifier.bookings.length, 3);
      expect(notifier.currentPage, 2);
      expect(notifier.hasNextPage, isFalse);
    });

    test('applies filter and resets to page 1', () async {
      final notifier = CustomerBookingsNotifier(repository: mockRepo);
      await notifier.fetchBookings();
      expect(notifier.bookings.length, 2);

      await notifier.applyFilter('completed');
      expect(notifier.selectedGroup, 'completed');
      expect(notifier.bookings.length, 1);
      expect(notifier.bookings.first.status, 'completed');
      expect(notifier.hasActiveFilter, isTrue);
    });

    test('search filters bookings', () async {
      final notifier = CustomerBookingsNotifier(repository: mockRepo);
      await notifier.fetchBookings();

      notifier.onSearchChanged('Cleaning');
      await Future.delayed(const Duration(milliseconds: 400));

      expect(notifier.bookings.length, 1);
      expect(notifier.bookings.first.serviceTitle, 'House Cleaning');

      await notifier.clearSearch();
      expect(notifier.bookings.length, 2);
    });
  });

  group('BookingsFilterBottomSheet Widget Tests', () {
    testWidgets('renders all filter options and applies selected option value',
        (tester) async {
      String? appliedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookingsFilterBottomSheet(
              currentFilter: 'all',
              onApply: (val) {
                appliedValue = val;
              },
            ),
          ),
        ),
      );

      // Verify options are rendered with their labels
      expect(find.text('All Bookings'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Accepted'), findsOneWidget);
      expect(find.text('Scheduled'), findsOneWidget);
      expect(find.text('Cancelled'), findsOneWidget);
      expect(find.text('Rejected'), findsOneWidget);

      // Tap on 'Scheduled' option
      await tester.tap(find.text('Scheduled'));
      await tester.pumpAndSettle();

      // Tap on 'Apply Filter' button
      await tester.tap(find.text('Apply Filter'));
      await tester.pumpAndSettle();

      // Verify onApply received the exact 'scheduled' value from option
      expect(appliedValue, 'scheduled');
    });

    testWidgets('reset button resets selection to all', (tester) async {
      String? appliedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookingsFilterBottomSheet(
              currentFilter: 'scheduled',
              onApply: (val) {
                appliedValue = val;
              },
            ),
          ),
        ),
      );

      // Tap on Reset Filter
      await tester.tap(find.text('Reset Filter'));
      await tester.pumpAndSettle();

      // Tap on Apply Filter
      await tester.tap(find.text('Apply Filter'));
      await tester.pumpAndSettle();

      // Should be reset to 'all'
      expect(appliedValue, 'all');
    });
  });
}
