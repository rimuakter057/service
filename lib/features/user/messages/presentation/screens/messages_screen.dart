import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nchito/features/common/common_widgets/app_bottom_nav_bar/app_bottom_nav_bar.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/features/common/common_widgets/messages_search_field/messages_search_field.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/features/common/chat/presentation/providers/conversations_notifier.dart';
import 'package:nchito/features/user/messages/presentation/screens/chat_screen.dart';
import 'package:nchito/features/user/messages/presentation/widgets/message_list_tile.dart';
import 'package:nchito/features/user/messages/presentation/widgets/message_sample_data.dart';

/// User Messages screen — search bar plus the list of conversations, reached
/// from the bottom nav's "Messages" tab.
class MessagesScreen extends StatefulWidget {
  static const String routeName = '/messages';

  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerConversationsNotifier>().fetchConversations();
    });
  }

  List<MessageData> _filtered(List<MessageData> conversations) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return conversations;
    return conversations
        .where((conversation) => conversation.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopAppbar(title: AppText.messages),
            Expanded(
              child: Consumer<CustomerConversationsNotifier>(
                builder: (context, notifier, child) {
                  final conversations = _filtered(
                    notifier.conversations.map((c) => c.toMessageData()).toList(),
                  );
                  final isLoadingInitial =
                      notifier.isLoading && notifier.conversations.isEmpty;
                  final hasError =
                      notifier.errorMessage != null && notifier.conversations.isEmpty;
                  final isEmpty = !isLoadingInitial && !hasError && conversations.isEmpty;

                  final totalItems =
                      1 + ((isLoadingInitial || hasError || isEmpty) ? 1 : conversations.length);

                  return RefreshIndicator(
                    color: AppColors.brandPrimary,
                    onRefresh: () => notifier.fetchConversations(refresh: true),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(20),
                        vertical: ResponsiveHelper.padding(8),
                      ),
                      itemCount: totalItems,
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

                        if (isLoadingInitial) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.brandPrimary,
                              ),
                            ),
                          );
                        }

                        if (hasError) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.padding(40),
                            ),
                            child: Center(
                              child: Text(
                                notifier.errorMessage!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.red,
                                  fontSize: ResponsiveHelper.fontSize(14),
                                ),
                              ),
                            ),
                          );
                        }

                        if (isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.padding(40),
                            ),
                            child: Center(
                              child: Text(
                                'No conversations yet.',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(14),
                                  color: AppColors.textSecondary,
                                ),
                              ),
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
                            ChatScreen.routeName,
                            extra: conversation,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 3),
    );
  }
}
