/// Asset path constants imported from the Figma file:
/// Nchito — Service Marketplace | UI/UX Design
///
/// Organized by screen. Each screen's assets live under:
/// `assets/icons/user/<screen>/` and `assets/images/user/<screen>/`
class AssetsPath {
  AssetsPath._();

  // ==========================================================
  // HOME SCREEN — assets/icons/user/home_section/home, assets/images/user/home_section/home
  // ==========================================================
  static const String _homeIconBase = 'assets/icons/user/home_section/home';
  static const String _homeImageBase = 'assets/images/user/home_section/home';

  // Bottom navigation icons
  static const String navHome = '$_homeIconBase/nav_home.svg';
  static const String navExplore = '$_homeIconBase/nav_explore.svg';
  static const String navBookings = '$_homeIconBase/nav_bookings.svg';
  static const String navMessages = '$_homeIconBase/nav_messages.svg';
  static const String navProfile = '$_homeIconBase/nav_profile.svg';

  // Status bar icons
  static const String statusTime = '$_homeIconBase/status_time.svg';
  static const String statusAlarm = '$_homeIconBase/status_alarm.svg';
  static const String statusBluetooth = '$_homeIconBase/status_bluetooth.svg';
  static const String statusWifi = '$_homeIconBase/status_wifi.svg';
  static const String statusSignal = '$_homeIconBase/status_signal.svg';
  static const String statusBattery = '$_homeIconBase/status_battery.svg';

  // Header icons
  static const String iconLocation = '$_homeIconBase/icon_location.svg';
  static const String iconChevronDown = '$_homeIconBase/icon_chevron_down.svg';
  static const String dropDown = '$_homeIconBase/drop_down.svg';
  static const String iconNotification = '$_homeIconBase/icon_notification.svg';
  static const String iconSearch = '$_homeIconBase/icon_search.svg';
  static const String iconStar = '$_homeIconBase/icon_star.svg';

  // Service category icons
  static const String categoryCleaning = '$_homeIconBase/category_cleaning.svg';
  static const String categoryPlumbing = '$_homeIconBase/category_plumbing.svg';
  static const String categoryElectrical =
      '$_homeIconBase/category_electrical.svg';
  static const String categoryGardening =
      '$_homeIconBase/category_gardening.svg';
  static const String categoryPainting = '$_homeIconBase/category_painting.svg';
  static const String categoryMoving = '$_homeIconBase/category_moving.svg';
  static const String categoryPersonalCare =
      '$_homeIconBase/category_personal_care.svg';
  static const String categoryViewMore =
      '$_homeIconBase/category_view_more.svg';

  // Active booking icons
  static const String bookingIconElectrical =
      '$_homeIconBase/booking_icon_electrical.svg';
  static const String bookingIconCleaning =
      '$_homeIconBase/booking_icon_cleaning.svg';
  static const String bookingIconCleaning2 =
      '$_homeIconBase/booking_icon_cleaning_2.svg';
  static const String bookingIconMoving =
      '$_homeIconBase/booking_icon_moving.svg';
  static const String bookingIconMoving1 =
      '$_homeIconBase/booking_icon_moving_1.svg';
  static const String bookingIconMoving2 =
      '$_homeIconBase/booking_icon_moving_2.svg';

  // Images
  static const String avatarUser = '$_homeImageBase/avatar_user.png';
  static const String providerRobert = '$_homeImageBase/provider_robert.png';
  static const String providerAlex = '$_homeImageBase/provider_alex.png';

  // ==========================================================
  // PROVIDER DETAILS SCREEN — assets/icons/user/home_section/provider_details, assets/images/user/home_section/provider_details
  // ==========================================================
  static const String _providerDetailsIconBase =
      'assets/icons/user/home_section/provider_details';
  static const String _providerDetailsImageBase =
      'assets/images/user/home_section/provider_details';

