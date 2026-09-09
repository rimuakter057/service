import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Placeholder content for the Home screen until it's wired to real data.

class ReviewData {
  final String initials;
  final Color avatarColor;
  final String name;
  final String rating;
  final String date;
  final String comment;

  const ReviewData({
    required this.initials,
    required this.avatarColor,
    required this.name,
    required this.rating,
    required this.date,
    required this.comment,
  });
}

class HomeCategoryData {
  final String assetPath;
  final String label;
  final Color bgColor;
  final Color iconColor;

  const HomeCategoryData({
    required this.assetPath,
    required this.label,
    required this.bgColor,
    required this.iconColor,
  });
}

class ProviderTag {
  final String iconAsset;
  final String label;

  const ProviderTag({required this.iconAsset, required this.label});
}

class HomeProviderData {
  final String photo;
  final String name;
  final String service;
  final String price;
  final String rating;
  final String email;
  final String phone;
  final String area;
  final String description;
  final String reviewCount;
  final String totalJobsCompleted;
  final List<ProviderTag> tags;

  const HomeProviderData({
    required this.photo,
    required this.name,
    required this.service,
    required this.price,
    required this.rating,
    required this.email,
    required this.phone,
    required this.area,
    required this.description,
    required this.reviewCount,
    required this.totalJobsCompleted,
    required this.tags,
  });
}

class HomeBookingData {
  final String iconAsset;
  final Color iconBgColor;
  final Color iconColor;
  final String providerName;
  final String service;
  final String price;
  final String date;
  final String time;
  final String status;
  final String location;
  final String details;
  final HomeProviderData provider;

  const HomeBookingData({
    required this.iconAsset,
    required this.iconBgColor,
    required this.iconColor,
    required this.providerName,
    required this.service,
    required this.price,
    required this.date,
    required this.time,
    required this.status,
    required this.location,
    required this.details,
    required this.provider,
  });
}

const List<HomeCategoryData> homeCategories = [
  HomeCategoryData(
    assetPath: AssetsPath.categoryCleaning,
    label: AppText.categoryCleaning,
    bgColor: AppColors.emerald50,
    iconColor: AppColors.emerald400,
  ),
  HomeCategoryData(
    assetPath: AssetsPath.categoryPlumbing,
    label: AppText.categoryPlumbing,
    bgColor: AppColors.red50,
    iconColor: AppColors.red400,
  ),
  HomeCategoryData(
    assetPath: AssetsPath.categoryElectrical,
    label: AppText.categoryElectrical,
    bgColor: AppColors.orange50,
    iconColor: AppColors.orange400,
  ),
  HomeCategoryData(
    assetPath: AssetsPath.categoryGardening,
    label: AppText.categoryGardening,
    bgColor: AppColors.lime50,
    iconColor: AppColors.lime400,
  ),
  HomeCategoryData(
    assetPath: AssetsPath.categoryPainting,
    label: AppText.categoryPainting,
    bgColor: AppColors.teal50,
    iconColor: AppColors.cyan400,
  ),
  HomeCategoryData(
    assetPath: AssetsPath.categoryMoving,
    label: AppText.categoryMoving,
    bgColor: AppColors.blue50,
    iconColor: AppColors.blue400,
  ),
  HomeCategoryData(
    assetPath: AssetsPath.categoryPersonalCare,
    label: AppText.categoryPersonalCare,
    bgColor: AppColors.teal50,
    iconColor: AppColors.cyan400,
  ),
  HomeCategoryData(
    assetPath: AssetsPath.categoryViewMore,
    label: AppText.viewMore,
    bgColor: AppColors.borderDefault,
    iconColor: AppColors.textBlackPrimary,
  ),
];

