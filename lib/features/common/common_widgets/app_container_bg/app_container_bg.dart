import 'package:flutter/material.dart';

import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';

/// Reusable card-style background container — drop any [child] into it.
/// Color/radius/padding all have sensible defaults but can be overridden
/// per call site.
class AppContainerBg extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const AppContainerBg({
    super.key,
    required this.child,
    this.color,
    this.radius,
    this.padding,
    this.width,
    this.height,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(ResponsiveHelper.padding(16)),
      decoration: BoxDecoration(
        color: color ?? AppColors.bgCard,
        borderRadius: BorderRadius.circular(
          radius ?? ResponsiveHelper.borderRadius(16),
        ),
        border: border,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