  static const String providerDetailsIconBack =
      '$_providerDetailsIconBase/icon_back.svg';
  static const String providerDetailsIconMore =
      '$_providerDetailsIconBase/icon_more.svg';
  static const String providerDetailsIconVerifiedBadge =
      '$_providerDetailsIconBase/icon_verified_badge.svg';
  static const String providerDetailsTagIconElectrical =
      '$_providerDetailsIconBase/tag_icon_electrical.svg';
  static const String providerDetailsTagIconMoving1 =
      '$_providerDetailsIconBase/tag_icon_moving_1.svg';
  static const String providerDetailsTagIconMoving2 =
      '$_providerDetailsIconBase/tag_icon_moving_2.svg';
  static const String providerDetailsTagIconPainting =
      '$_providerDetailsIconBase/tag_icon_painting.svg';
  static const String providerDetailsIconStar =
      '$_providerDetailsIconBase/icon_star.svg';
  static const String providerDetailsIconChevronRight =
      '$_providerDetailsIconBase/icon_chevron_right.svg';
  static const String providerDetailsIconMessage =
      '$_providerDetailsIconBase/icon_message.svg';
  static const String providerDetailsIconCalendar =
      '$_providerDetailsIconBase/icon_calendar.svg';

  static const String providerDetailsPhoto =
      '$_providerDetailsImageBase/provider_photo.png';

  // ==========================================================
  // BOOKING DETAILS SCREEN — assets/icons/user/home_section/booking_details
  // (reuses providerDetailsIconBack, providerDetailsIconChevronRight and
  // providerDetailsPhoto above — identical assets, no duplicate files kept)
  // ==========================================================
  static const String _bookingDetailsIconBase =
      'assets/icons/user/home_section/booking_details';

  static const String bookingDetailsIconDot =
      '$_bookingDetailsIconBase/icon_dot.svg';
  static const String bookingDetailsIconVerifiedBadge =
      '$_bookingDetailsIconBase/icon_verified_badge.svg';
  static const String bookingDetailsServiceIconElectrical =
      '$_bookingDetailsIconBase/service_icon_electrical.svg';
  static const String bookingDetailsIconViewProvider =
      '$_bookingDetailsIconBase/icon_view_provider.svg';

  // ==========================================================
  // EXPLORE_PROVIDER_SECTION (home_section is done — new screens go here)
  // ==========================================================

  // EXPLORE PROVIDER SCREEN — assets/icons/user/explore_provider_section/explore_provider
  // (reuses navBookings, navMessages, navProfile from HOME SCREEN and
  // providerDetailsIconBack from PROVIDER DETAILS SCREEN — identical assets)
  static const String _exploreProviderIconBase =
      'assets/icons/user/explore_provider_section/explore_provider';

  static const String exploreProviderNavHomeOutline =
      '$_exploreProviderIconBase/nav_home_outline.svg';
  static const String exploreProviderNavExploreActive =
      '$_exploreProviderIconBase/nav_explore_active.svg';
  static const String exploreProviderIconSearch =
      '$_exploreProviderIconBase/icon_search.svg';
  static const String exploreProviderIconFilter =
      '$_exploreProviderIconBase/icon_filter.svg';
  static const String exploreProviderIconCalendarChevron =
      '$_exploreProviderIconBase/icon_calendar_chevron.svg';
  static const String exploreProviderIllustrationNoResults =
      '$_exploreProviderIconBase/illustration_no_results.svg';

  static const String _exploreProviderImageBase =
      'assets/images/user/explore_provider_section/explore_provider';

  static const String exploreProviderPhotoJhoneDoe =
      '$_exploreProviderImageBase/provider_jhone.png';

  // FILTER modal (on Explore Provider) — assets/icons/user/explore_provider_section/filter
  static const String _filterIconBase =
      'assets/icons/user/explore_provider_section/filter';

  static const String filterIconClose = '$_filterIconBase/icon_close.svg';
  static const String filterIconDropdownChevron =
      '$_filterIconBase/icon_dropdown_chevron.svg';
  static const String filterIconPriceRangeDash =
      '$_filterIconBase/icon_price_range_dash.svg';
  static const String filterSliderTrack = '$_filterIconBase/slider_track.svg';

