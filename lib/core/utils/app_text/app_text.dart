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
      "You must be 18+ years or older to create an account and use Nchito services. Please confirm your age to continue.";
  static const String exit = "Exit";
  static const String enter18Plus = "18+ Enter";
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

  // ==========================================================
  // PROFILE SCREEN
  // ==========================================================
  static const String userNameVaughan = "Vaughan Gething";
  static const String myProfile = "My Profile";
  static const String accountSetting = "Account Setting";
  static const String favoriteProviders = "Favorite Providers";
  static const String more = "More";
  static const String termsAndCondition = "Terms & Condition";
  static const String legalAndCompanyInfo = "Legal & Company Info";
  static const String helpAndSupport = "Help & Support";
  static const String logOut = "Log Out";

  // ==========================================================
  // MY PROFILE SCREEN (PROFILE_SECTION)
  // (reuses myProfile, name, userNameVaughan from above)
  // ==========================================================
  static const String emailPhoneNumber = "Email / Phone Number";
  static const String userPhoneVaughan = "+260 97 123 4567";
  static const String updateProfile = "Update Profile";

  // ==========================================================
  // UPDATE PROFILE SCREEN (PROFILE_SECTION)
  // (reuses fullName, enterYourFullName from SIGN UP SCREEN and
  // cancel, confirm from BOOK A SERVICE SCREEN above)
  // ==========================================================
  static const String phoneNumber = "Phone Number";
  static const String enterYourPhoneNumber = "Enter your phone number";
  static const String saveTheChanges = "Save the changes";
  static const String
  yourEmailAddressIsLinkedToYourNchitoAccountAndIsUsedForImportantAccountAndSecurityUpdatesSoItCannotBeChangedAtThisTime =
      "Your email address is linked to your Nchito account and is used for "
      "important account and security updates, so it cannot be changed at "
      "this time.";
  static const String saveProfileChangesExclaim = "Save Profile Changes!";
  static const String
  areYouSureYouWantToSaveYourProfileChangesYourUpdatedInformationWillBeAppliedToYourAccount =
      "Are you sure you want to save your profile changes! Your updated "
      "information will be applied to your account.";

  // ==========================================================
  // ACCOUNT SETTINGS SCREEN (PROFILE_SECTION)
  // (reuses accountSetting from PROFILE SCREEN above)
  // ==========================================================
  static const String changePassword = "Change Password";
  static const String deleteAccount = "Delete account";

  // ==========================================================
  // CHANGE PASSWORD SCREEN (PROFILE_SECTION)
  // (reuses newPassword, confirmNewPassword, enterYourPassword,
  // saveTheChanges, cancel, confirm from above)
  // ==========================================================
  static const String oldPassword = "Old Password";
  static const String changePasswordExclaim = "Change Password!";
  static const String
  areYouSureYouWantToUpdateYourPasswordYoullNeedToUseYourNewPasswordTheNextTimeYouLogIn =
      "Are you sure you want to update your password! You'll need to use "
      "your new password the next time you log in.";

  // ==========================================================
  // DELETE ACCOUNT confirmation sheet (PROFILE_SECTION — Account Settings)
  // (reuses cancel, confirm from above)
  // ==========================================================
  static const String deleteYourNchitoAccountExclaim =
      "Delete Your Nchito Account!";
  static const String
  thisActionIsPermanentYourNchitoAccountBookingHistoryServicesMessagesAndSavedActivityWillBePermanentlyRemovedAndCannotBeRecovered =
      "This action is permanent. Your Nchito account, booking history, "
      "services, messages, and saved activity will be permanently removed "
      "and cannot be recovered.";

  // ==========================================================
  // CONFIRM ACCOUNT DELETION sheet (PROFILE_SECTION — Account Settings)
  // (reuses enterYourPassword, cancel from above)
  // ==========================================================
  static const String confirmAccountDeletion = "Confirm Account Deletion";
  static const String
  forSecurityReasonsWeNeedYourPasswordToContinueOnceDeletedYourAccountAndAssociatedDataCannotBeRestored =
      "For security reasons, we need your password to continue. Once "
      "deleted, your account and associated data cannot be restored.";
  static const String confirmAndDelete = "Confirm & Delete";

  // ==========================================================
  // LEGAL & COMPANY INFO SCREEN (PROFILE_SECTION)
  // (reuses legalAndCompanyInfo, contactPhone, userPhoneVaughan from above)
  // ==========================================================
  static const String companyName = "Company Name";
  static const String nchitoCompanyName = "Nchito";
  static const String businessType = "Business Type";
  static const String onlineServiceMarketplacePlatform =
      "Online Service Marketplace Platform";
  static const String country = "Country";
  static const String zambia = "Zambia";
  static const String contactEmail = "Contact Email";
  static const String supportAtNchitoEmail = "support@Nchito.com";
  static const String officialWebsite = "Official Website";
  static const String nchitoWebsite = "www.Nchito.com";

  // ==========================================================
  // HELP & SUPPORT SCREEN (PROFILE_SECTION)
  // (reuses submit from LEAVE A REVIEW BOTTOM SHEET above)
  // ==========================================================
  static const String faqSectionTitle = "— FAQ";
  static const String howDoIBookAService = "How do I book a service!";
  static const String
  chooseAServiceSelectAProviderChooseAnAvailableDateAndTimeAndConfirmYourBooking =
      "Choose a service, select a provider, choose an available date and "
      "time, and confirm your booking.";
  static const String howDoIOfferAService = "How do I offer a service!";
  static const String howCanICancelABooking = "How can I cancel a booking!";
  static const String whatIfIHaveAnIssueWithAService =
      "What if I have an issue with a service!";
  static const String howCanIContactAProvider =
      "How can I contact a provider!";
  static const String howDoIContactNchitoSupport =
      "How do I contact Nchito Support!";

  static const String contactUsSectionTitle = "— Contact Us";
  static const String reasonForContact = "Reason for Contact";
  static const String enterYourReasonForContact =
      "Enter your Reason for Contact";
  static const String descriptionLabel = "Description";
  static const String pleaseDescribeYourIssueOrQuestionInDetail =
      "Please describe your issue or question in detail.";

  // ==========================================================
  // PROFILE SCREEN — Log Out confirmation sheet
  // (reuses logOut from PROFILE SCREEN above)
  // ==========================================================
  static const String logOutExclaim = "Log Out!";
  static const String areYouSureYouWantToLogOutOfYourNchitoAccount =
      "Are you sure you want to log out of your Nchito account!";

  // ==========================================================
  // NOTIFICATIONS SCREEN (NOTIFICATIONS_SECTION)
  // ==========================================================
  static const String notifications = "Notifications";
  static const String notifYourBookingWithRobertsJuniorHasBeenAccepted =
      "Your booking with Roberts Junior has been accepted.";
  static const String notifYourBookingRequestWasDeclinedByTheProvider =
      "Your booking request was declined by the provider.";
  static const String notifYourBookingHasBeenCancelled =
      "Your booking has been cancelled.";
  static const String notifYourServiceIsScheduledForTomorrowAt1000Am =
      "Your service is scheduled for tomorrow at 10:00 AM.";
  static const String notifYourProviderHasMarkedTheServiceAsCompleted =
      "Your provider has marked the service as completed.";
  static const String notifYourEligibleRefundHasBeenProcessed =
      "Your eligible refund has been processed.";
  static const String notifThereSAnUpdateRegardingYourReportedIssue =
      "There's an update regarding your reported issue.";
  static const String notifRobertsJuniorSentYouANewMessage =
      "Roberts Junior sent you a new message.";

  // ==========================================================
  // MESSAGES SCREEN
  // ==========================================================
  static const String searchByName = "Search By Name";
  static const String minAgo = "min ago";
  static const String robertsJunior = "Roberts Junior";
  static const String robertsJuniorLastMessage =
      "Hi, I'd like to confirm the details of my upcoming service.";
  static const String oliviaMartinez = "Olivia Martinez";
  static const String oliviaMartinezLastMessage =
      "Could you please confirm the available time for my booking!";
  static const String michaelSmith = "Michael Smith";
  static const String michaelSmithLastMessage =
      "Hi, I have a question about the service I booked.";
  static const String davidKim = "David Kim";
  static const String davidKimLastMessage =
      "Is there anything I need to prepare before you arrive!";
  static const String sophiaWhite = "Sophia White";
  static const String sophiaWhiteLastMessage =
      "Hi, I would like to check the payment status for my property.";
  static const String block = "Block";
  static const String unblock = "Unblock";
  static const String delete = "Delete";

  // ==========================================================
  // CHAT SCREEN (MESSAGES_SECTION)
  // ==========================================================
  static const String today = "TODAY";
  static const String enterMessage = "Enter message...";
  static const String chatGreatThankYou = "Great, thank you!";
  static const String
  chatHiIJustWantedToConfirmOurAppointmentForTomorrowAt10AmDoesThatWorkForYou =
      "Hi, I just wanted to confirm our appointment for tomorrow at 10 AM. "
      "Does that work for you!";
  static const String chatYesThatWorksForMeIllSeeYouTomorrowAt10Am =
      "Yes, that works for me. I'll see you tomorrow at 10 AM.";
  static const String blockThisProviderExclaim = "Block This Provider!";
  static const String
  areYouSureYouWantToBlockThisProviderYouWontBeAbleToSendOrReceiveMessagesWithEachOther =
      "Are you sure you want to block this provider! You won't be able to "
      "send or receive messages with each other.";
  static const String deleteConversationExclaim = "Delete Conversation!";
  static const String
  thisWillPermanentlyRemoveThisConversationFromYourMessages =
      "This will permanently remove this conversation from your messages.";
  static const String youHaveBlockedThisProvider =
      "You have blocked this Provider";
  static const String youCantSendOrReceiveMessagesInThisConversation =
      "You can't send or receive messages in this conversation.";
  static const String unblockProvider = "Unblock Provider";
  static const String unblockThisProviderExclaim = "Unblock This Provider!";
  static const String
  doYouWantToUnblockThisProviderAndAllowMessagesAgain =
      "Do you want to unblock this provider and allow messages again!";
  static const String messagingIsUnavailable = "Messaging is unavailable";
  static const String youCanNoLongerSendMessagesInThisConversation =
      "You can no longer send messages in this conversation.";
  static const String deleteConversation = "Delete Conversation";

  // ==========================================================
  // MY BOOKINGS SCREEN (BOOKINGS_SECTION)
  // (reuses search, bookings from above)
  // ==========================================================
  static const String myBookings = "My Bookings";
  static const String allBookings = "All Bookings";
  static const String pending = "Pending";
  static const String accepted = "Accepted";
  static const String scheduled = "Scheduled";
  static const String inProgress = "In Progress";
  static const String completed = "Completed";
  static const String cancelled = "Cancelled";
  static const String rejected = "Rejected";
  static const String disputed = "Disputed";

  // ==========================================================
  // BOOKING DETAILS SCREEN (BOOKINGS_SECTION — accepted/quote variant)
  // (reuses location, date, time, details, provider, cancel, confirm)
  // ==========================================================
  static const String paymentInfo = "Payment Info";
  static const String serviceCost = "Service Cost";
  static const String declineQuote = "Decline Quote";
  static const String proceedToPay = "Proceed to Pay";
  static const String messageProvider = "Message Provider";
  static const String declineQuoteExclaim = "Decline Quote!";
  static const String
  areYouSureYouWantToDeclineThisQuoteTheBookingWillBeMarkedAsCancelledAndYouWontBeAbleToProceedWithThisQuote =
      "Are you sure you want to decline this quote! The booking will be "
      "marked as Cancelled and you won't be able to proceed with this quote.";

  // ==========================================================
  // BOOKING DETAILS SCREEN — Cancel Booking confirmation sheet
  // ==========================================================
  static const String cancelBookingExclaim = "Cancel Booking!";
  static const String
  areYouSureYouWantToCancelThisBookingYourEligibleBookingAmountWillBeRefundedToYourAccountWithin =
      "Are you sure you want to cancel this booking! Your eligible booking "
      "amount will be refunded to your account within ";
  static const String oneBusinessDay = "1 business day";
  static const String afterTheCancellationIsProcessed =
      " after the cancellation is processed.";

  // ==========================================================
  // BOOKING DETAILS SCREEN — Proceed to Payment confirmation sheet
  // ==========================================================
  static const String proceedToPaymentExclaim = "Proceed to Payment!";
  static const String youReAboutToConfirmThisQuoteFor =
      "You're about to confirm this quote for ";
  static const String
  onceThePaymentIsCompletedTheAgreedPriceWillBeConfirmedForThisBooking =
      ". Once payment is completed, the agreed price will be confirmed "
      "for this booking.";

  // ==========================================================
  // DPO CHECKOUT SCREEN
  // ==========================================================
  static const String dpoCheckOut = "DPO Check out";
  static const String dpoGroup = "DPO GROUP";
  static const String thinkPayments = "Think Payments";
  static const String login = "Login";
  static const String completePaymentWithin = "Complete payment within:";
  static const String paymentReference = "PAYMENT REFERENCE";
  static const String serviceDate = "SERVICE DATE";
  static const String totalUpper = "TOTAL";
  static const String personalDetails = "Personal Details";
  static const String firstName = "First Name";
  static const String lastName = "Last Name";
  static const String countryCode = "Country Code";
  static const String continueToPayment = "Continue to Payment";
  static const String choosePaymentMethod = "Choose Payment Method";
  static const String card = "Card";
  static const String mobile = "Mobile";
  static const String cardHolderName = "Card Holder Name";
  static const String cardNumber = "Card Number";
  static const String mmYy = "MM / YY";
  static const String securityCodeCvv = "Security Code (CVV)";
  static const String saveAllMyDetailsForFuturePayments =
      "Save all my details for future payments";
  static const String iAgreeToDpos = "I agree to DPO's";
  static const String termsAndConditions = "terms and conditions";
  static const String pay = "Pay";
  static const String payViaMobile = "Pay via Mobile";
  static const String backToDetails = "Back to details";
  static const String backLink = "Back";
  static const String paymentSuccessful = "Payment Successful";
  static const String backToBookings = "Back to Bookings";
  static const String ok = "OK";

  // ==========================================================
  // BOOKING CONFIRMED SCREEN
  // ==========================================================
  static const String bookingConfirmed = "Booking confirmed";
  static const String yourSessionWith = "Your session with";
  static const String isScheduled = "is scheduled.";
  static const String seeMyBookings = "See my bookings";
  static const String totalCost = "Total Cost";
  static const String dateTime = "Date & Time";
  static const String cancellationPolicy = "Cancellation Policy";
  static const String cancellationPolicyNotice =
      "You can cancel this booking up to 12 hours before the scheduled service time.";
  static const String reschedule = "Reschedule";
  static const String rescheduleBookingExclaim = "Reschedule Booking!";
  static const String youReAboutToRequestANewDateAndTimeForThisBooking =
      "You're about to request a new date and time for this booking. The change will be sent to the provider for confirmation.";
  static const String youCanCancelOrRequestToReschedule =
      "You can cancel or request to reschedule this booking up to 24 hours before the scheduled service time.";
  static const String rescheduleNow = "Reschedule Now";
  static const String bookingCompletionOtp = "Booking Completion OTP";
  static const String
  aSimpleOtpConfirmationEnsuresOnlyTheCustomerCanAuthorizeServiceCompletion =
      "A simple OTP confirmation ensures only the customer can authorize service completion, reducing disputes and preventing premature completion.";
  static const String completedOn = "Completed On";
  static const String rateAndReview = "Rate & Review";
  static const String reviewed = "Reviewed";
  static const String bookAgain = "Book Again";
  static const String reportAnIssue = "Report an Issue";

  // ==========================================================
  // LEAVE A REVIEW BOTTOM SHEET
  // ==========================================================
  static const String leaveAReview = "Leave a review";
  static const String yourReview = "Your Review";
  static const String shareYourFeedbackAboutTheProvider =
      "Share your feedback about the provider, service quality, and overall experience.";
  static const String submit = "Submit";

  // ==========================================================
  // REPORT AN ISSUE BOTTOM SHEET
  // ==========================================================
  static const String tellUsWhatWentWrongWithYourService =
      "Tell us what went wrong with your service. Our team will review your issue and assist you.";
  static const String issueType = "Issue Type";
  static const String enterYourIssueType = "Enter your Issue Type";
  static const String uploadEvidence = "Upload Evidence";
  static const String uploadImagesHere = "Upload Images Here";
  static const String describeTheIssue = "Describe The Issue";
  static const String pleaseProvideAsMuchDetailAsPossible =
      "Please provide as much detail as possible so we can review your issue quickly.";
  static const String submitIssue = "Submit Issue";
  static const String submitIssueExclaim = "Submit Issue!";
  static const String areYouSureYouWantToSubmitThisIssue =
      "Are you sure you want to submit this issue? Our team will review the details and get back to you.";

  // ==========================================================
  // VERIFY IDENTITY SCREEN (PROVIDER_AUTH_SECTION)
  // ==========================================================
  static const String verifyYourIdentity = "Verify Your Identity";
  static const String
  toKeepYourProviderAccountSecureAndReadyToOfferServicesPleaseVerifyYourIdentity =
      "To keep your provider account secure and ready to offer services, please verify your identity.";
  static const String identificationType = "Identification Type";
  static const String selectYourIdType = "Select your ID type";
  static const String nationalId = "National ID";
  static const String passport = "Passport";
  static const String driversLicense = "Driver's License";
  static const String uploadId = "Upload ID";
  static const String uploadAClearPhotoOfYourId =
      "Upload a clear photo of your ID";
  static const String saveAndContinue = "Save & Continue";

  // ==========================================================
  // CONNECT PAYMENTS SCREEN (PROVIDER_AUTH_SECTION)
  // (reuses saveAndContinue from above)
  // ==========================================================
  static const String connectPayments = "Connect Payments";
  static const String
  connectYourMobileMoneyAccountToReceiveYourNchitoEarningsSecurely =
      "Connect your mobile money account to receive your Nchito earnings "
      "securely.";
  static const String connected = "Connected";
  static const String connect = "Connect";
  static const String aboutNchitoPayments = "About Nchito Payments";
  static const String
  yourNchitoEarningsWillBeTransferredToYourConnectedMobileMoneyAccountAfterEligibleBookingsAreCompleted =
      "Your Nchito earnings will be transferred to your connected mobile "
      "money account after eligible bookings are completed.";
  static const String skipForNow = "Skip for now";

  // ==========================================================
  // LINK PAYMENT ACCOUNT SCREEN (DPO-branded, standalone — not yet wired
  // into a flow; reuses dpoGroup, thinkPayments from DPO CHECKOUT SCREEN)
  // ==========================================================
  static const String linkPaymentAccount = "Link Payment Account";
  static const String secured = "Secured";
  static const String connectYourMobileMoneyAccount =
      "Connect your mobile money account";
  static const String
  payoutsGoOnlyToAVerifiedAccountWeSendA6DigitSmsToConfirmYouOwnTheNumber =
      "Payouts go only to a verified account. We send a 6-digit SMS to "
      "confirm you own the number.";
  static const String yourWalletPinIsNeverCollected =
      "Your wallet PIN is never collected";
  static const String
  weOnlyVerifyNumberOwnershipViaSmsOtpNoPinNoPasswordEver =
      "We only verify number ownership via SMS OTP — no PIN, no password, "
      "ever.";
  static const String selectYourNetwork = "SELECT YOUR NETWORK";
  static const String airtelMoney = "Airtel Money";
  static const String airtelMoneySeries = "097 · 099 series";
  static const String mtnMomo = "MTN MoMo";
  static const String mtnMomoSeries = "096 · 076 series";
  static const String zamtelKwacha = "Zamtel Kwacha";
  static const String zamtelKwachaSeries = "095 series";
  static const String poweredByDpoGroupThinkPayments =
      "Powered by DPO GROUP · Think Payments";

  // ==========================================================
  // PROVIDER HOME SCREEN (PROVIDER_HOME_SECTION)
  // (reuses home, bookings, messages, profile, viewAll from above)
  // ==========================================================
  static const String services = "Services";
  static const String robertsJuniorProviderName = "Roberts Junior";
  static const String todaysOverview = "Today's Overview";
  static const String viewCalendar = "View Calendar";
  static const String pendingRequests = "Pending Requests";
  static const String upcomingBookings = "Upcoming Bookings";
  static const String todaysBookings = "Today's Bookings";
  static const String newBookingRequests = "New Booking Requests";

  // ==========================================================
  // PROVIDER BOOKING DETAILS SCREEN (PROVIDER_BOOKINGS_SECTION)
  // (reuses bookingDetails, location, date, time, details, service,
  // pending from above)
  // ==========================================================
  static const String requestedBy = "Requested By";
  static const String reject = "Reject";
  static const String accept = "Accept";
  static const String messageCustomer = "Message Customer";
  static const String customerDetails = "Customer Details";
  static const String sendQuote = "Send Quote";
  static const String finalServicePrice = "Final Service Price";
  static const String enterFinalPrice = "Enter final price";
  static const String acceptAndSendPricingQuoteExclaim =
      "Accept & Send Pricing Quote!";
  static const String
  areYouSureYouWantToAcceptThisBookingRequestAndSendAPricingQuoteToTheCustomer =
      "Are you sure you want to accept this booking request and send a Pricing "
      "Quote to the customer! The booking will proceed once the customer "
      "reviews and accepts your quote.";
  static const String rejectBookingExclaim = "Reject Booking!";
  static const String
  areYouSureYouWantToRejectThisBookingRequestTheCustomerWillBeNotifiedThatYouReUnableToAcceptTheBooking =
      "Are you sure you want to reject this booking request! The customer will "
      "be notified that you're unable to accept the booking.";
  static const String markAsCompleted = "Mark as Completed";
  static const String markAsCompletedExclaim = "Mark as Completed!";
  static const String confirmServiceCompletion = "Confirm Service Completion";
  static const String
  askTheCustomerToEnterTheOtpToConfirmThatTheServiceHasBeenCompleted =
      "Ask The Customer To Enter The OTP To Confirm That The Service Has Been Completed.";
  static const String customerOtp = "Customer OTP";
  static const String verifyOtp = "Verify OTP";
  static const String
  areYouSureYouWantToMarkThisServiceAsCompletedThisWillUpdateTheBookingStatusToCompleted =
      "Are you sure you want to mark this service as completed! This will update the booking status to Completed.";
  static const String
  theProviderCanOnlyCompleteTheBookingAfterEnteringTheCustomerProvidedOtp =
      "The provider can only complete the booking after entering the customer-provided OTP, ensuring the customer has confirmed the service completion.";
  static const String platformFee5Percent = "Platform Fee (5%)";
  static const String youCanceledThisBooking = "You Canceled This Booking";
  static const String customerCanceledThisBooking =
      "Customer Canceled This Booking";
  static const String on27Aug2026 = "On 27 Aug 2026 – 06:20 AM";
  static const String noReviewYet = "No Review Yet";

  // ==========================================================
  // MY SERVICES SCREEN (PROVIDER_SERVICES_SECTION)
  // ==========================================================
  static const String myServices = "My Services";
  static const String noServicesYet = "No Services Yet";
  static const String
  youHaventAddedAnyServicesToYourProfileYetCreateYourFirstServiceToStartReceivingBookingRequests =
      "You haven't added any services to your profile yet. Create your "
      "first service to start receiving booking requests.";
  static const String addService = "Add Service";

  // ==========================================================
  // PROVIDER PROFILE SCREEN (PROVIDER_PROFILE_SECTION)
  // (reuses profile, robertsJuniorProviderName, verifyYourIdentity, more,
  // myProfile, accountSetting, termsAndCondition, privacyPolicy,
  // legalAndCompanyInfo, helpAndSupport, logOut from above)
  // ==========================================================
  static const String completeYourAccount = "COMPLETE YOUR ACCOUNT";
  static const String activateYourPayment = "Activate your payment";
  static const String setAvailability = "Set availability";
  static const String general = "General";
  static const String availability = "Availability";
  static const String earnings = "Earnings";
}
