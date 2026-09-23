import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

class AvailabilityScheduleItem {
  final String id;
  final int weekday;
  final String weekdayName;
  final bool isAvailable;
  final String? startTime;
  final String? endTime;

  const AvailabilityScheduleItem({
    required this.id,
    required this.weekday,
    required this.weekdayName,
    required this.isAvailable,
    this.startTime,
    this.endTime,
  });

  factory AvailabilityScheduleItem.fromJson(Map<String, dynamic> json) {
    return AvailabilityScheduleItem(
      id: json['id']?.toString() ?? '',
      weekday: (json['weekday'] is num) ? (json['weekday'] as num).toInt() : 0,
      weekdayName: json['weekday_name']?.toString() ?? '',
      isAvailable: json['is_available'] as bool? ?? false,
      startTime: json['start_time']?.toString(),
      endTime: json['end_time']?.toString(),
    );
  }
}

class ProviderDetailModel {
  final String id;
  final String fullName;
  final String businessName;
  final String? avatar;
  final String headline;
  final List<String> serviceTypes;
  final List<String> serviceTypeNames;
  final List<Map<String, dynamic>> serviceTypeChips;
  final String serviceArea;
  final String city;
  final String startingPrice;
  final String currency;
  final double ratingAverage;
  final int ratingCount;
  final int totalJobsCompleted;
  final bool isVerified;
  final bool isAcceptingBookings;
  final bool isFavorited;
  final String? email;
  final String? contactPhone;
  final String serviceDescription;
  final int? yearsOfExperience;
  final int? maxTravelKm;
  final double? latitude;
  final double? longitude;
  final String status;
  final String verificationStatus;
  final List<dynamic> portfolio;
  final List<AvailabilityScheduleItem> availability;
  final String? createdAt;

  const ProviderDetailModel({
    required this.id,
    required this.fullName,
    required this.businessName,
    this.avatar,
    required this.headline,
    required this.serviceTypes,
    required this.serviceTypeNames,
    required this.serviceTypeChips,
    required this.serviceArea,
    required this.city,
    required this.startingPrice,
    required this.currency,
    required this.ratingAverage,
    required this.ratingCount,
    required this.totalJobsCompleted,
    required this.isVerified,
    required this.isAcceptingBookings,
    required this.isFavorited,
    this.email,
    this.contactPhone,
    required this.serviceDescription,
    this.yearsOfExperience,
    this.maxTravelKm,
    this.latitude,
    this.longitude,
    required this.status,
    required this.verificationStatus,
    required this.portfolio,
    required this.availability,
    this.createdAt,
  });

