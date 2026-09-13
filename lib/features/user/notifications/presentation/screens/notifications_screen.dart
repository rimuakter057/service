import 'package:flutter/material.dart';
import 'package:nchito/core/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/core/common_widgets/app_top_bar/app_top_bar.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/app_text/app_text.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/features/user/notifications/presentation/widgets/notification_sample_data.dart';
import 'package:nchito/features/user/notifications/presentation/widgets/notification_tile.dart';

/// Notifications list. Navigated to from the bell icon on [HomeHeader].
class NotificationsScreen extends StatelessWidget {
  static const String routeName = '/notifications';

  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            TopAppbar(
              title: AppText.notifications,
              trailing: GestureDetector(
                // TODO(backend): mark all notifications as read here once
                // the backend is available.
                onTap: () {},
                child: BgIcon(
                  assetPath: AssetsPath.logInIconEyeToggle,
                  bgColor: AppColors.brandSoft,
                  iconColor: AppColors.brandPrimary,
                  bgSize: ResponsiveHelper.width(28),
                  radius: ResponsiveHelper.borderRadius(7),
                  iconSize: ResponsiveHelper.iconSize(14),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(24),
                ),
                child: Column(
                  children: [
                    for (final notification in notificationSampleData) ...[
                      NotificationTile(
                        message: notification.message,
                        dateLabel: notification.dateLabel,
                        isUnread: notification.isUnread,
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(10)),
                    ],
                    SizedBox(height: ResponsiveHelper.spacing(14)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
