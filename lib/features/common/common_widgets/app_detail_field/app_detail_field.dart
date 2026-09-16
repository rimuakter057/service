import 'package:flutter/material.dart';
import 'package:nchito/features/common/common_widgets/app_container_bg/app_container_bg.dart';
import 'package:nchito/core/utils/extensions/context_extension/context_extension.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';

/// Alias for backward compatibility.
typedef DetailField = AppDetailField;

/// Reusable detail card / field with italic label and bold value or custom child.
/// Used in user and provider profile and details screens.
class AppDetailField extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? child;
  final Widget? trailing;

  final bool emphasizeValue;
  final Color? color;
  final double? radius;
  final EdgeInsetsGeometry? contentPadding;
  final double? gap;

  const AppDetailField({
    super.key,
    required this.label,
    this.value,
    this.child,
    this.trailing,
    this.emphasizeValue = true,
    this.color,
    this.radius,
    this.contentPadding,
    this.gap,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainerBg(
      width: double.infinity,
      color: color,
      radius: radius,
      padding: contentPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: context.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: gap ?? ResponsiveHelper.spacing(6)),
                child ??
                    Text(
                      value ?? '',
                      style: emphasizeValue
                          ? context.titleSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBlackPrimary,
                            )
                          : context.labelSmall.copyWith(
                              color: AppColors.textBlackPrimary,
                            ),
                    ),
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: ResponsiveHelper.spacing(12)),
            trailing!,
          ],
        ],
      ),
    );
  }
}
