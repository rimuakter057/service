import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/explore/data/models/explore_provider_model.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

class CatalogServiceModel {
  final String id;
  final String title;
  final String slug;
  final String shortDescription;
  final String? thumbnail;
  final String category;
  final String categoryName;
  final String providerId;
  final String providerName;
  final String pricingType;
  final String basePrice;
  final String? discountPrice;
  final String effectivePrice;
  final String currency;
  final String unitLabel;
  final int durationMinutes;
  final String serviceArea;
  final double ratingAverage;
  final int ratingCount;
  final int bookingCount;
  final bool isFeatured;
  final String status;
  final String statusDisplay;
  final bool isFavorited;

  const CatalogServiceModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.shortDescription,
    this.thumbnail,
    required this.category,
    required this.categoryName,
    required this.providerId,
    required this.providerName,
    required this.pricingType,
    required this.basePrice,
    this.discountPrice,
    required this.effectivePrice,
    required this.currency,
    required this.unitLabel,
    required this.durationMinutes,
    required this.serviceArea,
    required this.ratingAverage,
    required this.ratingCount,
    required this.bookingCount,
    required this.isFeatured,
    required this.status,
    required this.statusDisplay,
    required this.isFavorited,
  });

  factory CatalogServiceModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic v) {
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic v) {
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return CatalogServiceModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      shortDescription: json['short_description']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString(),
      category: json['category']?.toString() ?? '',
      categoryName: json['category_name']?.toString() ?? '',
      providerId: json['provider_id']?.toString() ?? '',
      providerName: json['provider_name']?.toString() ?? '',
      pricingType: json['pricing_type']?.toString() ?? 'fixed',
      basePrice: json['base_price']?.toString() ?? '0.00',
      discountPrice: json['discount_price']?.toString(),
      effectivePrice: json['effective_price']?.toString() ??
          json['base_price']?.toString() ??
          '0.00',
      currency: json['currency']?.toString() ?? 'ZMW',
      unitLabel: json['unit_label']?.toString() ?? '',
      durationMinutes: parseInt(json['duration_minutes']),
      serviceArea: json['service_area']?.toString() ?? '',
      ratingAverage: parseDouble(json['rating_average']),
      ratingCount: parseInt(json['rating_count']),
      bookingCount: parseInt(json['booking_count']),
      isFeatured: json['is_featured'] as bool? ?? false,
      status: json['status']?.toString() ?? 'active',
      statusDisplay: json['status_display']?.toString() ?? 'Active',
      isFavorited: json['is_favorited'] as bool? ?? false,
    );
  }

  HomeProviderData toHomeProviderData() {
    final cleanName = providerName.isNotEmpty ? providerName : title;
    final mockEmail =
        '${cleanName.toLowerCase().replaceAll(RegExp(r'\s+'), '.')}@gmail.com';
    return HomeProviderData(
      id: providerId.isNotEmpty ? providerId : id,
      photo: thumbnail ?? AssetsPath.exploreProviderPhotoJhoneDoe,
      name: cleanName,
      service: title,
      price: '$currency $effectivePrice',
      rating: ratingAverage.toStringAsFixed(1),
      email: mockEmail,
      phone: '+260 97 555 1234',
      area: serviceArea.isNotEmpty ? '$serviceArea, Zambia' : 'Lusaka, Zambia',
      description: shortDescription.isNotEmpty ? shortDescription : title,
      reviewCount: ratingCount.toString(),
      totalJobsCompleted: bookingCount.toString(),
      tags: [
        ProviderTag(
          iconAsset: AssetsPath.categoryCleaning,
          label: categoryName.isNotEmpty ? categoryName : 'Service',
        ),
      ],
    );
  }
}

class CatalogSearchResultModel {
  final List<CatalogServiceModel> services;
  final List<ExploreProviderItemModel> providers;

  const CatalogSearchResultModel({
    required this.services,
    required this.providers,
  });

  factory CatalogSearchResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final rawServices = data['services'] as List<dynamic>? ?? [];
    final rawProviders = data['providers'] as List<dynamic>? ?? [];

    return CatalogSearchResultModel(
      services: rawServices
          .whereType<Map<String, dynamic>>()
          .map((e) => CatalogServiceModel.fromJson(e))
          .toList(),
      providers: rawProviders
          .whereType<Map<String, dynamic>>()
          .map((e) => ExploreProviderItemModel.fromJson(e))
          .toList(),
    );
  }
}
