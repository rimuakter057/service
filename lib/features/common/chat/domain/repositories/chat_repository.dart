import '../../data/models/chat_conversation_model.dart';
import '../../data/models/chat_message_model.dart';

abstract class ChatRepository {
  Future<ChatConversationsResponseModel> getConversations({
    required bool isProvider,
    int? page,
  });

  Future<int> getUnreadCount({required bool isProvider});

  Future<ChatConversationModel> getConversationDetail(
    String conversationId, {
    required bool isProvider,
  });

  Future<ChatConversationModel> createConversation({
    required bool isProvider,
    required String participantId,
    String? bookingId,
  });

  Future<void> deleteConversation(String conversationId, {required bool isProvider});

  Future<void> archiveConversation(String conversationId, {required bool isProvider});

  Future<ChatConversationModel> blockConversation(
    String conversationId, {
    required bool isProvider,
  });

  Future<ChatConversationModel> unblockConversation(
    String conversationId, {
    required bool isProvider,
  });

  Future<void> markRead(String conversationId, {required bool isProvider});

  Future<ChatMessagesResponseModel> getMessages(
    String conversationId, {
    required bool isProvider,
    int? page,
  });

  Future<ChatMessageModel> sendMessage(
    String conversationId, {
    required bool isProvider,
    required String body,
  });
}
