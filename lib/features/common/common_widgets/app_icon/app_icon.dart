import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:nchito/core/utils/assets_path/assets_path.dart';
import 'package:nchito/core/utils/helpers/responsive_helper/responsive_helper.dart';

/// Reusable icon widget — pass an [assetPath] that is:
/// - an `http`/`https` URL  → rendered with [Image.network] (with fallback)
/// - a `.svg` asset path    → rendered with [SvgPicture.asset]
/// - any other asset path   → rendered with [Image.asset]
class AppIcon extends StatelessWidget {
  final String assetPath;
  final double? size;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final Alignment alignment;

  const AppIcon({
    super.key,
    required this.assetPath,
    this.size,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedWidth = width ?? size ?? ResponsiveHelper.iconSize(16);
    final resolvedHeight = height ?? size ?? ResponsiveHelper.iconSize(16);

    // Network image (http / https URL from API)
    if (assetPath.startsWith('http://') || assetPath.startsWith('https://')) {
      return Image.network(
        assetPath,
        width: resolvedWidth,
        height: resolvedHeight,
        fit: fit,
        alignment: alignment,
        color: color,
        errorBuilder: (_, __, ___) => Image.asset(
          AssetsPath.avatarUser,
          width: resolvedWidth,
          height: resolvedHeight,
          fit: fit,
        ),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            width: resolvedWidth,
            height: resolvedHeight,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
          );
        },
      );
    }

    if (assetPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        assetPath,
        width: resolvedWidth,
        height: resolvedHeight,
        fit: fit,
        alignment: alignment,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
      );
    }

    return Image.asset(
      assetPath,
      width: resolvedWidth,
      height: resolvedHeight,
      fit: fit,
      alignment: alignment,
      color: color,
      errorBuilder: (_, __, ___) => Image.asset(
        AssetsPath.avatarUser,
        width: resolvedWidth,
        height: resolvedHeight,
        fit: fit,
      ),
    );
  }
}
