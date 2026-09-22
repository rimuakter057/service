import 'package:nchito/core/network/api_client.dart';
import 'package:nchito/core/network/api_url.dart';
import '../models/chat_conversation_model.dart';
import '../models/chat_message_model.dart';

/// Customer and provider chat are the same resource shape under two role
/// prefixes (confirmed live) — every method takes `isProvider` to pick the
/// right one, mirroring `CmsSupportRemoteDataSource`.
abstract class ChatRemoteDataSource {
  Future<ChatConversationsResponseModel> getConversations({
    required bool isProvider,
    int? page,
  });

  Future<int> getUnreadCount({required bool isProvider});

  Future<ChatConversationModel> getConversationDetail(
    String conversationId, {
    required bool isProvider,
  });

  /// Get-or-create — confirmed live (`"message":"Conversation ready."`).
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

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  String _conversations(bool isProvider) =>
      isProvider ? ApiUrl.providerChatConversations : ApiUrl.customerChatConversations;
  String _unreadCount(bool isProvider) =>
      isProvider ? ApiUrl.providerChatUnreadCount : ApiUrl.customerChatUnreadCount;
  String _detail(bool isProvider, String id) => isProvider
      ? ApiUrl.providerChatConversationDetails(id)
      : ApiUrl.customerChatConversationDetails(id);
  String _archive(bool isProvider, String id) => isProvider
      ? ApiUrl.providerChatConversationArchive(id)
      : ApiUrl.customerChatConversationArchive(id);
  String _block(bool isProvider, String id) => isProvider
      ? ApiUrl.providerChatConversationBlock(id)
      : ApiUrl.customerChatConversationBlock(id);
  String _unblock(bool isProvider, String id) => isProvider
      ? ApiUrl.providerChatConversationUnblock(id)
      : ApiUrl.customerChatConversationUnblock(id);
  String _read(bool isProvider, String id) => isProvider
      ? ApiUrl.providerChatConversationRead(id)
      : ApiUrl.customerChatConversationRead(id);
  String _messages(bool isProvider, String id) => isProvider
      ? ApiUrl.providerChatMessages(id)
      : ApiUrl.customerChatMessages(id);

  @override
  Future<ChatConversationsResponseModel> getConversations({
    required bool isProvider,
    int? page,
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;

    final response = await _apiClient.get(
      _conversations(isProvider),
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ChatConversationsResponseModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<int> getUnreadCount({required bool isProvider}) async {
    final response = await _apiClient.get(_unreadCount(isProvider));
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      final data = responseData['data'];
      if (data is Map<String, dynamic>) {
        return (data['unread'] as num?)?.toInt() ?? 0;
      }
      return (responseData['unread'] as num?)?.toInt() ?? 0;
    }
    return 0;
  }

  @override
  Future<ChatConversationModel> getConversationDetail(
    String conversationId, {
    required bool isProvider,
  }) async {
    final response = await _apiClient.get(_detail(isProvider, conversationId));
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ChatConversationModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<ChatConversationModel> createConversation({
    required bool isProvider,
    required String participantId,
    String? bookingId,
  }) async {
    final body = <String, dynamic>{
      'participant': participantId,
      if (bookingId != null && bookingId.isNotEmpty) 'booking': bookingId,
    };

    final response = await _apiClient.post(_conversations(isProvider), data: body);
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ChatConversationModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<void> deleteConversation(
    String conversationId, {
    required bool isProvider,
  }) async {
    await _apiClient.delete(_detail(isProvider, conversationId));
  }

  @override
  Future<void> archiveConversation(
    String conversationId, {
    required bool isProvider,
  }) async {
    await _apiClient.post(_archive(isProvider, conversationId));
  }

  @override
  Future<ChatConversationModel> blockConversation(
    String conversationId, {
    required bool isProvider,
  }) async {
    final response = await _apiClient.post(_block(isProvider, conversationId));
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ChatConversationModel.fromJson(responseData);
    }
    return ChatConversationModel(id: conversationId);
  }

  @override
  Future<ChatConversationModel> unblockConversation(
    String conversationId, {
    required bool isProvider,
  }) async {
    final response = await _apiClient.post(_unblock(isProvider, conversationId));
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ChatConversationModel.fromJson(responseData);
    }
    return ChatConversationModel(id: conversationId);
  }

  @override
  Future<void> markRead(String conversationId, {required bool isProvider}) async {
    await _apiClient.post(_read(isProvider, conversationId));
  }

  @override
  Future<ChatMessagesResponseModel> getMessages(
    String conversationId, {
    required bool isProvider,
    int? page,
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;

    final response = await _apiClient.get(
      _messages(isProvider, conversationId),
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ChatMessagesResponseModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }

  @override
  Future<ChatMessageModel> sendMessage(
    String conversationId, {
    required bool isProvider,
    required String body,
  }) async {
    final response = await _apiClient.post(
      _messages(isProvider, conversationId),
      data: {'body': body.trim()},
    );
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ChatMessageModel.fromJson(responseData);
    }
    throw FormatException('Unexpected response format: $responseData');
  }
}
