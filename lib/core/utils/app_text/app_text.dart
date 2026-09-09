/// Static UI text/copy pulled from the Figma file:
/// Nchito — Service Marketplace | UI/UX Design
///
/// Organized by screen, same convention as AssetsPath.
/// Naming rule: the constant name mirrors its text value (camelCase of the text).
class AppText {
  AppText._();

  // ==========================================================
  // Shared (bottom navigation label)
  // ==========================================================
  static const String explore = "Explore";

  // ==========================================================
  // HOME SCREEN
  // ==========================================================
  static const String whatDoYouNeedHelpWith = "What do you need help with?";
  static const String searchForAService = "Search for a service...";
  static const String selectableFeaturedService = "Selectable Featured Service";
  static const String popularNearYou = "Popular Near You";
  static const String activeBooking = "Active Booking";
  static const String viewAll = "View all";
  static const String viewMore = "View more";
  static const String serviceCategories = "Service Categories";
  static const String startsFrom = "Starts From";
  static const String reviews = "Reviews";
  static const String allReviews = "All Reviews";
  static const String categoryCleaning = "Cleaning";
  static const String categoryPlumbing = "Plumbing";
  static const String categoryElectrical = "Electrical";
  static const String categoryGardening = "Gardening";
  static const String categoryPainting = "Painting";
  static const String categoryMoving = "Moving";
  static const String categoryPersonalCare = "Personal Care";
  static const String home = "Home";
  static const String bookings = "Bookings";
  static const String messages = "Messages";
  static const String profile = "Profile";

  // ==========================================================
  // BOOKING DETAILS SCREEN (HOME_SECTION)
  // ==========================================================
  static const String bookingDetails = "Booking Details";
  static const String location = "Location";
  static const String date = "Date";
  static const String time = "Time";
  static const String details = "Details";
  static const String provider = "Provider";
  static const String cancelBooking = "Cancel Booking";
  static const String service = "Service";

  // ==========================================================
  // PROVIDER DETAILS SCREEN (HOME_SECTION)
  // ==========================================================
  static const String providerDetails = "Provider Details";
  static const String name = "Name";
  static const String email = "Email";
  static const String contactPhone = "Contact Phone";
  static const String serviceArea = "Service Area";
  static const String serviceDescription = "Service Description";
  static const String totalJobsCompleted = "Total Jobs Completed";
  static const String sendMessage = "Send Message";
  static const String seeAvailability = "See Availability";
  static const String providerAvailability = "Provider Availability";
  static const String availableTime = "Available Time";
  static const String bookNow = "Book Now";

  // ==========================================================
  // EXPLORE PROVIDER SCREEN
  // ==========================================================
  static const String exploreProvider = "Explore Provider";
  static const String search = "Search";
  static const String mon = "Mon";
  static const String tue = "Tue";
  static const String wed = "Wed";
  static const String thu = "Thu";
  static const String fri = "Fri";
  static const String sat = "Sat";
  static const String sun = "Sun";
  static const String weCouldntFindAnyMatches = "We couldn't find any matches.";

  // ==========================================================
  // FILTER modal (on Explore Provider)
  // ==========================================================
  static const String filter = "Filter";
  static const String refineServicesAndProvidersToFindTheRightMatch =
      "Refine services and providers to find the right match.";
  static const String serviceType = "Service Type";
  static const String selectServiceType = "Select Service Type";
  static const String serviceLocation = "Service Location";
  static const String enterYourLocation = "Enter your location";
  static const String sortBy = "Sort By";
  static const String selectSortingPreference = "Select sorting preference";
  static const String priceRange = "Price Range";
  static const String minimumRating = "Minimum Rating";
  static const String anyRating = "Any Rating";
  static const String upTo1 = "Up to \u{2605}1";
  static const String upTo2 = "Up to \u{2605}2";
  static const String upTo3 = "Up to \u{2605}3";
  static const String upTo4 = "Up to \u{2605}4";
  static const String only1 = "Only \u{2605}1";
  static const String resetFilter = "Reset Filter";
  static const String applyFilter = "Apply Filter";

