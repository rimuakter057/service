import 'package:flutter/material.dart';

import '../../helper/responsive_helper/responsive_helper.dart';
import '../../utils/app_colors/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double? radius;
  final Color textColor;
  final TextStyle? textStyle;

  /// Overrides the default [Text] (e.g. for multi-color button text such
  /// as "21+ Enter" with "21+" in a different color) — [text] is still
  /// required for semantics but is ignored visually when this is set.
  final Widget? child;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.backgroundColor = Colors.transparent,
    this.borderColor,
    this.borderWidth = 1,
    this.radius,
    this.textColor = AppColors.textBlackPrimary,
    this.textStyle,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? ResponsiveHelper.buttonHeight(44),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor,
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: borderWidth)
              : BorderSide.none,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              radius ?? ResponsiveHelper.borderRadius(10),
            ),
          ),
        ),
        child:
            child ??
            Text(
              text,
              style:
                  textStyle ??
                  TextStyle(
                    fontSize: ResponsiveHelper.fontSize(14),
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
            ),
      ),
    );
  }
}
