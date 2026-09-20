import 'package:flutter/material.dart';
import 'package:nchito/core/utils/app_colors/app_colors.dart';
import 'package:nchito/core/utils/assets_path/assets_path.dart';

class CategoryUiHelper {
  CategoryUiHelper._();

  static Color parseHexColor(String? hexString, {Color fallback = AppColors.brandPrimary}) {
    if (hexString == null || hexString.trim().isEmpty) return fallback;
    var hex = hexString.replaceAll('#', '').trim();
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    final val = int.tryParse(hex, radix: 16);
    if (val == null) return fallback;
    return Color(val);
  }

  static Color getBgColor(String? hexString) {
    final color = parseHexColor(hexString);
    return color.withValues(alpha: 0.12);
  }

  static Color getIconColor(String? hexString) {
    return parseHexColor(hexString);
  }

  static String resolveAssetPath(String slug, String name) {
    final key = '${slug.toLowerCase()} ${name.toLowerCase()}';
    if (key.contains('clean')) return AssetsPath.categoryCleaning;
    if (key.contains('plumb')) return AssetsPath.categoryPlumbing;
    if (key.contains('electr')) return AssetsPath.categoryElectrical;
    if (key.contains('garden') || key.contains('landscap')) {
      return AssetsPath.categoryGardening;
    }
    if (key.contains('paint') || key.contains('decor')) {
      return AssetsPath.categoryPainting;
    }
    if (key.contains('mov') || key.contains('relocat')) {
      return AssetsPath.categoryMoving;
    }
    if (key.contains('beaut') ||
        key.contains('care') ||
        key.contains('person')) {
      return AssetsPath.categoryPersonalCare;
    }
    if (key.contains('maint') || key.contains('home')) {
      return AssetsPath.categoryElectrical;
    }
    return AssetsPath.categoryCleaning;
  }
}
