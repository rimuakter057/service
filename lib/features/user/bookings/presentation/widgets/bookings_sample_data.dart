import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/home/presentation/widgets/home_sample_data.dart';

/// One row of booking data shown on the My Bookings screen — also carries
/// everything the Booking Details screen needs.
class BookingHistoryData {
  final String iconAsset;
  final Color iconBgColor;
  final String providerName;
  final String service;
  final String price;
  final String day;
  final String month;
  final String time;
  final String status;
  final String location;
  final String date;
  final String details;
  final HomeProviderData provider;

  /// Total cost of an accepted quote. Null while the booking has no quote
  /// yet — the Booking Details screen shows the Payment Info card and the
  /// Decline Quote/Proceed to Pay actions only when this is set.
  final String? serviceCost;

  const BookingHistoryData({
    required this.iconAsset,
    required this.iconBgColor,
    required this.providerName,
    required this.service,
    required this.price,
    required this.day,
    required this.month,
    required this.time,
    this.status = AppText.completed,
    required this.location,
    required this.date,
    required this.details,
    required this.provider,
    this.serviceCost,
  });

  BookingHistoryData copyWith({
    String? iconAsset,
    Color? iconBgColor,
    String? providerName,
    String? service,
    String? price,
    String? day,
    String? month,
    String? time,
    String? status,
    String? location,
    String? date,
    String? details,
    HomeProviderData? provider,
    String? serviceCost,
  }) {
    return BookingHistoryData(
      iconAsset: iconAsset ?? this.iconAsset,
      iconBgColor: iconBgColor ?? this.iconBgColor,
      providerName: providerName ?? this.providerName,
      service: service ?? this.service,
      price: price ?? this.price,
      day: day ?? this.day,
      month: month ?? this.month,
      time: time ?? this.time,
      status: status ?? this.status,
      location: location ?? this.location,
      date: date ?? this.date,
      details: details ?? this.details,
      provider: provider ?? this.provider,
      serviceCost: serviceCost ?? this.serviceCost,
    );
  }
}

/// Placeholder content for the My Bookings screen until it's wired to real data.
const List<BookingHistoryData> myBookingsHistory = [
  BookingHistoryData(
    iconAsset: AssetsPath.myBookingsServiceIconCleaning,
    iconBgColor: AppColors.brandSoft,
    providerName: 'Robert Junior',
    service: AppText.categoryCleaning,
    price: 'ZMW 100',
    day: '25',
    month: 'Aug',
    time: '10:00 PM',
    status: AppText.completed,
    location: 'Lusaka, Zambia',
    date: '25 August 2026',
    details:
        'Full deep cleaning of a 3-bedroom apartment, including kitchen, '
        'bathrooms and all living areas.',
    provider: robertJuniorProvider,
  ),
  BookingHistoryData(
    iconAsset: AssetsPath.myBookingsServiceIconMoving,
    iconBgColor: AppColors.teal50,
    providerName: 'Alex Johnson',
    service: AppText.categoryMoving,
    price: 'ZMW 100',
    day: '01',
    month: 'Sep',
    time: '10:00 PM',
    status: AppText.scheduled,
    location: 'Lusaka, Zambia',
    date: '01 September 2026',
    details:
        'Full-service move of a 2-bedroom apartment, including packing '
        'fragile items and furniture disassembly/reassembly at the new '
        'address.',
    provider: alexJohnsonProvider,
  ),
  BookingHistoryData(
    iconAsset: AssetsPath.myBookingsServiceIconElectrical,
    iconBgColor: AppColors.orange50,
    providerName: 'Robert Junior',
    service: AppText.categoryElectrical,
    price: 'ZMW 100',
    day: '23',
    month: 'Feb',
    time: '6:00 PM',
    status: AppText.accepted,
    location: 'Lusaka, Zambia',
    date: '23 February 2026',
    details:
        'Join us for an evening of networking, live music, and curated '
        'drinks. Connect with professionals, entrepreneurs, and creatives '
        'in a relaxed rooftop setting.',
    provider: robertJuniorProvider,
    serviceCost: 'ZMW 525.00',
  ),
];