  // PROVIDER DETAILS SCREEN (Explore flow variant) — own folder, NOT merged
  // with the home_section provider_details above, even though most icons
  // are visually identical (kept as separate files per instruction).
  // assets/icons/user/explore_provider_section/provider_details
  static const String _exploreProviderDetailsIconBase =
      'assets/icons/user/explore_provider_section/provider_details';
  static const String _exploreProviderDetailsImageBase =
      'assets/images/user/explore_provider_section/provider_details';

  static const String exploreProviderDetailsIconBack =
      '$_exploreProviderDetailsIconBase/icon_back.svg';
  static const String exploreProviderDetailsIconFavoriteOutline =
      '$_exploreProviderDetailsIconBase/icon_favorite_outline.svg';
  static const String exploreProviderDetailsIconVerifiedBadge =
      '$_exploreProviderDetailsIconBase/icon_verified_badge.svg';
  static const String exploreProviderDetailsTagIconElectrical =
      '$_exploreProviderDetailsIconBase/tag_icon_electrical.svg';
  static const String exploreProviderDetailsTagIconMoving1 =
      '$_exploreProviderDetailsIconBase/tag_icon_moving_1.svg';
  static const String exploreProviderDetailsTagIconMoving2 =
      '$_exploreProviderDetailsIconBase/tag_icon_moving_2.svg';
  static const String exploreProviderDetailsTagIconPainting =
      '$_exploreProviderDetailsIconBase/tag_icon_painting.svg';
  static const String exploreProviderDetailsIconStar =
      '$_exploreProviderDetailsIconBase/icon_star.svg';
  static const String exploreProviderDetailsIconChevronRight =
      '$_exploreProviderDetailsIconBase/icon_chevron_right.svg';
  static const String exploreProviderDetailsIconMessage =
      '$_exploreProviderDetailsIconBase/icon_message.svg';
  static const String exploreProviderDetailsIconCalendar =
      '$_exploreProviderDetailsIconBase/icon_calendar.svg';

  static const String exploreProviderDetailsPhoto =
      '$_exploreProviderDetailsImageBase/provider_photo.png';

  // BOOK A SERVICE SCREEN — assets/icons/user/explore_provider_section/book_service
  // (reuses exploreProviderDetailsIconBack, exploreProviderDetailsIconChevronRight,
  // exploreProviderDetailsPhoto and filterIconDropdownChevron — identical assets)
  static const String _bookServiceIconBase =
      'assets/icons/user/explore_provider_section/book_service';

  static const String bookServiceIconVerifiedBadgeSmall =
      '$_bookServiceIconBase/icon_verified_badge_small.svg';
  static const String bookServiceIconStarSmall =
      '$_bookServiceIconBase/icon_star_small.svg';
  static const String bookServiceIconResizeHandle =
      '$_bookServiceIconBase/icon_resize_handle.svg';
  static const String bookServiceIconInformationLarge =
      '$_bookServiceIconBase/icon_information_large.svg';

  // ==========================================================
  // AUTH_SECTION (explore_provider_section is done — new screens go here)
  // ==========================================================

  // LOG IN SCREEN — assets/icons/user/auth_section/log_in
  static const String _logInIconBase = 'assets/icons/user/auth_section/log_in';

  static const String logInIconCheckboxUnchecked =
      '$_logInIconBase/icon_checkbox_unchecked.svg';
  static const String logInIconCheckboxChecked =
      '$_logInIconBase/icon_checkbox_checked.svg';
  static const String logInIconEyeToggle =
      '$_logInIconBase/icon_eye_toggle.svg';
  static const String logInDividerLine = '$_logInIconBase/divider_line.svg';
  static const String logInIconSocialGoogle =
      '$_logInIconBase/icon_social_google.svg';
  static const String logInIconSocialApple =
      '$_logInIconBase/icon_social_apple.svg';

