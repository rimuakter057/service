import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Reusable conversation row for the Messages list — avatar with an
/// online badge, name, last message preview, and a time/unread indicator.
/// Call this from the screen by passing one conversation's data.
class MessageListTile extends StatelessWidget {
  final String avatarAsset;
  final String name;
  final String lastMessage;
  final String timeLabel;
  final int unreadCount;
  final bool isSelected;
  final VoidCallback? onTap;

  const MessageListTile({
    super.key,
    required this.avatarAsset,
    required this.name,
    required this.lastMessage,
    required this.timeLabel,
    this.unreadCount = 0,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUnread = unreadCount > 0;
    final avatarSize = ResponsiveHelper.width(44);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(ResponsiveHelper.padding(10)),
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.brandSoft
              : AppColors.bgOverlay.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(10),
          ),
          border: isSelected
              ? Border.all(
                  color: AppColors.brandPrimary.withValues(alpha: 0.55),
                )
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(11),
                  ),
                  child: Image.asset(
                    avatarAsset,
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: -3,
                  right: -3,
                  child: AppIcon(
                    assetPath: AssetsPath.messagesIconOnlineBadge,
                    size: ResponsiveHelper.iconSize(10),
                  ),
                ),
              ],
            ),
            SizedBox(width: ResponsiveHelper.spacing(6)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlackPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(4)),
                  Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(6)),
            SizedBox(
              width: ResponsiveHelper.width(45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    timeLabel,
                    style: context.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (isUnread) ...[
                    SizedBox(height: ResponsiveHelper.spacing(6)),
                    Container(
                      width: ResponsiveHelper.width(12),
                      height: ResponsiveHelper.width(12),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.brandPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$unreadCount',
                        style: context.labelSmall.copyWith(
                          color: AppColors.textOnPrimary,
                          fontSize: ResponsiveHelper.fontSize(7),
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
