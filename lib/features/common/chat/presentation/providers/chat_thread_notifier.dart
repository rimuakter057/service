import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/chat_conversation_model.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';

/// A single chat thread — its messages, plus block/unblock/delete. Mirrors
/// `BaseConversationsNotifier`'s role-subclassing.
class BaseChatThreadNotifier extends ChangeNotifier {
  BaseChatThreadNotifier({
    ChatRepository? repository,
    required this.isProvider,
  }) : _repository = repository ?? ChatRepositoryImpl();

  final ChatRepository _repository;
  final bool isProvider;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSending = false;
  bool get isSending => _isSending;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _actionErrorMessage;
  String? get actionErrorMessage => _actionErrorMessage;

  List<ChatMessageModel> _messages = [];
  List<ChatMessageModel> get messages => _messages;

  ChatConversationModel? _conversation;
  ChatConversationModel? get conversation => _conversation;

  String? _currentConversationId;
  String? get currentConversationId => _currentConversationId;

  Future<void> fetchMessages(String conversationId, {bool refresh = false}) async {
    if (_currentConversationId == conversationId && _messages.isNotEmpty && !refresh) {
      return;
    }

    _currentConversationId = conversationId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _repository.getMessages(conversationId, isProvider: isProvider);
      // Oldest first, so the chat reads top-to-bottom like the design.
      _messages = res.results.reversed.toList();
      _errorMessage = null;
      // Best-effort — opening the thread marks it read.
      unawaited(_repository.markRead(conversationId, isProvider: isProvider));
    } on Failure catch (f) {
      _errorMessage = f.message;
    } catch (e) {
      _errorMessage = 'Failed to load messages. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchConversationDetail(String conversationId) async {
    try {
      _conversation = await _repository.getConversationDetail(
        conversationId,
        isProvider: isProvider,
      );
      notifyListeners();
    } catch (_) {
      // The thread still works off the [MessageData] passed on navigation
      // if this supplementary fetch fails.
    }
  }

  Future<bool> sendMessage(String conversationId, String body) async {
    if (body.trim().isEmpty) return false;
    _isSending = true;
    notifyListeners();

    try {
      final message = await _repository.sendMessage(
        conversationId,
        isProvider: isProvider,
        body: body,
      );
      _messages.add(message);
      return true;
    } on Failure catch (f) {
      _actionErrorMessage = f.message;
      return false;
    } catch (e) {
      _actionErrorMessage = 'Failed to send message. Please try again.';
      return false;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<bool> block(String conversationId) async {
    return _executeAction(
      () => _repository.blockConversation(conversationId, isProvider: isProvider),
      defaultError: 'Failed to block. Please try again.',
    );
  }

  Future<bool> unblock(String conversationId) async {
    return _executeAction(
      () => _repository.unblockConversation(conversationId, isProvider: isProvider),
      defaultError: 'Failed to unblock. Please try again.',
    );
  }

  Future<bool> _executeAction(
    Future<ChatConversationModel> Function() action, {
    required String defaultError,
  }) async {
    _isActionLoading = true;
    _actionErrorMessage = null;
    notifyListeners();

    try {
      _conversation = await action();
      _actionErrorMessage = null;
      return true;
    } on Failure catch (f) {
      _actionErrorMessage = f.message;
      return false;
    } catch (e) {
      _actionErrorMessage = defaultError;
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteConversation(String conversationId) async {
    _isActionLoading = true;
    _actionErrorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteConversation(conversationId, isProvider: isProvider);
      _actionErrorMessage = null;
      return true;
    } on Failure catch (f) {
      _actionErrorMessage = f.message;
      return false;
    } catch (e) {
      _actionErrorMessage = 'Failed to delete conversation. Please try again.';
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _messages = [];
    _conversation = null;
    _currentConversationId = null;
    _errorMessage = null;
    _actionErrorMessage = null;
    _isLoading = false;
    _isSending = false;
    _isActionLoading = false;
    notifyListeners();
  }
}

class CustomerChatThreadNotifier extends BaseChatThreadNotifier {
  CustomerChatThreadNotifier({super.repository}) : super(isProvider: false);
}

class ProviderChatThreadNotifier extends BaseChatThreadNotifier {
  ProviderChatThreadNotifier({super.repository}) : super(isProvider: true);
}
