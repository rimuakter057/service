import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_icon/app_icon.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// Single row on the Notifications screen — icon, message, and date.
/// Unread notifications get a solid brand-tinted background; read ones
/// get a faint outlined background.
class NotificationTile extends StatelessWidget {
  final String message;
  final String dateLabel;
  final bool isUnread;

  const NotificationTile({
    super.key,
    required this.message,
    required this.dateLabel,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.padding(10)),
      decoration: BoxDecoration(
        color: isUnread
            ? AppColors.brandSoft
            : AppColors.bgOverlay.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(16)),
        border: isUnread ? null : Border.all(color: AppColors.brandSoft),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcon(
            assetPath: AssetsPath.notificationsIconMark,
            size: ResponsiveHelper.width(40),
          ),
          SizedBox(width: ResponsiveHelper.spacing(6)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveHelper.padding(2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: context.bodySmall.copyWith(
                      fontSize: ResponsiveHelper.fontSize(13),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBlackPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(2)),
                  Text(
                    dateLabel,
                    style: context.bodySmall.copyWith(
                      fontSize: ResponsiveHelper.fontSize(10),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
