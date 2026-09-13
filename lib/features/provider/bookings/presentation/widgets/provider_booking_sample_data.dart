import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// A customer's booking (request or confirmed) shown to a provider — on
/// the Provider Home screen's lists and the Provider Booking Details
/// screen.
class ProviderBookingData {
  final String customerName;
  final String service;
  final String price;
  final String iconAsset;
  final Color iconBgColor;

  /// Short chip fields shown on the Home screen's list tile.
  final String day;
  final String month;
  final String time;

  final String status;
  final String location;
  final String fullDate;
  final String fullTime;
  final String details;
  final String customerPhoto;
  final String customerEmailOrPhone;

  const ProviderBookingData({
    required this.customerName,
    required this.service,
    required this.price,
    required this.iconAsset,
    required this.iconBgColor,
    required this.day,
    required this.month,
    required this.time,
    required this.status,
    required this.location,
    required this.fullDate,
    required this.fullTime,
    required this.details,
    required this.customerPhoto,
    required this.customerEmailOrPhone,
  });
}

/// Placeholder content for the Provider Home/Booking Details screens
/// until they're wired to real data.
const List<ProviderBookingData> providerNewBookingRequests = [
  ProviderBookingData(
    customerName: AppText.robertsJuniorProviderName,
    service: AppText.categoryCleaning,
    price: 'ZMW 100',
    iconAsset: AssetsPath.categoryCleaning,
    iconBgColor: AppColors.brandSoft,
    day: '25',
    month: 'Aug',
    time: '10:00 PM',
    status: AppText.pending,
    location: 'Lusaka, Zambia',
    fullDate: '25 August 2026',
    fullTime: '10:00 PM',
    details:
        'Join us for an evening of networking, live music, and curated '
        'drinks. Connect with professionals, entrepreneurs, and creatives '
        'in a relaxed rooftop setting.',
    customerPhoto: AssetsPath.avatarUser,
    customerEmailOrPhone: '+260 97 123 4567',
  ),
  ProviderBookingData(
    customerName: 'Alex Johnson',
    service: AppText.categoryMoving,
    price: 'ZMW 100',
    iconAsset: AssetsPath.categoryMoving,
    iconBgColor: AppColors.teal50,
    day: '01',
    month: 'Sep',
    time: '10:00 PM',
    status: AppText.pending,
    location: 'Lusaka, Zambia',
    fullDate: '01 September 2026',
    fullTime: '10:00 PM',
    details:
        'Full-house moving service — packing, transport, and careful '
        'handling of furniture and appliances to the new address.',
    customerPhoto: AssetsPath.messagesAvatarOliviaMartinez,
    customerEmailOrPhone: '+260 97 987 6543',
  ),
  ProviderBookingData(
    customerName: AppText.userNameVaughan,
    service: AppText.categoryElectrical,
    price: 'ZMW 100',
    iconAsset: AssetsPath.categoryElectrical,
    iconBgColor: AppColors.orange50,
    day: '31',
    month: 'Aug',
    time: '10:00 PM',
    status: AppText.pending,
    location: 'Lusaka, Zambia',
    fullDate: '23 February 2026',
    fullTime: '6:00 PM',
    details:
        'Join us for an evening of networking, live music, and curated '
        'drinks. Connect with professionals, entrepreneurs, and creatives '
        'in a relaxed rooftop setting.',
    customerPhoto: AssetsPath.avatarUser,
    customerEmailOrPhone: 'robert@Junior.com',
  ),
];

const List<ProviderBookingData> providerTodaysBookings = [
  ProviderBookingData(
    customerName: AppText.userNameVaughan,
    service: AppText.categoryElectrical,
    price: 'ZMW 100',
    iconAsset: AssetsPath.categoryElectrical,
    iconBgColor: AppColors.orange50,
    day: '31',
    month: 'Aug',
    time: '10:00 PM',
    status: 'Scheduled',
    location: 'Lusaka, Zambia',
    fullDate: '23 February 2026',
    fullTime: '6:00 PM',
    details:
        'Join us for an evening of networking, live music, and curated '
        'drinks. Connect with professionals, entrepreneurs, and creatives '
        'in a relaxed rooftop setting.',
    customerPhoto: AssetsPath.avatarUser,
    customerEmailOrPhone: 'robert@Junior.com',
  ),
];
