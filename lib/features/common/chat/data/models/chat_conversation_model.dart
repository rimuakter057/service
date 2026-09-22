import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/messages/presentation/widgets/message_sample_data.dart';

class ChatParticipantModel {
  final String id;
  final String? fullName;
  final String? avatar;
  final String? role;
  final bool isVerified;
  final double? ratingAverage;
  final int? ratingCount;

  /// The provider-profile id (distinct from this user's own id) — needed
  /// wherever a screen wants the provider record, not just the user.
  final String? providerId;

  const ChatParticipantModel({
    required this.id,
    this.fullName,
    this.avatar,
    this.role,
    this.isVerified = false,
    this.ratingAverage,
    this.ratingCount,
    this.providerId,
  });

  factory ChatParticipantModel.fromJson(Map<String, dynamic> json) {
    return ChatParticipantModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString(),
      avatar: json['avatar']?.toString(),
      role: json['role']?.toString(),
      isVerified: json['is_verified'] as bool? ?? false,
      ratingAverage: (json['rating_average'] as num?)?.toDouble(),
      ratingCount: (json['rating_count'] as num?)?.toInt(),
      providerId: json['provider_id']?.toString(),
    );
  }
}

/// `block_state` on a conversation — who's blocked whom, and whether
/// sending is currently allowed. Confirmed live.
class ChatBlockStateModel {
  final bool blockedByMe;
  final bool blockedByThem;
  final bool canSendMessage;
  final String? notice;

  const ChatBlockStateModel({
    this.blockedByMe = false,
    this.blockedByThem = false,
    this.canSendMessage = true,
    this.notice,
  });

  factory ChatBlockStateModel.fromJson(Map<String, dynamic> json) {
    return ChatBlockStateModel(
      blockedByMe: json['blocked_by_me'] as bool? ?? false,
      blockedByThem: json['blocked_by_them'] as bool? ?? false,
      canSendMessage: json['can_send_message'] as bool? ?? true,
      notice: json['notice']?.toString(),
    );
  }
}

class ChatConversationModel {
  final String id;
  final ChatParticipantModel? otherUser;
  final String? booking;
  final String? bookingReference;
  final String lastMessagePreview;
  final String? lastMessageAt;
  final int unreadCount;
  final int ongoingBookings;
  final ChatBlockStateModel blockState;
  final bool isArchived;
  final String? createdAt;

  const ChatConversationModel({
    required this.id,
    this.otherUser,
    this.booking,
    this.bookingReference,
    this.lastMessagePreview = '',
    this.lastMessageAt,
    this.unreadCount = 0,
    this.ongoingBookings = 0,
    this.blockState = const ChatBlockStateModel(),
    this.isArchived = false,
    this.createdAt,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return ChatConversationModel(
      id: data['id']?.toString() ?? '',
      otherUser: data['other_user'] is Map<String, dynamic>
          ? ChatParticipantModel.fromJson(data['other_user'] as Map<String, dynamic>)
          : null,
      booking: data['booking']?.toString(),
      bookingReference: data['booking_reference']?.toString(),
      lastMessagePreview: data['last_message_preview']?.toString() ?? '',
      lastMessageAt: data['last_message_at']?.toString(),
      unreadCount: (data['unread_count'] as num?)?.toInt() ?? 0,
      ongoingBookings: (data['ongoing_bookings'] as num?)?.toInt() ?? 0,
      blockState: data['block_state'] is Map<String, dynamic>
          ? ChatBlockStateModel.fromJson(data['block_state'] as Map<String, dynamic>)
          : const ChatBlockStateModel(),
      isArchived: data['is_archived'] as bool? ?? false,
      createdAt: data['created_at']?.toString(),
    );
  }

  static String _formattedTimeLabel(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        final period = dt.hour >= 12 ? 'PM' : 'AM';
        int displayHour = dt.hour % 12;
        if (displayHour == 0) displayHour = 12;
        final minuteStr = dt.minute.toString().padLeft(2, '0');
        return '$displayHour:$minuteStr $period';
      }
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month - 1]}';
    } catch (_) {
      return raw;
    }
  }

  /// Maps to the presentation-layer [MessageData] the Messages/Chat
  /// screens already know how to render.
  MessageData toMessageData() {
    return MessageData(
      id: id,
      avatarAsset: (otherUser?.avatar != null && otherUser!.avatar!.isNotEmpty)
          ? otherUser!.avatar!
          : AssetsPath.avatarUser,
      name: otherUser?.fullName?.isNotEmpty == true ? otherUser!.fullName! : 'User',
      lastMessage: lastMessagePreview.isNotEmpty
          ? lastMessagePreview
          : 'Start the conversation',
      timeLabel: _formattedTimeLabel(lastMessageAt),
      unreadCount: unreadCount,
      rating: otherUser?.ratingAverage != null
          ? otherUser!.ratingAverage!.toStringAsFixed(1)
          : null,
      isMessagingUnavailable: blockState.blockedByThem,
    );
  }
}

class ChatConversationsResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<ChatConversationModel> results;

  const ChatConversationsResponseModel({
    required this.count,
    this.next,
    this.previous,
    this.results = const [],
  });

  factory ChatConversationsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = (json['results'] ?? json['data']) as List<dynamic>? ?? const [];
    return ChatConversationsResponseModel(
      count: (json['count'] as num?)?.toInt() ?? rawList.length,
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
      results: rawList
          .map((e) => ChatConversationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
