import 'package:nchito/core/utils/app_text/app_text.dart';

/// One message bubble in a chat thread.
class ChatMessageData {
  final String text;
  final String timeLabel;
  final bool isMine;

  const ChatMessageData({
    required this.text,
    required this.timeLabel,
    this.isMine = false,
  });
}

/// Placeholder thread content for the Chat screen until it's wired to
/// real data.
const List<ChatMessageData> chatSampleMessages = [
  ChatMessageData(
    text: AppText.chatGreatThankYou,
    timeLabel: '04:45 PM',
  ),
  ChatMessageData(
    text: AppText
        .chatHiIJustWantedToConfirmOurAppointmentForTomorrowAt10AmDoesThatWorkForYou,
    timeLabel: '04:45 PM',
    isMine: true,
  ),
  ChatMessageData(
    text: AppText.chatYesThatWorksForMeIllSeeYouTomorrowAt10Am,
    timeLabel: '04:45 PM',
  ),
];