  // AGE CONFIRMATION ALERT SCREEN — assets/icons/user/auth_section/age_confirmation_alert
  static const String _ageConfirmationAlertIconBase =
      'assets/icons/user/auth_section/age_confirmation_alert';

  static const String ageConfirmationAlertIconInformation =
      '$_ageConfirmationAlertIconBase/icon_information.svg';

  // SPLASH SCREEN (role selection) — assets/images/user/auth_section/splash_screen
  static const String _splashScreenImageBase =
      'assets/images/user/auth_section/splash_screen';

  static const String splashScreenIllustrationFindService =
      '$_splashScreenImageBase/illustration_find_service.png';
  static const String splashScreenIllustrationOfferService =
      '$_splashScreenImageBase/illustration_offer_service.png';

  // SIGN UP SCREEN — no new asset files; reuses logInIconCheckboxChecked and
  // logInIconEyeToggle from LOG IN SCREEN above (identical icons)

  // VERIFY YOUR OTP SCREEN — no new asset files (status bar icons only, reused from HOME SCREEN)

  // ONBOARDING 01 SCREEN — assets/icons/user/auth_section/onboarding_01, assets/images/user/auth_section/onboarding_01
  static const String _onboarding01IconBase =
      'assets/icons/user/auth_section/onboarding_01';
  static const String _onboarding01ImageBase =
      'assets/images/user/auth_section/onboarding_01';

  static const String onboarding01MaskShape =
      '$_onboarding01IconBase/mask_shape.svg';
  static const String onboarding01IconBack =
      '$_onboarding01IconBase/icon_back.svg';
  static const String onboarding01PageIndicatorDots =
      '$_onboarding01IconBase/page_indicator_dots.svg';
  static const String onboarding01IconArrowNext =
      '$_onboarding01IconBase/icon_arrow_next.svg';

  static const String onboarding01IllustrationHero =
      '$_onboarding01ImageBase/illustration_hero.png';

  // ONBOARDING 05 SCREEN — assets/icons/user/auth_section/onboarding_05, assets/images/user/auth_section/onboarding_05
  // (reuses onboarding01IconBack and onboarding01IconArrowNext — identical assets)
  static const String _onboarding05IconBase =
      'assets/icons/user/auth_section/onboarding_05';
  static const String _onboarding05ImageBase =
      'assets/images/user/auth_section/onboarding_05';

  static const String onboarding05MaskShape =
      '$_onboarding05IconBase/mask_shape.svg';
  static const String onboarding05PageIndicatorDots =
      '$_onboarding05IconBase/page_indicator_dots.svg';

  static const String onboarding05IllustrationHero =
      '$_onboarding05ImageBase/illustration_hero.png';

  // ONBOARDING 04 SCREEN — assets/icons/user/auth_section/onboarding_04, assets/images/user/auth_section/onboarding_04
  // (reuses onboarding01IconBack and onboarding01IconArrowNext — identical assets)
  static const String _onboarding04IconBase =
      'assets/icons/user/auth_section/onboarding_04';
  static const String _onboarding04ImageBase =
      'assets/images/user/auth_section/onboarding_04';

  static const String onboarding04MaskShape =
      '$_onboarding04IconBase/mask_shape.svg';
  static const String onboarding04PageIndicatorDots =
      '$_onboarding04IconBase/page_indicator_dots.svg';

  static const String onboarding04IllustrationHero =
      '$_onboarding04ImageBase/illustration_hero.png';

  // FORGOT PASSWORD SCREEN — no new asset files (status bar icons only, reused from HOME SCREEN)

  // VERIFY YOUR OTP SCREEN (mobile variant) — no new asset files (status bar icons only, reused from HOME SCREEN)

  // SET NEW PASSWORD SCREEN — assets/icons/user/auth_section/set_new_password
  // (reuses logInIconEyeToggle from LOG IN SCREEN for the "New Password" field)
  static const String _setNewPasswordIconBase =
      'assets/icons/user/auth_section/set_new_password';

  static const String setNewPasswordIconEyeVisible =
      '$_setNewPasswordIconBase/icon_eye_visible.svg';

