import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/features/common/common_widgets/app_confirm_bottom_sheet/app_confirm_bottom_sheet.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/features/common/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/features/common/common_widgets/app_status_card/app_status_card.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/messages/presentation/widgets/chat_sample_data.dart';
import 'package:nchito/features/user/messages/presentation/widgets/delete_conversation_bottom_sheet.dart';
import 'package:nchito/features/user/messages/presentation/widgets/message_actions_menu.dart';
import 'package:nchito/features/user/messages/presentation/widgets/message_sample_data.dart';

/// One-on-one chat thread between provider and a customer. Navigated to by tapping a
/// [MessageListTile] on ProviderMessagesScreen or "Chat" on ProviderBookingDetailsScreen.
class ProviderChatScreen extends StatefulWidget {
  static const String routeName = '/provider/chat';

  final MessageData conversation;
  final String? subtitle;

  const ProviderChatScreen({
    super.key,
    required this.conversation,
    this.subtitle,
  });

  @override
  State<ProviderChatScreen> createState() => _ProviderChatScreenState();
}

class _ProviderChatScreenState extends State<ProviderChatScreen> {
  final _messageController = TextEditingController();
  bool _isBlocked = false;

  bool get _isDisabled =>
      _isBlocked || widget.conversation.isMessagingUnavailable;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _onMenuTap(Offset position) {
    showMessageActionsMenu(
      context,
      position,
      isBlocked: _isBlocked,
      onToggleBlock:
          _isBlocked ? () => _onUnblock(context) : () => _onBlock(context),
      onDelete: () => _onDelete(context),
    );
  }

