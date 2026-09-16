import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_bottom_nav_bar/app_bottom_nav_bar.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/features/common/common_widgets/messages_search_field/messages_search_field.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/provider/messages/presentation/screens/provider_chat_screen.dart';
import 'package:nchito/features/user/messages/presentation/widgets/message_list_tile.dart';
import 'package:nchito/features/user/messages/presentation/widgets/message_sample_data.dart';

/// Provider Messages screen — search bar plus conversation list with
/// [ProviderBottomNavBar], navigating to [ProviderChatScreen].
class ProviderMessagesScreen extends StatefulWidget {
  static const String routeName = '/provider/messages';

  const ProviderMessagesScreen({super.key});

  @override
  State<ProviderMessagesScreen> createState() => _ProviderMessagesScreenState();
}

class _ProviderMessagesScreenState extends State<ProviderMessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  List<MessageData> get _filteredConversations {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return messageConversations;
    return messageConversations
        .where(
          (conversation) => conversation.name.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversations = _filteredConversations;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopAppbar(title: AppText.messages),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(20),
                  vertical: ResponsiveHelper.padding(8),
                ),
                itemCount: conversations.length + 1,
                separatorBuilder: (_, index) =>
                    SizedBox(height: ResponsiveHelper.spacing(12)),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: ResponsiveHelper.spacing(2),
                      ),
                      child: MessagesSearchField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _query = value),
                      ),
                    );
                  }
                  final conversation = conversations[index - 1];
                  return MessageListTile(
                    avatarAsset: conversation.avatarAsset,
                    name: conversation.name,
                    lastMessage: conversation.lastMessage,
                    timeLabel: conversation.timeLabel,
                    unreadCount: conversation.unreadCount,
                    isSelected: conversation.isSelected,
                    onTap: () => context.push(
                      ProviderChatScreen.routeName,
                      extra: conversation,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ProviderBottomNavBar(currentIndex: 3),
    );
  }
}