  // Service Type list options (reuses categoryCleaning/categoryPlumbing/
  // categoryElectrical above for the first three)
  static const String serviceTypeGardeningLandscaping =
      "Gardening & Landscaping";
  static const String serviceTypeHomeMaintenance = "Home Maintenance";
  static const String serviceTypePaintingDecorating = "Painting & Decorating";
  static const String serviceTypeMovingRelocation = "Moving & Relocation";
  static const String serviceTypeBeautyPersonalCare = "Beauty & Personal Care";

  // Sort By list options
  static const String sortRecommended = "Recommended";
  static const String sortHighestRated = "Highest Rated";
  static const String sortLowestPrice = "Lowest Price";
  static const String sortHighestPrice = "Highest Price";
  static const String sortNearestFirst = "Nearest First";

  // ==========================================================
  // LOG IN SCREEN (AUTH_SECTION)
  // ==========================================================
  static const String welcomeBack = "Welcome Back";
  static const String logInToContinueWithNchito =
      "Log in to continue with Nchito.";
  static const String emailAddress = "Email Address";
  static const String enterYourEmailAddress = "Enter your email address";
  static const String password = "Password";
  static const String enterYourPassword = "Enter your password";
  static const String rememberMe = "Remember me";
  static const String forgotPassword = "Forgot password?";
  static const String logIn = "Log In";
  static const String orContinueWith = "Or continue with";
  static const String noAccountYet = "No account yet!";
  static const String createAnAccount = "Create an account !";

  // ==========================================================
  // AGE CONFIRMATION ALERT SCREEN (AUTH_SECTION)
  // ==========================================================
  static const String ageConfirmation = "Age Confirmation !";
  static const String
  youMustBe18YearsOrOlderToCreateAnAccountAndUseNchitoServicesPleaseConfirmYourAgeToContinue =
      "You must be 21+ years or older to create an account and use Nchito services. Please confirm your age to continue.";
  static const String exit = "Exit";
  static const String enter21Plus = "21+ Enter";

  // ==========================================================
  // SPLASH SCREEN / role selection (AUTH_SECTION)
  // ==========================================================
  static const String howWouldYouLikeToUseNchito =
      "How would you like to use Nchito?";
  static const String
  chooseHowYoudLikeToUseNchitoFindTheHelpYouNeedOrOfferYourSkillsToOthers =
      "Choose how you'd like to use Nchito. Find the help you need or offer your skills to others.";
  static const String findAService = "Find a Service";
  static const String offerAService = "Offer a Service";
  static const String continueButton = "Continue";

  // ==========================================================
  // SIGN UP SCREEN (AUTH_SECTION)
  // ==========================================================
  static const String createYourAccount = "Create Your Account";
  static const String signUpToGetStartedWithNchito =
      "Sign up to get started with Nchito.";
  static const String fullName = "Full Name";
  static const String enterYourFullName = "Enter your full name";
  static const String emailOrPhoneNumber = "Email or Phone Number";
  static const String enterYourEmailAddressOrMobileNumber =
      "Enter your email address or mobile number";
  static const String confirmPassword = "Confirm Password";
  static const String iAgreeToThe = "I agree to the";
  static const String termsOfService = "Terms of Service";
  static const String andConnector = "and";
  static const String privacyPolicy = "Privacy Policy";
  static const String createAccount = "Create Account";
  static const String alreadyHaveAnAccount = "Already have an account! ";
  static const String logInQuestion = "Log In !";

  // ==========================================================
  // VERIFY YOUR OTP SCREEN (AUTH_SECTION)
  // ==========================================================
  static const String verifyYourOtp = "Verify Your OTP";
  static const String enterThe6DigitVerificationCodeSentToYourEmailAddress =
      "Enter the 6-digit verification code sent to your email address.";
  static const String verificationCode = "Verification Code";
  static const String didntReceiveTheCode = "Didn't receive the code!";
  static const String resendIn = "Resend in";
  static const String resendAgain = "Resend Again";
  static const String verifyCode = "Verify Code";

