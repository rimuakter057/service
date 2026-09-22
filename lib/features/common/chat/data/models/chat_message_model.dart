import 'chat_conversation_model.dart';
import 'package:nchito/features/user/messages/presentation/widgets/chat_sample_data.dart';

class ChatMessageModel {
  final String id;
  final String? conversation;
  final ChatParticipantModel? senderDetail;
  final String kind;
  final String body;
  final String? attachment;
  final bool isRead;
  final String? readAt;
  final bool isMine;
  final String? createdAt;

  const ChatMessageModel({
    required this.id,
    this.conversation,
    this.senderDetail,
    this.kind = 'text',
    this.body = '',
    this.attachment,
    this.isRead = false,
    this.readAt,
    this.isMine = false,
    this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return ChatMessageModel(
      id: data['id']?.toString() ?? '',
      conversation: data['conversation']?.toString(),
      senderDetail: data['sender_detail'] is Map<String, dynamic>
          ? ChatParticipantModel.fromJson(data['sender_detail'] as Map<String, dynamic>)
          : null,
      kind: data['kind']?.toString() ?? 'text',
      body: data['body']?.toString() ?? '',
      attachment: data['attachment']?.toString(),
      isRead: data['is_read'] as bool? ?? false,
      readAt: data['read_at']?.toString(),
      // The API marks this per-message (`is_mine`) — no need to compare
      // against a locally-stored current-user id.
      isMine: data['is_mine'] as bool? ?? false,
      createdAt: data['created_at']?.toString(),
    );
  }

  static String _formattedTime(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      int displayHour = dt.hour % 12;
      if (displayHour == 0) displayHour = 12;
      final minuteStr = dt.minute.toString().padLeft(2, '0');
      return '$displayHour:$minuteStr $period';
    } catch (_) {
      return raw;
    }
  }

  ChatMessageData toChatMessageData() {
    return ChatMessageData(
      text: body,
      timeLabel: _formattedTime(createdAt),
      isMine: isMine,
    );
  }
}

class ChatMessagesResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<ChatMessageModel> results;

  const ChatMessagesResponseModel({
    required this.count,
    this.next,
    this.previous,
    this.results = const [],
  });

  factory ChatMessagesResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = (json['results'] ?? json['data']) as List<dynamic>? ?? const [];
    return ChatMessagesResponseModel(
      count: (json['count'] as num?)?.toInt() ?? rawList.length,
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
      results: rawList
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