  void _onBlock(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => AppConfirmBottomSheet(
        icon: AppIcon(
          assetPath: AssetsPath.messagesIconBlockedChat,
          size: ResponsiveHelper.iconSize(72),
        ),
        title: AppText.blockThisUserExclaim,
        description: Text(
          AppText
              .areYouSureYouWantToBlockThisUserYouWontBeAbleToSendOrReceiveMessagesWithEachOther,
          textAlign: TextAlign.center,
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
          ),
        ),
        confirmLabel: AppText.block,
        confirmColor: AppColors.red400,
        onConfirm: () {
          setState(() => _isBlocked = true);
        },
      ),
    );
  }

  void _onUnblock(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => AppConfirmBottomSheet(
        icon: AppIcon(
          assetPath: AssetsPath.messagesIconBlockedChat,
          size: ResponsiveHelper.iconSize(72),
        ),
        title: AppText.unblockThisUserExclaim,
        description: Text(
          AppText.doYouWantToUnblockThisUserAndAllowMessagesAgain,
          textAlign: TextAlign.center,
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
          ),
        ),
        confirmLabel: AppText.unblock,
        confirmColor: AppColors.brandPrimary,
        onConfirm: () {
          setState(() => _isBlocked = false);
        },
      ),
    );
  }

  void _onDelete(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => DeleteConversationBottomSheet(
        onConfirm: () {
          context.pop();
        },
      ),
    );
  }

  void _onSend() {
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final conversation = widget.conversation;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(20),
                vertical: ResponsiveHelper.padding(12),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: BgIcon(
                      assetPath: AssetsPath.providerDetailsIconBack,
                      bgColor: AppColors.brandSoft,
                      iconColor: AppColors.brandPrimary,
                      bgSize: ResponsiveHelper.width(40),
                      radius: ResponsiveHelper.width(20),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(10)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(11),
                    ),
                    child: Image.asset(
                      conversation.avatarAsset,
                      width: ResponsiveHelper.width(40),
                      height: ResponsiveHelper.width(40),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: ResponsiveHelper.width(40),
                        height: ResponsiveHelper.width(40),
                        color: AppColors.brandSoft,
                        child: Icon(
                          Icons.person,
                          color: AppColors.brandPrimary,
                          size: ResponsiveHelper.iconSize(22),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(10)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          conversation.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlackPrimary,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(2)),
                        Text(
                          widget.subtitle ?? AppText.twoOngoingBookings,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(11),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTapDown: (details) => _onMenuTap(details.globalPosition),
                    child: Container(
                      width: ResponsiveHelper.width(40),
                      height: ResponsiveHelper.width(40),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.bgOverlay.withValues(alpha: 0.04),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.more_vert_rounded,
                        size: ResponsiveHelper.iconSize(20),
                        color: AppColors.textBlackPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isDisabled
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.padding(20),
                        ),
                        child: conversation.isMessagingUnavailable
                            ? AppStatusCard(
                                iconAsset: AssetsPath.messagesIconBlockedChat,
                                iconBoxColor: AppColors.red.withValues(
                                  alpha: 0.1,
                                ),
                                title: AppText.messagingIsUnavailable,
                                description: AppText
                                    .youCanNoLongerSendMessagesInThisConversation,
                                buttonLabel: AppText.deleteConversation,
                                onButtonTap: () => _onDelete(context),
                              )
                            : AppStatusCard(
                                iconAsset: AssetsPath.messagesIconBlockedChat,
                                iconBoxColor: AppColors.red.withValues(
                                  alpha: 0.1,
                                ),
                                title: AppText.youHaveBlockedThisUser,
                                description: AppText
                                    .youCantSendOrReceiveMessagesInThisConversation,
                                buttonLabel: AppText.unblockUser,
                                onButtonTap: () => _onUnblock(context),
                              ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(20),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: ResponsiveHelper.spacing(20)),
                          Text(
                            AppText.today,
                            style: context.bodySmall.copyWith(
                              fontSize: ResponsiveHelper.fontSize(10),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(20)),
                          for (final message in chatSampleMessages) ...[
                            _ChatBubble(message: message),
                            SizedBox(height: ResponsiveHelper.spacing(20)),
                          ],
                        ],
                      ),
                    ),
            ),
            IgnorePointer(
              ignoring: _isDisabled,
              child: Opacity(
                opacity: _isDisabled ? 0.2 : 1,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.padding(20),
                    vertical: ResponsiveHelper.padding(12),
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.bgApp,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: ResponsiveHelper.height(48),
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.padding(16),
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(10),
                            ),
                          ),
                          child: TextField(
                            controller: _messageController,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(14),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textBlackPrimary,
                            ),
                            decoration: InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                              hintText: AppText.enterMessage,
                              hintStyle: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(14),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textGreyPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.spacing(10)),
                      GestureDetector(
                        onTap: _onSend,
                        child: Container(
                          width: ResponsiveHelper.width(48),
                          height: ResponsiveHelper.height(48),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.brandPrimary,
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(10),
                            ),
                          ),
                          child: AppIcon(
                            assetPath: AssetsPath.messagesIconSend,
                            size: ResponsiveHelper.iconSize(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessageData message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final radius = ResponsiveHelper.borderRadius(24);

    return Align(
      alignment: message.isMine
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message.isMine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: ResponsiveHelper.width(240)),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(16),
                vertical: ResponsiveHelper.padding(12),
              ),
              decoration: BoxDecoration(
                color: message.isMine
                    ? AppColors.brandSoft
                    : AppColors.bgOverlay.withValues(alpha: 0.04),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius),
                  bottomLeft: message.isMine
                      ? Radius.circular(radius)
                      : Radius.zero,
                  bottomRight: message.isMine
                      ? Radius.zero
                      : Radius.circular(radius),
                ),
              ),
              child: Text(
                message.text,
                style: context.bodySmall.copyWith(
                  fontSize: ResponsiveHelper.fontSize(13),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBlackPrimary,
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(4)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.padding(8),
            ),
            child: Text(
              message.timeLabel,
              style: context.bodySmall.copyWith(
                fontSize: ResponsiveHelper.fontSize(12),
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
