import 'package:flutter_test/flutter_test.dart';
import 'package:nchito/features/user/bookings/data/models/booking_model.dart';
import 'package:nchito/features/user/bookings/data/models/customer_booking_detail_model.dart';
import 'package:nchito/features/user/bookings/domain/repositories/booking_repository.dart';
import 'package:nchito/features/user/explore/data/models/explore_provider_model.dart';
import 'package:nchito/features/user/explore/domain/repositories/explore_repository.dart';
import 'package:nchito/features/user/home/presentation/providers/near_providers_notifier.dart';
import 'package:nchito/features/user/home/presentation/providers/ongoing_bookings_notifier.dart';

class MockExploreRepository implements ExploreRepository {
  @override
  Future<ExploreProvidersResponseModel> getProviders({
    String? search,
    String? category,
    String? city,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sort,
    String? date,
    double? lat,
    double? lng,
    int? page,
    int? pageSize,
  }) async {
    final currentPage = page ?? 1;
    return ExploreProvidersResponseModel(
      success: true,
      count: 2,
      totalPages: 2,
      currentPage: currentPage,
      pageSize: 1,
      next: currentPage == 1 ? "http://api.example.org/?page=2" : null,
      previous: currentPage > 1 ? "http://api.example.org/?page=1" : null,
      title: "Explore",
      emptyMessage: "None",
      data: [
        ExploreProviderItemModel(
          id: "prov_$currentPage",
          fullName: "Provider $currentPage",
          businessName: "Biz $currentPage",
          avatar: null,
          headline: "Headline $currentPage",
          serviceTypes: ["srv_1"],
          serviceTypeNames: ["Cleaning"],
          serviceTypeChips: const [],
          serviceArea: "Lusaka",
          city: "Lusaka",
          startingPrice: "100",
          currency: "ZMW",
          ratingAverage: 5.0,
          ratingCount: 10,
          totalJobsCompleted: 20,
          isVerified: true,
          isAcceptingBookings: true,
          isFavorited: false,
        ),
      ],
    );
  }

  @override
  Future<ExploreFiltersResponseModel> getFilters() async =>
      const ExploreFiltersResponseModel(
        success: true,
        categories: [],
        cities: [],
        minPrice: 0,
        maxPrice: 500,
        sortOptions: [],
        ratingOptions: [],
      );

  @override
  Future<FavoriteProvidersResponseModel> getFavorites({
    int? page,
    int? pageSize,
  }) async =>
      const FavoriteProvidersResponseModel(
        success: true,
        count: 0,
        data: [],
      );

  @override
  Future<bool> addFavorite(String providerId) async => true;

  @override
  Future<bool> removeFavorite(String providerId) async => true;
}

class MockBookingRepository implements BookingRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<BookingResponseModel> createBooking(CreateBookingRequestModel request) {
    throw UnimplementedError();
  }


  @override
  Future<CustomerBookingDetailModel> getCustomerBookingDetail(String bookingId) {
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
  }) async {
    final currentPage = page ?? 1;
    return CustomerBookingsResponseModel(
      count: 2,
      currentPage: currentPage,
      totalPages: 2,
      pageSize: 1,
      next: currentPage == 1 ? "http://api.example.org/?page=2" : null,
      results: [
        BookingResponseModel(
          id: "booking_$currentPage",
          providerId: "prov_$currentPage",
          providerName: "Provider $currentPage",
          serviceTitle: "Service $currentPage",
          serviceType: "srv_type",
          serviceTypeName: "Cleaning",
          scheduledDate: "2026-09-21",
          scheduledTime: "10:00:00",
          locationText: "Lusaka",
          instructions: "Test booking",
          status: "in_progress",
          statusDisplay: "In Progress",
          statusLabel: "In Progress",
          totalCost: "200",
          currency: "ZMW",
        ),
      ],
    );
  }
}

void main() {
  group('NearProvidersNotifier tests', () {
    test('fetches page 1 and loads more page 2 correctly', () async {
      final notifier = NearProvidersNotifier(repository: MockExploreRepository());

      expect(notifier.providers, isEmpty);
      expect(notifier.isLoading, isFalse);

      await notifier.fetchNearProviders();

      expect(notifier.providers.length, 1);
      expect(notifier.providers.first.id, "prov_1");
      expect(notifier.hasNextPage, isTrue);

      await notifier.loadMore();

      expect(notifier.providers.length, 2);
      expect(notifier.providers[1].id, "prov_2");
      expect(notifier.hasNextPage, isFalse);
    });
  });

  group('OngoingBookingsNotifier tests', () {
    test('fetches page 1 ongoing bookings and loads more page 2', () async {
      final notifier = OngoingBookingsNotifier(repository: MockBookingRepository());

      expect(notifier.rawBookings, isEmpty);
      expect(notifier.isLoading, isFalse);

      await notifier.fetchOngoingBookings();

      expect(notifier.rawBookings.length, 1);
      expect(notifier.homeBookings.length, 1);
      expect(notifier.homeBookings.first.providerName, "Provider 1");
      expect(notifier.homeBookings.first.price, "ZMW 200");
      expect(notifier.hasNextPage, isTrue);

      await notifier.loadMore();

      expect(notifier.rawBookings.length, 2);
      expect(notifier.homeBookings.length, 2);
      expect(notifier.homeBookings[1].providerName, "Provider 2");
      expect(notifier.hasNextPage, isFalse);
    });
  });
}
