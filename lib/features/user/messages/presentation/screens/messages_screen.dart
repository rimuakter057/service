import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_bottom_nav_bar/app_bottom_nav_bar.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/messages/presentation/screens/chat_screen.dart';
import 'package:nchito/features/user/messages/presentation/widgets/message_list_tile.dart';
import 'package:nchito/features/user/messages/presentation/widgets/message_sample_data.dart';

/// Messages screen — search bar plus the list of conversations, reached
/// from the bottom nav's "Messages" tab.
class MessagesScreen extends StatefulWidget {
  static const String routeName = '/messages';
  static const String providerRouteName = '/provider/messages';

  final bool isProvider;

  const MessagesScreen({super.key, this.isProvider = false});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
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
      backgroundColor: AppColors.bgApp,
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
                      child: _MessagesSearchField(
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
                      ChatScreen.routeName,
                      extra: conversation,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.isProvider
          ? const ProviderBottomNavBar(currentIndex: 3)
          : const UserBottomNavBar(currentIndex: 3),
    );
  }
}

/// Plain search input for the Messages list — search icon on the left over
/// a translucent fill, matching this screen's design (distinct from the
/// colored-suffix [AppSearchField] used on Home/Explore).
class _MessagesSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _MessagesSearchField({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.height(44),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(16)),
      decoration: BoxDecoration(
        color: AppColors.bgOverlay.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
      ),
      child: Row(
        children: [
          AppIcon(
            assetPath: AssetsPath.messagesIconSearch,
            size: ResponsiveHelper.iconSize(16),
            color: AppColors.textSecondary,
          ),
          SizedBox(width: ResponsiveHelper.spacing(8)),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: context.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: AppText.searchByName,
                hintStyle: context.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
