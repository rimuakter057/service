import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/messages/presentation/widgets/message_sample_data.dart';

/// Provider message conversations matching the provider design specifications
/// (no badges).
const List<MessageData> providerMessageConversations = [
  MessageData(
    avatarAsset: AssetsPath.messagesAvatarRobertsJunior,
    name: AppText.robertsJunior,
    lastMessage: AppText.robertsJuniorLastMessage,
    timeLabel: '25 min ago',
    isSelected: true,
    rating: '4.8',
  ),
  MessageData(
    avatarAsset: AssetsPath.messagesAvatarOliviaMartinez,
    name: AppText.oliviaMartinez,
    lastMessage: AppText.oliviaMartinezLastMessage,
    timeLabel: '25 min ago',
    unreadCount: 3,
  ),
  MessageData(
    avatarAsset: AssetsPath.messagesAvatarMichaelSmith,
    name: AppText.michaelSmith,
    lastMessage: AppText.michaelSmithLastMessage,
    timeLabel: '04:45 PM',
    unreadCount: 0,
    isMessagingUnavailable: true,
  ),
  MessageData(
    avatarAsset: AssetsPath.messagesAvatarDavidKim,
    name: AppText.davidKim,
    lastMessage: AppText.davidKimLastMessage,
    timeLabel: '06:55 PM',
    unreadCount: 0,
  ),
  MessageData(
    avatarAsset: AssetsPath.messagesAvatarSophiaWhite,
    name: AppText.sophiaWhite,
    lastMessage: AppText.sophiaWhiteLastMessage,
    timeLabel: '01:45 AM',
    unreadCount: 0,
  ),
];
