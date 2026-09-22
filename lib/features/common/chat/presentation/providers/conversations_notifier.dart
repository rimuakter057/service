import 'package:flutter/material.dart';
import 'package:nchito/core/errors/failures.dart';
import '../../data/models/chat_conversation_model.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';

/// The Messages list (conversations + unread badge). Mirrors
/// `BaseCompanyNotifier`/`BaseFaqNotifier` — one shared implementation,
/// a trivial `isProvider` subclass per role.
class BaseConversationsNotifier extends ChangeNotifier {
  BaseConversationsNotifier({
    ChatRepository? repository,
    required this.isProvider,
  }) : _repository = repository ?? ChatRepositoryImpl();

  final ChatRepository _repository;
  final bool isProvider;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ChatConversationModel> _conversations = [];
  List<ChatConversationModel> get conversations => _conversations;

  int _unreadTotal = 0;
  int get unreadTotal => _unreadTotal;

  bool get isEmpty => !_isLoading && _conversations.isEmpty;

  Future<void> fetchConversations({bool refresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _repository.getConversations(isProvider: isProvider);
      _conversations = res.results;
      _errorMessage = null;
    } on Failure catch (f) {
      _errorMessage = f.message;
    } catch (e) {
      _errorMessage = 'Failed to load conversations. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUnreadCount() async {
    _unreadTotal = await _repository.getUnreadCount(isProvider: isProvider);
    notifyListeners();
  }

  /// Get-or-create a conversation, used by "Message Customer"/"Message
  /// Provider" buttons that don't already know a conversation id.
  Future<ChatConversationModel?> startConversation({
    required String participantId,
    String? bookingId,
  }) async {
    try {
      final conversation = await _repository.createConversation(
        isProvider: isProvider,
        participantId: participantId,
        bookingId: bookingId,
      );
      final index = _conversations.indexWhere((c) => c.id == conversation.id);
      if (index == -1) {
        _conversations.insert(0, conversation);
      } else {
        _conversations[index] = conversation;
      }
      notifyListeners();
      return conversation;
    } on Failure catch (f) {
      _errorMessage = f.message;
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = 'Failed to start conversation. Please try again.';
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteConversation(String conversationId) async {
    try {
      await _repository.deleteConversation(conversationId, isProvider: isProvider);
      _conversations.removeWhere((c) => c.id == conversationId);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}

class CustomerConversationsNotifier extends BaseConversationsNotifier {
  CustomerConversationsNotifier({super.repository}) : super(isProvider: false);
}

class ProviderConversationsNotifier extends BaseConversationsNotifier {
  ProviderConversationsNotifier({super.repository}) : super(isProvider: true);
}
