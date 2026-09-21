import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/explore/presentation/widgets/explore_sample_data.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

class ServiceTypeChipModel {
  final String id;
  final String name;
  final String slug;
  final String? icon;

  const ServiceTypeChipModel({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
  });

  factory ServiceTypeChipModel.fromJson(Map<String, dynamic> json) {
    return ServiceTypeChipModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      icon: json['icon'] as String?,
    );
  }
}

class ExploreProviderItemModel {
  final String id;
  final String fullName;
  final String businessName;
  final String? avatar;
  final String headline;
  final List<String> serviceTypes;
  final List<String> serviceTypeNames;
  final List<ServiceTypeChipModel> serviceTypeChips;
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

  const ExploreProviderItemModel({
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
  });

  factory ExploreProviderItemModel.fromJson(Map<String, dynamic> json) {
    double parseRating(dynamic val) {
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic val) {
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    return ExploreProviderItemModel(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      businessName: json['business_name'] as String? ?? '',
      avatar: json['avatar'] as String?,
      headline: json['headline'] as String? ?? '',
      serviceTypes: (json['service_types'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      serviceTypeNames: (json['service_type_names'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      serviceTypeChips: (json['service_type_chips'] as List<dynamic>?)
              ?.map((e) =>
                  ServiceTypeChipModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      serviceArea: json['service_area'] as String? ?? '',
      city: json['city'] as String? ?? '',
      startingPrice: json['starting_price']?.toString() ?? '0.00',
      currency: json['currency'] as String? ?? 'ZMW',
      ratingAverage: parseRating(json['rating_average']),
      ratingCount: parseInt(json['rating_count']),
      totalJobsCompleted: parseInt(json['total_jobs_completed']),
      isVerified: json['is_verified'] as bool? ?? false,
      isAcceptingBookings: json['is_accepting_bookings'] as bool? ?? true,
      isFavorited: json['is_favorited'] as bool? ?? false,
    );
  }

  /// Resolve service category badge based on slug / name
  ExploreProviderBadge get badge {
    final slug = serviceTypeChips.isNotEmpty
        ? serviceTypeChips.first.slug.toLowerCase()
        : (serviceTypeNames.isNotEmpty ? serviceTypeNames.first.toLowerCase() : '');

    if (slug.contains('gardening') || slug.contains('landscaping')) {
      return const ExploreProviderBadge(
        iconAsset: AssetsPath.categoryGardening,
        bgColor: AppColors.brandSoft,
        iconColor: AppColors.brandPrimary,
      );
    } else if (slug.contains('moving') || slug.contains('relocation')) {
      return const ExploreProviderBadge(
        iconAsset: AssetsPath.categoryMoving,
        bgColor: AppColors.teal50,
        iconColor: AppColors.cyan400,
      );
    } else if (slug.contains('electrical')) {
      return const ExploreProviderBadge(
        iconAsset: AssetsPath.categoryElectrical,
        bgColor: AppColors.orange50,
        iconColor: AppColors.orange400,
      );
    } else if (slug.contains('cleaning')) {
      return const ExploreProviderBadge(
        iconAsset: AssetsPath.categoryCleaning,
        bgColor: AppColors.brandSoft,
        iconColor: AppColors.brandPrimary,
      );
    } else if (slug.contains('plumbing')) {
      return const ExploreProviderBadge(
        iconAsset: AssetsPath.categoryPlumbing,
        bgColor: AppColors.teal50,
        iconColor: AppColors.cyan400,
      );
    } else if (slug.contains('painting') || slug.contains('decorating')) {
      return const ExploreProviderBadge(
        iconAsset: AssetsPath.categoryPainting,
        bgColor: AppColors.orange50,
        iconColor: AppColors.orange400,
      );
    }

    return const ExploreProviderBadge(
      iconAsset: AssetsPath.categoryElectrical,
      bgColor: AppColors.orange50,
      iconColor: AppColors.orange400,
    );
  }

  /// Returns a photo path (network URL if provided, otherwise asset fallback)
  String get photoPath {
    if (avatar != null && avatar!.trim().isNotEmpty) {
      return avatar!.trim();
    }
    // Deterministic fallback based on id or name
    final hash = (fullName.isNotEmpty ? fullName : id).hashCode.abs();
    final fallbacks = [
      AssetsPath.providerRobert,
      AssetsPath.providerAlex,
      AssetsPath.exploreProviderPhotoJhoneDoe,
    ];
    return fallbacks[hash % fallbacks.length];
  }

  /// Formatted display price e.g. "ZMW 100" or "ZMW 120"
  String get displayPrice {
    final parsed = double.tryParse(startingPrice);
    if (parsed != null) {
      if (parsed == parsed.roundToDouble()) {
        return '$currency ${parsed.toInt()}';
      }
      return '$currency ${parsed.toStringAsFixed(2)}';
    }
    return '$currency $startingPrice';
  }

  /// Primary service display name
  String get primaryServiceName {
    if (serviceTypeNames.isNotEmpty && serviceTypeNames.first.isNotEmpty) {
      return serviceTypeNames.first;
    }
    if (serviceTypeChips.isNotEmpty && serviceTypeChips.first.name.isNotEmpty) {
      return serviceTypeChips.first.name;
    }
    return AppText.categoryCleaning;
  }

  /// Formatted rating e.g. "4.8" or "5.0"
  String get displayRating {
    return ratingAverage.toStringAsFixed(1);
  }

  /// Converts this API item to [ExploreProviderEntry] for Explore Provider grid
  ExploreProviderEntry toExploreEntry() {
    return ExploreProviderEntry(
      provider: toHomeProviderData(),
      badge: badge,
    );
  }

  /// Converts to [HomeProviderData] for navigation to [ProviderDetailsScreen]
  /// Uses static mock data for fields not yet available on server as instructed.
  HomeProviderData toHomeProviderData() {
    final cleanName = fullName.isNotEmpty ? fullName : businessName;
    final mockEmail = '${cleanName.toLowerCase().replaceAll(RegExp(r'\s+'), '.')}@gmail.com';
    final service = primaryServiceName;

    return HomeProviderData(
      id: id,
      photo: photoPath,
      name: cleanName.isNotEmpty ? cleanName : 'Service Provider',
      service: service,
      price: displayPrice,
      rating: displayRating,
      email: mockEmail,
      phone: '+260 97 555 1234',
      area: serviceArea.isNotEmpty ? '$serviceArea, Zambia' : 'Lusaka, Zambia',
      description: headline.isNotEmpty
          ? headline
          : 'Experienced and certified specialist offering top-quality $service services across Lusaka.',
      reviewCount: ratingCount.toString(),
      totalJobsCompleted: totalJobsCompleted.toString(),
      tags: [
        ProviderTag(
          iconAsset: badge.iconAsset,
          label: service,
        ),
      ],
    );
  }
}

class ExploreProvidersResponseModel {
  final bool success;
  final int count;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final String? next;
  final String? previous;
  final String title;
  final String emptyMessage;
  final List<ExploreProviderItemModel> data;

  const ExploreProvidersResponseModel({
    required this.success,
    required this.count,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    this.next,
    this.previous,
    required this.title,
    required this.emptyMessage,
    required this.data,
  });

  factory ExploreProvidersResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = (json['results'] ?? json['data']) as List<dynamic>? ?? [];
    final count = json['count'] as int? ?? rawList.length;
    final pageSize = json['page_size'] as int? ?? 20;
    final totalPages = json['total_pages'] as int? ??
        (count > 0 ? (count / pageSize).ceil() : 1);
    final currentPage = json['current_page'] as int? ?? 1;

    return ExploreProvidersResponseModel(
      success: json['success'] as bool? ?? true,
      count: count,
      totalPages: totalPages,
      currentPage: currentPage,
      pageSize: pageSize,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      title: json['title'] as String? ?? 'Explore Provider',
      emptyMessage: json['empty_message'] as String? ?? "We Couldn't Find Any Matches.",
      data: rawList
          .map((e) =>
              ExploreProviderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