  factory ProviderDetailModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic val) {
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    final rawServiceTypes = json['service_types'] as List<dynamic>?;
    final rawServiceTypeNames = json['service_type_names'] as List<dynamic>?;
    final rawServiceTypeChips = json['service_type_chips'] as List<dynamic>?;
    final rawAvailability = json['availability'] as List<dynamic>?;
    final rawPortfolio = json['portfolio'] as List<dynamic>?;

    return ProviderDetailModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      businessName: json['business_name']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? (json['user_detail'] is Map ? json['user_detail']['avatar']?.toString() : null),
      headline: json['headline']?.toString() ?? '',
      serviceTypes: rawServiceTypes?.map((e) => e.toString()).toList() ?? [],
      serviceTypeNames: rawServiceTypeNames?.map((e) => e.toString()).toList() ?? [],
      serviceTypeChips: rawServiceTypeChips?.whereType<Map<String, dynamic>>().toList() ?? [],
      serviceArea: json['service_area']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      startingPrice: json['starting_price']?.toString() ?? '0.00',
      currency: json['currency']?.toString() ?? 'ZMW',
      ratingAverage: parseDouble(json['rating_average']),
      ratingCount: parseInt(json['rating_count']),
      totalJobsCompleted: parseInt(json['total_jobs_completed']),
      isVerified: json['is_verified'] as bool? ?? (json['verification_status'] == 'approved'),
      isAcceptingBookings: json['is_accepting_bookings'] as bool? ?? true,
      isFavorited: json['is_favorited'] as bool? ?? false,
      email: json['email']?.toString(),
      contactPhone: json['contact_phone']?.toString() ?? json['contact']?.toString(),
      serviceDescription: json['service_description']?.toString() ?? json['headline']?.toString() ?? '',
      yearsOfExperience: json['years_of_experience'] != null ? parseInt(json['years_of_experience']) : null,
      maxTravelKm: json['max_travel_km'] != null ? parseInt(json['max_travel_km']) : null,
      latitude: json['latitude'] != null ? parseDouble(json['latitude']) : null,
      longitude: json['longitude'] != null ? parseDouble(json['longitude']) : null,
      status: json['status']?.toString() ?? 'approved',
      verificationStatus: json['verification_status']?.toString() ?? 'approved',
      portfolio: rawPortfolio ?? [],
      availability: rawAvailability
              ?.whereType<Map<String, dynamic>>()
              .map((e) => AvailabilityScheduleItem.fromJson(e))
              .toList() ??
          [],
      createdAt: json['created_at']?.toString(),
    );
  }

  /// Resolve category icon from slug/name
  String _resolveCategoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('gardening') || lower.contains('landscaping')) {
      return AssetsPath.categoryGardening;
    } else if (lower.contains('moving') || lower.contains('relocation')) {
      return AssetsPath.exploreProviderDetailsTagIconMoving1;
    } else if (lower.contains('electrical')) {
      return AssetsPath.exploreProviderDetailsTagIconElectrical;
    } else if (lower.contains('cleaning')) {
      return AssetsPath.categoryCleaning;
    } else if (lower.contains('plumbing')) {
      return AssetsPath.categoryPlumbing;
    } else if (lower.contains('painting') || lower.contains('decorating')) {
      return AssetsPath.exploreProviderDetailsTagIconPainting;
    }
    return AssetsPath.exploreProviderDetailsTagIconElectrical;
  }

  /// Converts this model to [HomeProviderData] checking all null fields and providing safe defaults
  HomeProviderData toHomeProviderData({HomeProviderData? fallback}) {
    final cleanName = fullName.isNotEmpty ? fullName : (businessName.isNotEmpty ? businessName : (fallback?.name ?? 'Service Provider'));

    // Safe default email if null
    final resolvedEmail = (email != null && email!.trim().isNotEmpty)
        ? email!.trim()
        : (fallback?.email.isNotEmpty == true
            ? fallback!.email
            : '${cleanName.toLowerCase().replaceAll(RegExp(r'\s+'), '.')}@gmail.com');

    // Safe default contact phone if null
    final resolvedPhone = (contactPhone != null && contactPhone!.trim().isNotEmpty)
        ? contactPhone!.trim()
        : (fallback?.phone.isNotEmpty == true
            ? fallback!.phone
            : '+260 97 555 1234');

    // Safe default service area if empty
    final resolvedArea = serviceArea.isNotEmpty
        ? (city.isNotEmpty && !serviceArea.contains(city) ? '$serviceArea, $city, Zambia' : '$serviceArea, Zambia')
        : (fallback?.area.isNotEmpty == true ? fallback!.area : 'Lusaka, Zambia');

    // Safe default description if empty
    final resolvedDescription = serviceDescription.isNotEmpty
        ? serviceDescription
        : (headline.isNotEmpty
            ? headline
            : (fallback?.description.isNotEmpty == true
                ? fallback!.description
                : 'Experienced and certified professional specialist offering high-quality services.'));

    // Primary service
    final primaryService = serviceTypeNames.isNotEmpty
        ? serviceTypeNames.first
        : (fallback?.service.isNotEmpty == true ? fallback!.service : 'Professional Service');

    final firstTypeId = serviceTypes.isNotEmpty
        ? serviceTypes.first
        : (serviceTypeChips.isNotEmpty
            ? serviceTypeChips.first['id']?.toString()
            : fallback?.serviceTypeId);

    // Tags list
    final List<ProviderTag> resolvedTags = [];
    if (serviceTypeChips.isNotEmpty) {
      for (final chip in serviceTypeChips) {
        final name = chip['name']?.toString() ?? '';
        final id = chip['id']?.toString();
        if (name.isNotEmpty) {
          resolvedTags.add(
            ProviderTag(
              iconAsset: _resolveCategoryIcon(name),
              label: name,
              id: id,
            ),
          );
        }
      }
    } else if (serviceTypeNames.isNotEmpty) {
      for (int i = 0; i < serviceTypeNames.length; i++) {
        final name = serviceTypeNames[i];
        final id = i < serviceTypes.length ? serviceTypes[i] : null;
        resolvedTags.add(
          ProviderTag(
            iconAsset: _resolveCategoryIcon(name),
            label: name,
            id: id,
          ),
        );
      }
    } else if (fallback != null && fallback.tags.isNotEmpty) {
      resolvedTags.addAll(fallback.tags);
    } else {
      resolvedTags.add(
        ProviderTag(
          iconAsset: _resolveCategoryIcon(primaryService),
          label: primaryService,
          id: firstTypeId,
        ),
      );
    }

    // Photo URL or fallback asset
    final resolvedPhoto = (avatar != null && avatar!.trim().isNotEmpty)
        ? avatar!.trim()
        : (fallback?.photo.isNotEmpty == true ? fallback!.photo : AssetsPath.providerRobert);

    return HomeProviderData(
      id: id,
      photo: resolvedPhoto,
      name: cleanName,
      service: primaryService,
      serviceTypeId: firstTypeId,
      price: startingPrice.isNotEmpty ? '$currency $startingPrice' : (fallback?.price ?? 'ZMW 100'),
      rating: ratingAverage > 0 ? ratingAverage.toStringAsFixed(1) : (fallback?.rating ?? '5.0'),
      email: resolvedEmail,
      phone: resolvedPhone,
      area: resolvedArea,
      description: resolvedDescription,
      reviewCount: ratingCount > 0 ? ratingCount.toString() : (fallback?.reviewCount ?? '1'),
      totalJobsCompleted: totalJobsCompleted > 0 ? totalJobsCompleted.toString() : (fallback?.totalJobsCompleted ?? '1'),
      tags: resolvedTags,
    );
  }
}