  // ==========================================================
  // ONBOARDING 01 SCREEN (AUTH_SECTION)
  // ==========================================================
  static const String skip = "Skip";
  static const String findTheHelpYouNeed = "Find the Help You Need";
  static const String
  discoverLocalProfessionalsReadyToHelpWithEverydayServices =
      "Discover local professionals ready to help with everyday services.";
  static const String next = "Next";

  // ==========================================================
  // ONBOARDING 05 SCREEN (AUTH_SECTION)
  // ==========================================================
  static const String chooseWithConfidence = "Choose With Confidence";
  static const String
  exploreServicesCompareProfessionalsAndFindTheRightFitForYourNeeds =
      "Explore services, compare professionals, and find the right fit for your needs.";

  // ==========================================================
  // ONBOARDING 04 SCREEN (AUTH_SECTION)
  // ==========================================================
  static const String bookItYourWay = "Book It Your Way";
  static const String chooseAConvenientTimeAndGetYourServiceSortedWithEase =
      "Choose a convenient time and get your service sorted with ease.";

  // ==========================================================
  // FORGOT PASSWORD SCREEN (AUTH_SECTION)
  // ==========================================================
  static const String forgotPasswordTitle = "Forgot Password";
  static const String
  enterYourRegisteredEmailAddressAndWellSendYouAVerificationCodeToResetYourPassword =
      "Enter your registered email address and we'll send you a verification code to reset your password.";
  static const String enterYourRegisteredEmailAddress =
      "Enter your registered email address";
  static const String sendVerificationCode = "Send Verification Code";

  // ==========================================================
  // VERIFY YOUR OTP SCREEN — mobile variant (AUTH_SECTION)
  // (reuses verifyYourOtp, verificationCode, didntReceiveTheCode, resendIn,
  // verifyCode from the email variant above — identical text)
  // ==========================================================
  static const String enterThe6DigitVerificationCodeSentToYourMobileNumber =
      "Enter the 6-digit verification code sent to your mobile number.";

  // ==========================================================
  // SET NEW PASSWORD SCREEN (AUTH_SECTION)
  // ==========================================================
  static const String setNewPasswordTitle = "Set New Password";
  static const String createANewPasswordForYourAccountToContinueSecurely =
      "Create a new password for your account to continue securely.";
  static const String newPassword = "New Password";
  static const String confirmNewPassword = "Confirm New Password";
  static const String updatePassword = "Update Password";

  // ==========================================================
  // ACCOUNT BLOCKED BY ADMIN SCREEN (AUTH_SECTION)
  // ==========================================================
  static const String accountBlocked = "Account Blocked ?";
  static const String
  yourNchitoAccountHasBeenRestrictedByTheAdministratorSoYoureCurrentlyUnableToAccessYourAccountIfYouBelieveThisWasAMistakeOrNeedMoreInformationPleaseContactNchitoSupport =
      "Your Nchito account has been restricted by the administrator, so you're currently unable to access your account. If you believe this was a mistake or need more information, please contact Nchito Support.";
  static const String goBackLogin = "Go Back Login";

  // ==========================================================
  // BOOK A SERVICE SCREEN (EXPLORE_PROVIDER_SECTION)
  // (reuses serviceType, selectServiceType, serviceLocation from FILTER modal)
  // ==========================================================
  static const String bookAService = "Book a Service";
  static const String availableSlot = "Available Slot";
  static const String selectAvailableSlot = "Select Available Slot";
  static const String enterServiceAddress = "Enter service address";
  static const String bookingInstructions = "Booking Instructions";
  static const String
  egDescribeTheIssueAccessInstructionsOrSpecificRequirements =
      "e.g., describe the issue, access instructions, or specific requirements.";
  static const String submitRequest = "Submit Request";
  static const String readyToRequest = "Ready to Request?";
  static const String
  pleaseReviewYourBookingDetailsBeforeSendingYourServiceRequestToTheProvider =
      "Please review your booking details before sending your service request to the provider.";
  static const String cancel = "Cancel";
  static const String confirm = "Confirm";
}