const HomeProviderData robertJuniorProvider = HomeProviderData(
  photo: AssetsPath.providerRobert,
  name: 'Robert Junior',
  service: AppText.categoryElectrical,
  price: 'ZMW 100',
  rating: '4.8',
  email: 'robert@Junior.com',
  phone: '+260 97 123 4567',
  area: 'Lusaka, Zambia',
  description:
      'Skilled electrician with 5+ years of experience providing reliable home electrical repairs, installations, maintenance, and troubleshooting. Committed to delivering safe, high-quality workmanship and dependable service for every customer.',
  reviewCount: '112',
  totalJobsCompleted: '256',
  tags: [
    ProviderTag(
      iconAsset: AssetsPath.providerDetailsTagIconElectrical,
      label: AppText.categoryElectrical,
    ),
    ProviderTag(
      iconAsset: AssetsPath.providerDetailsTagIconMoving1,
      label: AppText.categoryMoving,
    ),
    ProviderTag(
      iconAsset: AssetsPath.providerDetailsTagIconPainting,
      label: AppText.categoryPainting,
    ),
  ],
);

const HomeProviderData alexJohnsonProvider = HomeProviderData(
  photo: AssetsPath.providerAlex,
  name: 'Alex Johnson',
  service: AppText.categoryCleaning,
  price: 'ZMW 100',
  rating: '4.8',
  email: 'alex@johnson.com',
  phone: '+260 97 765 4321',
  area: 'Lusaka, Zambia',
  description:
      'Detail-oriented cleaning professional with 4+ years of experience in residential and office cleaning. Known for punctuality, thoroughness, and using safe, effective cleaning methods for every home.',
  reviewCount: '98',
  totalJobsCompleted: '203',
  tags: [
    ProviderTag(
      iconAsset: AssetsPath.categoryCleaning,
      label: AppText.categoryCleaning,
    ),
    ProviderTag(
      iconAsset: AssetsPath.providerDetailsTagIconMoving2,
      label: AppText.categoryMoving,
    ),
  ],
);

const HomeProviderData sophiaKleinProvider = HomeProviderData(
  photo: AssetsPath.exploreProviderPhotoJhoneDoe,
  name: 'Sophia Klein',
  service: AppText.categoryGardening,
  price: 'ZMW 120',
  rating: '4.9',
  email: 'sophia@klein.com',
  phone: '+260 97 321 9876',
  area: 'Lusaka, Zambia',
  description:
      'Passionate gardener with 6+ years of experience in landscape design, lawn care, and plant maintenance. Transforms outdoor spaces into lush, beautiful environments.',
  reviewCount: '74',
  totalJobsCompleted: '189',
  tags: [
    ProviderTag(
      iconAsset: AssetsPath.categoryGardening,
      label: AppText.categoryGardening,
    ),
  ],
);

const HomeProviderData masonSchmidtProvider = HomeProviderData(
  photo: AssetsPath.providerRobert,
  name: 'Mason Schmidt',
  service: AppText.categoryPlumbing,
  price: 'ZMW 90',
  rating: '4.7',
  email: 'mason@schmidt.com',
  phone: '+260 97 654 3210',
  area: 'Lusaka, Zambia',
  description:
      'Licensed plumber with 7+ years of hands-on experience. Specialises in pipe repairs, installations, and emergency plumbing services across residential and commercial properties.',
  reviewCount: '134',
  totalJobsCompleted: '312',
  tags: [
    ProviderTag(
      iconAsset: AssetsPath.categoryPlumbing,
      label: AppText.categoryPlumbing,
    ),
  ],
);

const HomeProviderData liamThompsonProvider = HomeProviderData(
  photo: AssetsPath.providerAlex,
  name: 'Liam Thompson',
  service: AppText.categoryPainting,
  price: 'ZMW 80',
  rating: '4.6',
  email: 'liam@thompson.com',
  phone: '+260 97 111 2233',
  area: 'Lusaka, Zambia',
  description:
      'Creative painting specialist with expertise in interior and exterior painting, wall texturing, and decorative finishes. Known for clean, precise work delivered on time.',
  reviewCount: '88',
  totalJobsCompleted: '201',
  tags: [
    ProviderTag(
      iconAsset: AssetsPath.categoryPainting,
      label: AppText.categoryPainting,
    ),
  ],
);

