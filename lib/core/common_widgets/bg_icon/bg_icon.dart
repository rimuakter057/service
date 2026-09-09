import 'package:flutter/material.dart';
import '../../helper/responsive_helper/responsive_helper.dart';
import '../app_icon/app_icon.dart';

/// Background සහිත রিইউজেবল আইকন উইজেট
class BgIconWidget extends StatelessWidget {
  final String assetPath;
  final double? size; // আইকনের সাইজ
  final Color? iconColor; // আইকনের কালার
  final Color? bgColor; // ব্যাকগ্রাউন্ড কালার
  final double? borderRadius; // কোণ গুল করার জন্য
  final EdgeInsetsGeometry? padding; // ভেতরের প্যাডিং
  final VoidCallback? onTap; // ক্লিক করার প্রয়োজন হলে

  const BgIconWidget({
    super.key,
    required this.assetPath,
    this.size,
    this.iconColor,
    this.bgColor,
    this.borderRadius,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Container(
      padding: padding ?? EdgeInsets.all(ResponsiveHelper.padding(10)),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveHelper.borderRadius(12),
        ),
      ),
      child: AppIcon(
        assetPath: assetPath,
        size: size ?? ResponsiveHelper.iconSize(18),
        color: iconColor,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveHelper.borderRadius(12),
        ),
        child: iconWidget,
      );
    }

    return iconWidget;
  }
}