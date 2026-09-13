import 'package:flutter/material.dart';

export 'provider_bottom_nav_bar.dart';
export 'user_bottom_nav_bar.dart';

import '../../extensions/context_extension/context_extension.dart';
import '../../helper/responsive_helper/responsive_helper.dart';
import '../../utils/app_colors/app_colors.dart';
import '../app_icon/app_icon.dart';

class AppBottomNavItem {
  final String iconAsset;
  final String label;

  /// Some Figma-exported nav icons (e.g. the active "Explore" icon) already
  /// bake the selected-state color/background into the asset itself — set
  /// this so the bar doesn't tint over it with the active/inactive color.
  final bool preserveNativeColor;

  /// When set, the icon sits on a filled circle of this color (in white)
  /// while this item is active — e.g. Explore's solid-green active pill.
  final Color? activeBackgroundColor;

  const AppBottomNavItem({
    required this.iconAsset,
    required this.label,
    this.preserveNativeColor = false,
    this.activeBackgroundColor,
  });
}

/// Bottom navigation bar — pass the items, current index, and a tap
/// callback; active-state color/spacing are fixed.
class AppBottomNavBar extends StatelessWidget {
  final List<AppBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.borderDefault)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.padding(8),
            vertical: ResponsiveHelper.padding(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isActive = index == currentIndex;
              final color = isActive
                  ? AppColors.brandPrimary
                  : AppColors.textGrey;

              final showActivePill =
                  isActive && item.activeBackgroundColor != null;
              final iconWidget = AppIcon(
                assetPath: item.iconAsset,
                size: ResponsiveHelper.iconSize(showActivePill ? 18 : 22),
                color: showActivePill
                    ? AppColors.textOnPrimary
                    : (item.preserveNativeColor ? null : color),
              );

              return GestureDetector(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    showActivePill
                        ? Container(
                            padding: EdgeInsets.all(
                              ResponsiveHelper.padding(8),
                            ),
                            decoration: BoxDecoration(
                              color: item.activeBackgroundColor,
                              shape: BoxShape.circle,
                            ),
                            child: iconWidget,
                          )
                        : iconWidget,
                    SizedBox(height: ResponsiveHelper.spacing(4)),
                    Text(
                      item.label,
                      style: context.labelSmall.copyWith(color: color),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
