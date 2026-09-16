import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';

/// Provider message row widget matching the provider design:
/// clean avatar without online badge dot, but preserves the unread count badge
/// in dark green with mint card background tint.
class ProviderMessageListTile extends StatelessWidget {
  final String avatarAsset;
  final String name;
  final String lastMessage;
  final String timeLabel;
  final int unreadCount;
  final bool isSelected;
  final VoidCallback? onTap;

  const ProviderMessageListTile({
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
    final avatarSize = ResponsiveHelper.width(46);

    Color cardBgColor;
    if (isSelected) {
      cardBgColor = Colors.white;
    } else if (isUnread) {
      cardBgColor = const Color(0xFFEBF5F0);
    } else {
      cardBgColor = const Color(0xFFF7F8F9);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(14),
          ),
          border: isSelected
              ? Border.all(
                  color: const Color(0xFF0F3E2E),
                  width: 1.2,
                )
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar (clean without online badge dot)
            ClipRRect(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(12),
              ),
              child: Image.asset(
                avatarAsset,
                width: avatarSize,
                height: avatarSize,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: avatarSize,
                  height: avatarSize,
                  color: AppColors.brandSoft,
                  child: Icon(
                    Icons.person,
                    color: AppColors.brandPrimary,
                    size: ResponsiveHelper.iconSize(24),
                  ),
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(10)),

            // Name and last message preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(14),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlackPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(4)),
                  Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(12),
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(8)),

            // Trailing column: Time label + unread count badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeLabel,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(11),
                    color: AppColors.textSecondary,
                  ),
                ),
                if (isUnread) ...[
                  SizedBox(height: ResponsiveHelper.spacing(6)),
                  Container(
                    width: ResponsiveHelper.width(18),
                    height: ResponsiveHelper.width(18),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F3E2E),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(10),
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
