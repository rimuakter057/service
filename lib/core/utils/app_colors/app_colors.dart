import 'package:flutter/material.dart';

/// Design tokens pulled from the Figma file:
/// Nchito — Service Marketplace | UI/UX Design
///
/// Colors are shared across screens (Figma variables), so they are not
/// split by screen like AssetsPath. New colors from other screens get
/// added below with a comment noting which screen introduced them.
class AppColors {
  AppColors._();

  // ==========================================================
  // HOME SCREEN tokens
  // ==========================================================

  // Brand colors
  static const Color brandPrimary = Color(0xFF0D3F26);
  static const Color bgColor = Color(0xFFFFFBF8);
  static const Color brandSoft = Color(0xFFE8F1EC);
  static const Color brandSecondaryHover = Color(0xFFE89100);

  // Background colors
  static const Color bgApp = Color(0xFFFFFBF8);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color bgOverlay = Color(0xFF000000);

  // Text colors
  static const Color textBlackPrimary = Color(0xFF111814);
  static const Color textSecondary = Color(0xFF5F6964);
  static const Color textGrey = Color(0xFF929A96);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border colors
  static const Color borderDefault = Color(0xFFE2E7E3);

  // Status colors
  static const Color blueStatusInfo = Color(0xFF3B82F6);

  // Category tag colors (50 = background tint, 400 = accent)
  static const Color red50 = Color(0xFFFEF2F2);
  static const Color red400 = Color(0xFFF87171);

  static const Color orange50 = Color(0xFFFFF7ED);
  static const Color orange400 = Color(0xFFFB923C);

  static const Color lime50 = Color(0xFFF7FEE7);
  static const Color lime400 = Color(0xFFA3E635);

  static const Color emerald50 = Color(0xFFECFDF5);
  static const Color emerald400 = Color(0xFF34D399);

  static const Color cyan400 = Color(0xFF22D3EE);

  static const Color teal50 = Color(0xFFF0FDFA);

  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue400 = Color(0xFF60A5FA);
}