  // ACCOUNT BLOCKED BY ADMIN SCREEN — assets/icons/user/auth_section/account_blocked_by_admin
  static const String _accountBlockedByAdminIconBase =
      'assets/icons/user/auth_section/account_blocked_by_admin';

  static const String accountBlockedByAdminIconBlocked =
      '$_accountBlockedByAdminIconBase/icon_blocked.svg';

  // ==========================================================
  // MESSAGES_SECTION (auth_section is done — new screens go here)
  // ==========================================================

  // MESSAGES SCREEN — assets/icons/user/messages_section/messages, assets/images/user/messages_section/messages
  // (reuses navHome, navExplore, navBookings, navMessages, navProfile from
  // HOME SCREEN for the bottom nav bar — identical assets)
  static const String _messagesIconBase =
      'assets/icons/user/messages_section/messages';
  static const String _messagesImageBase =
      'assets/images/user/messages_section/messages';

  static const String messagesIconBack = '$_messagesIconBase/icon_back.svg';
  static const String messagesIconSearch =
      '$_messagesIconBase/icon_search.svg';
  static const String messagesIconOnlineBadge =
      '$_messagesIconBase/icon_online_badge.svg';

  static const String messagesAvatarRobertsJunior =
      '$_messagesImageBase/avatar_roberts_junior.png';
  static const String messagesAvatarOliviaMartinez =
      '$_messagesImageBase/avatar_olivia_martinez.png';
  static const String messagesAvatarMichaelSmith =
      '$_messagesImageBase/avatar_michael_smith.png';
  static const String messagesAvatarDavidKim =
      '$_messagesImageBase/avatar_david_kim.png';
  static const String messagesAvatarSophiaWhite =
      '$_messagesImageBase/avatar_sophia_white.png';

  // ==========================================================
  // BOOKINGS_SECTION (messages_section is done — new screens go here)
  // ==========================================================

  // MY BOOKINGS SCREEN — assets/icons/user/bookings_section/my_bookings
  // (reuses navHome, navExplore, navBookings, navMessages, navProfile from
  // HOME SCREEN and providerDetailsIconBack from PROVIDER DETAILS SCREEN
  // for the header back button — identical assets)
  static const String _myBookingsIconBase =
      'assets/icons/user/bookings_section/my_bookings';

  static const String myBookingsIconSearch =
      '$_myBookingsIconBase/icon_search.svg';
  static const String myBookingsIconFilter =
      '$_myBookingsIconBase/icon_filter.svg';
  static const String myBookingsServiceIconCleaning =
      '$_myBookingsIconBase/service_icon_cleaning.svg';
  static const String myBookingsServiceIconMoving =
      '$_myBookingsIconBase/service_icon_moving.svg';
  static const String myBookingsServiceIconElectrical =
      '$_myBookingsIconBase/service_icon_electrical.svg';

  // BOOKING DETAILS SCREEN (BOOKINGS_SECTION — accepted/quote variant)
  // (reuses bookingDetailsIconDot, bookingDetailsIconVerifiedBadge and
  // bookingDetailsIconViewProvider from HOME_SECTION above — identical
  // assets, no duplicate files kept)
  static const String _bookingsBookingDetailsIconBase =
      'assets/icons/user/bookings_section/booking_details';
  static const String bookingsBookingDetailsIconDeclineWarning =
      '$_bookingsBookingDetailsIconBase/icon_decline_warning.svg';
  static const String bookingsBookingDetailsIconCancelBooking =
      '$_bookingsBookingDetailsIconBase/icon_cancel_booking.svg';
  static const String bookingsBookingDetailsIconProceedToPayment =
      '$_bookingsBookingDetailsIconBase/icon_proceed_to_payment.svg';

  // ==========================================================
  // APP SPLASH SCREEN — assets/icons/spash
  // ==========================================================
  static const String _splashIconBase = 'assets/icons/spash';

  static const String splashIcon = '$_splashIconBase/splash_icon.svg';
}
