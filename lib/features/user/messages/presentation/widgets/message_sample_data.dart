import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// One row of conversation data shown on the Messages screen.
class MessageData {
  final String avatarAsset;
  final String name;
  final String lastMessage;
  final String timeLabel;
  final int unreadCount;
  final bool isSelected;

  const MessageData({
    required this.avatarAsset,
    required this.name,
    required this.lastMessage,
    required this.timeLabel,
    this.unreadCount = 0,
    this.isSelected = false,
  });
}

/// Placeholder content for the Messages screen until it's wired to real data.
const List<MessageData> messageConversations = [
  MessageData(
    avatarAsset: AssetsPath.messagesAvatarRobertsJunior,
    name: AppText.robertsJunior,
    lastMessage: AppText.robertsJuniorLastMessage,
    timeLabel: '25 ${AppText.minAgo}',
    isSelected: true,
  ),
  MessageData(
    avatarAsset: AssetsPath.messagesAvatarOliviaMartinez,
    name: AppText.oliviaMartinez,
    lastMessage: AppText.oliviaMartinezLastMessage,
    timeLabel: '25 ${AppText.minAgo}',
    unreadCount: 3,
  ),
  MessageData(
    avatarAsset: AssetsPath.messagesAvatarMichaelSmith,
    name: AppText.michaelSmith,
    lastMessage: AppText.michaelSmithLastMessage,
    timeLabel: '04:45 PM',
  ),
  MessageData(
    avatarAsset: AssetsPath.messagesAvatarDavidKim,
    name: AppText.davidKim,
    lastMessage: AppText.davidKimLastMessage,
    timeLabel: '05:55 PM',
  ),
  MessageData(
    avatarAsset: AssetsPath.messagesAvatarSophiaWhite,
    name: AppText.sophiaWhite,
    lastMessage: AppText.sophiaWhiteLastMessage,
    timeLabel: '01:45 AM',
  ),
];
