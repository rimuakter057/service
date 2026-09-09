import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nchito/core/common_widgets/app_icon/bg_icon.dart';
import 'package:nchito/core/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/helper/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

/// A reusable top app bar used across all inner screens.
///
/// Layout:
///   [back icon] ──── [title centered] ──── [trailing (optional)]
///
/// Parameters:
/// - [title]          : required. The screen title shown in the center.
/// - [showBackButton] : optional, defaults to `true`. Set `false` to hide.
/// - [onBack]         : optional. Custom back handler. Defaults to `context.pop()`.
/// - [trailing]       : optional Widget on the right (e.g. a favourite icon).
/// - [padding]        : optional. Overrides the default horizontal/vertical padding.
class TopAppbar extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  const TopAppbar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBack,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = ResponsiveHelper.width(40);
    final iconRadius = ResponsiveHelper.width(20);

    return Padding(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.padding(24),
            vertical: ResponsiveHelper.padding(16),
          ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Left — back button ──────────────────────────────────
          if (showBackButton)
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: onBack ?? () => context.pop(),
                child: BgIcon(
                  assetPath: AssetsPath.providerDetailsIconBack,
                  bgColor: AppColors.brandSoft,
                  iconColor: AppColors.brandPrimary,
                  bgSize: iconSize,
                  radius: iconRadius,
                ),
              ),
            ),

          // ── Center — title ──────────────────────────────────────
          Text(title, style: context.labelMedium),

          // ── Right — trailing (optional) ─────────────────────────
          if (trailing != null)
            Align(
              alignment: Alignment.centerRight,
              child: trailing!,
            ),
        ],
      ),
    );
  }
}