const List<HomeProviderData> homePopularProviders = [
  robertJuniorProvider,
  alexJohnsonProvider,
  sophiaKleinProvider,
  masonSchmidtProvider,
  liamThompsonProvider,
];

const List<ReviewData> homeReviews = [
  ReviewData(
    initials: 'LT',
    avatarColor: AppColors.blue400,
    name: 'Liam Thompson',
    rating: '4.8',
    date: '15 Mar 2025',
    comment:
        'The electrical service provided by this company was exceptional! They arrived on time and handled the installation with great professionalism.',
  ),
  ReviewData(
    initials: 'EW',
    avatarColor: AppColors.emerald400,
    name: 'Ethan Brown',
    rating: '5.0',
    date: '07 Mar 2025',
    comment:
        'I was impressed by the quality of work and the attention to detail. The team was courteous and cleaned up thoroughly after the job.',
  ),
  ReviewData(
    initials: 'SK',
    avatarColor: AppColors.orange400,
    name: 'Sophie Klein',
    rating: '4.9',
    date: '28 Feb 2025',
    comment:
        'The service was excellent, wired to be spotted! The technician were friendly and efficient, ensuring everything was set up correctly.',
  ),
  ReviewData(
    initials: 'MS',
    avatarColor: AppColors.cyan400,
    name: 'Mason Schmidt',
    rating: '4.7',
    date: '25 Feb 2025',
    comment:
        'Great electrician and skilled and courteous. They provided excellent service and the installation process was smooth and hassle-free.',
  ),
  ReviewData(
    initials: 'LT',
    avatarColor: AppColors.red400,
    name: 'Liam Thompson',
    rating: '4.8',
    date: '18 Mar 2025',
    comment:
        'The electrician arrived on time and was very professional and clean. Highly recommended for anyone in need of electrical services.',
  ),
  ReviewData(
    initials: 'MS',
    avatarColor: AppColors.blue400,
    name: 'Mason Schmidt',
    rating: '4.9',
    date: '12 Mar 2025',
    comment:
        'The electrician was punctual and professional. He completed the job efficiently and left the work area clean and tidy.',
  ),
];

const List<HomeBookingData> homeActiveBookings = [
  HomeBookingData(
    iconAsset: AssetsPath.bookingIconCleaning,
    iconBgColor: AppColors.emerald50,
    iconColor: AppColors.emerald400,
    providerName: 'Robert Junior',
    service: AppText.categoryCleaning,
    price: 'ZMW 100',
    date: '25 Aug 2026',
    time: '10:00 PM',
    status: 'Pending',
    location: 'Lusaka, Zambia',
    details:
        'Join us for an evening of networking, live music, and curated drinks. Connect with professionals, entrepreneurs, and creatives in a relaxed rooftop setting.',
    provider: robertJuniorProvider,
  ),
  HomeBookingData(
    iconAsset: AssetsPath.bookingIconMoving,
    iconBgColor: AppColors.blue50,
    iconColor: AppColors.blue400,
    providerName: 'Alex Johnson',
    service: AppText.categoryMoving,
    price: 'ZMW 100',
    date: '01 Sep 2026',
    time: '10:00 PM',
    status: 'Confirmed',
    location: 'Lusaka, Zambia',
    details:
        'Full-service move of a 2-bedroom apartment, including packing fragile items and furniture disassembly/reassembly at the new address.',
    provider: alexJohnsonProvider,
  ),
  HomeBookingData(
    iconAsset: AssetsPath.bookingIconElectrical,
    iconBgColor: AppColors.orange50,
    iconColor: AppColors.orange400,
    providerName: 'Robert Junior',
    service: AppText.categoryElectrical,
    price: 'ZMW 100',
    date: '31 Aug 2026',
    time: '10:00 PM',
    status: 'Pending',
    location: 'Lusaka, Zambia',
    details:
        'Inspect and repair faulty wiring in the kitchen and living room, and install two new outdoor light fixtures.',
    provider: robertJuniorProvider,
  ),
];
