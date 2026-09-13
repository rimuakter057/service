import 'package:nchito/core/utils/app_text/app_text.dart';

/// One row of notification data shown on the Notifications screen.
class NotificationData {
  final String message;
  final String dateLabel;
  final bool isUnread;

  const NotificationData({
    required this.message,
    required this.dateLabel,
    this.isUnread = false,
  });
}

/// Placeholder content for the Notifications screen until it's wired to
/// real data.
const List<NotificationData> notificationSampleData = [
  NotificationData(
    message: AppText.notifYourBookingWithRobertsJuniorHasBeenAccepted,
    dateLabel: '11 March 2026',
    isUnread: true,
  ),
  NotificationData(
    message: AppText.notifYourBookingRequestWasDeclinedByTheProvider,
    dateLabel: '27 March 2026',
    isUnread: true,
  ),
  NotificationData(
    message: AppText.notifYourBookingHasBeenCancelled,
    dateLabel: '28 March 2026',
  ),
  NotificationData(
    message: AppText.notifYourServiceIsScheduledForTomorrowAt1000Am,
    dateLabel: '06 June 2026',
  ),
  NotificationData(
    message: AppText.notifYourProviderHasMarkedTheServiceAsCompleted,
    dateLabel: '11 April 2026',
  ),
  NotificationData(
    message: AppText.notifYourEligibleRefundHasBeenProcessed,
    dateLabel: '11 April 2026',
  ),
  NotificationData(
    message: AppText.notifThereSAnUpdateRegardingYourReportedIssue,
    dateLabel: '11 April 2026',
  ),
  NotificationData(
    message: AppText.notifRobertsJuniorSentYouANewMessage,
    dateLabel: '11 April 2026',
  ),
];
