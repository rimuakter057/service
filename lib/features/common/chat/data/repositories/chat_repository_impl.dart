import 'package:nchito/core/errors/exceptions.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/chat_conversation_model.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({ChatRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ChatRemoteDataSourceImpl();

  final ChatRemoteDataSource _remoteDataSource;

  @override
  Future<ChatConversationsResponseModel> getConversations({
    required bool isProvider,
    int? page,
  }) async {
    try {
      return await _remoteDataSource.getConversations(isProvider: isProvider, page: page);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load conversations. Please try again.');
    }
  }

  @override
  Future<int> getUnreadCount({required bool isProvider}) async {
    try {
      return await _remoteDataSource.getUnreadCount(isProvider: isProvider);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<ChatConversationModel> getConversationDetail(
    String conversationId, {
    required bool isProvider,
  }) async {
    try {
      return await _remoteDataSource.getConversationDetail(
        conversationId,
        isProvider: isProvider,
      );
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load conversation. Please try again.');
    }
  }

  @override
  Future<ChatConversationModel> createConversation({
    required bool isProvider,
    required String participantId,
    String? bookingId,
  }) async {
    try {
      return await _remoteDataSource.createConversation(
        isProvider: isProvider,
        participantId: participantId,
        bookingId: bookingId,
      );
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to start conversation. Please try again.');
    }
  }

  @override
  Future<void> deleteConversation(
    String conversationId, {
    required bool isProvider,
  }) async {
    try {
      await _remoteDataSource.deleteConversation(conversationId, isProvider: isProvider);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to delete conversation. Please try again.');
    }
  }

  @override
  Future<void> archiveConversation(
    String conversationId, {
    required bool isProvider,
  }) async {
    try {
      await _remoteDataSource.archiveConversation(conversationId, isProvider: isProvider);
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to archive conversation. Please try again.');
    }
  }

  @override
  Future<ChatConversationModel> blockConversation(
    String conversationId, {
    required bool isProvider,
  }) async {
    try {
      return await _remoteDataSource.blockConversation(
        conversationId,
        isProvider: isProvider,
      );
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to block. Please try again.');
    }
  }

  @override
  Future<ChatConversationModel> unblockConversation(
    String conversationId, {
    required bool isProvider,
  }) async {
    try {
      return await _remoteDataSource.unblockConversation(
        conversationId,
        isProvider: isProvider,
      );
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to unblock. Please try again.');
    }
  }

  @override
  Future<void> markRead(String conversationId, {required bool isProvider}) async {
    try {
      await _remoteDataSource.markRead(conversationId, isProvider: isProvider);
    } on AppException catch (_) {
      // Read receipts are best-effort — a failed mark-as-read shouldn't
      // block the thread from opening.
    } catch (_) {}
  }

  @override
  Future<ChatMessagesResponseModel> getMessages(
    String conversationId, {
    required bool isProvider,
    int? page,
  }) async {
    try {
      return await _remoteDataSource.getMessages(
        conversationId,
        isProvider: isProvider,
        page: page,
      );
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to load messages. Please try again.');
    }
  }

  @override
  Future<ChatMessageModel> sendMessage(
    String conversationId, {
    required bool isProvider,
    required String body,
  }) async {
    try {
      return await _remoteDataSource.sendMessage(
        conversationId,
        isProvider: isProvider,
        body: body,
      );
    } on AppException catch (e) {
      throw Failure.fromException(e);
    } catch (e) {
      throw UnknownFailure('Failed to send message. Please try again.');
    }
  }
}
