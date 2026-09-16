import 'package:flutter/material.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Data model representing a service offered by a provider.
class ProviderServiceData {
  final String id;
  final String photo;
  final String name;
  final String service;
  final String price;
  final String rating;
  final String reviewCount;
  final String area;
  final String description;
  final String totalJobs;
  final String badgeIconAsset;
  final Color badgeBgColor;
  final Color badgeIconColor;

  const ProviderServiceData({
    required this.id,
    required this.photo,
    required this.name,
    required this.service,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.area,
    required this.description,
    required this.totalJobs,
    required this.badgeIconAsset,
    required this.badgeBgColor,
    required this.badgeIconColor,
  });
}

/// Sample services for the provider role matching the UI designs.
final List<ProviderServiceData> sampleProviderServices = [
  const ProviderServiceData(
    id: '1',
    photo: AssetsPath.providerDetailsPhoto,
    name: 'Robert Junior',
    service: 'Electrical',
    price: 'ZMW 100',
    rating: '4.8',
    reviewCount: '112',
    area: 'Lusaka, Zambia',
    description:
        'Skilled electrician with 5+ years of experience providing reliable home electrical repairs, installations, maintenance, and troubleshooting. Committed to delivering safe, high-quality workmanship and dependable service for every customer.',
    totalJobs: '256',
    badgeIconAsset: AssetsPath.providerDetailsTagIconElectrical,
    badgeBgColor: Color(0xFFFFF7ED),
    badgeIconColor: Color(0xFFF97316),
  ),
  const ProviderServiceData(
    id: '2',
    photo: AssetsPath.providerDetailsPhoto,
    name: 'Robert Junior',
    service: 'Moving & Relocation',
    price: 'ZMW 100',
    rating: '4.8',
    reviewCount: '98',
    area: 'Lusaka, Zambia',
    description:
        'Professional mover offering dependable local and residential relocation, careful packing, and heavy furniture transport across Lusaka.',
    totalJobs: '184',
    badgeIconAsset: AssetsPath.providerDetailsTagIconMoving1,
    badgeBgColor: Color(0xFFEFF8FF),
    badgeIconColor: Color(0xFF0EA5E9),
  ),
];
