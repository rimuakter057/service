import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../helper/responsive_helper/responsive_helper.dart';

/// Reusable icon widget — just pass an [assetPath] (svg or raster) and,
/// optionally, a [size]/[color]. Defaults to a responsive 16px size so no
/// screen has to hardcode icon dimensions.
class AppIcon extends StatelessWidget {
  final String assetPath;
  final double? size;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  const AppIcon({
    super.key,
    required this.assetPath,
    this.size,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedWidth = width ?? size ?? ResponsiveHelper.iconSize(16);
    final resolvedHeight = height ?? size ?? ResponsiveHelper.iconSize(16);

    if (assetPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        assetPath,
        width: resolvedWidth,
        height: resolvedHeight,
        fit: fit,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      );
    }

    return Image.asset(
      assetPath,
      width: resolvedWidth,
      height: resolvedHeight,
      fit: fit,
      color: color,
    );
  }
}
