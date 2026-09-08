import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helper/responsive_helper/responsive_helper.dart';
import '../app_colors/app_colors.dart';


class AppTheme {
  AppTheme._();

  static Color get inputIconColor => AppColors.textGrey;

  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    hintStyle: titleSmall,
    filled: true,
    fillColor: AppColors.borderDefault.withValues(alpha: 0.3),
    contentPadding: EdgeInsets.symmetric(
      horizontal: ResponsiveHelper.padding(16),
      vertical: ResponsiveHelper.padding(16),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
      borderSide: BorderSide.none,
    ),
    prefixIconColor: inputIconColor,
    suffixIconColor: inputIconColor,
    prefixIconConstraints: BoxConstraints(
      minWidth: ResponsiveHelper.width(48),
      minHeight: ResponsiveHelper.height(48),
    ),
    suffixIconConstraints: BoxConstraints(
      minWidth: ResponsiveHelper.width(48),
      minHeight: ResponsiveHelper.height(48),
    ),
  );

  static ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.brandPrimary,
      foregroundColor: AppColors.textOnPrimary,
      minimumSize: Size(double.infinity, ResponsiveHelper.buttonHeight(44)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(24),
        vertical: ResponsiveHelper.padding(10),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
      ),
      textStyle: titleMedium,
    ),
  );
















  static TextStyle get displayLarge => GoogleFonts.dmSans(
    fontSize: ResponsiveHelper.titleFontSize(57),
    fontWeight: FontWeight.w400,
  );

  // Figma: DM Sans, 600 SemiBold, 15px
  static TextStyle get displayMedium => GoogleFonts.dmSans(
    fontSize: ResponsiveHelper.titleFontSize(15),
    fontWeight: FontWeight.w600,
  );

  // Figma: DM Sans, 500 Medium, 14px
  static TextStyle get displaySmall =>  GoogleFonts.dmSans(
    fontSize: ResponsiveHelper.titleFontSize(14),
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
    height: 1.2,
    letterSpacing: 0,
  );
///=======================
  static TextStyle get headlineLarge => GoogleFonts.dmSans(
    fontSize: ResponsiveHelper.titleFontSize(28),
    fontWeight: FontWeight.w600,
    color: AppColors.textBlackPrimary,
    height: 1.0,
    letterSpacing: 0,
  );

  static TextStyle get headlineMedium => GoogleFonts.dmSans(
    fontSize: ResponsiveHelper.titleFontSize(28),
    fontWeight: FontWeight.w600,
    color: AppColors.textBlackPrimary,
    height: 1.0,
    letterSpacing: 0,
  );

  static TextStyle get headlineSmall => GoogleFonts.dmSans(
    fontSize: ResponsiveHelper.titleFontSize(24),
    fontWeight: FontWeight.w400,
  );

///===========================
  static TextStyle get titleLarge => GoogleFonts.dmSans(
    fontSize: ResponsiveHelper.titleFontSize(28),
    fontWeight: FontWeight.w600,
    color: AppColors.textBlackPrimary,
    height: 1.0,
    letterSpacing: 0,
  );


///=====================
  static TextStyle get titleSmall => GoogleFonts.dmSans(
    fontSize: ResponsiveHelper.titleFontSize(14),
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
    height: 1.2,
    letterSpacing: 0,
  );



  static TextStyle get titleMedium => GoogleFonts.dmSans(
    fontSize: ResponsiveHelper.titleFontSize(16),
    fontWeight: FontWeight.w500,
  );



  static TextStyle get bodyLarge => GoogleFonts.dmSans(
    fontSize: ResponsiveHelper.fontSize(16),
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodyMedium => GoogleFonts.dmSans(
    fontSize: ResponsiveHelper.fontSize(14),
    fontWeight: FontWeight.w400,
  );

  // Figma: DM Sans, 500 Medium, 14px
  static TextStyle get bodySmall => GoogleFonts.dmSans(
    fontSize: ResponsiveHelper.fontSize(12),
    fontWeight: FontWeight.w400,
  );

  static TextStyle get labelLarge => GoogleFonts.dmSans(
    fontSize: ResponsiveHelper.fontSize(14),
    fontWeight: FontWeight.w500,
  );
///===============

  static TextStyle get labelMedium => GoogleFonts.dmSans(
    fontSize: ResponsiveHelper.fontSize(15),
    fontWeight: FontWeight.w600,
    height: 1.1,
    letterSpacing: 0,
    color: AppColors.textBlackPrimary
  );

///=========
  static TextStyle get labelSmall => GoogleFonts.dmSans(
    fontSize: ResponsiveHelper.fontSize(14),
    fontWeight: FontWeight.w500,
    height: 1.1,
    letterSpacing: 0,
    color: AppColors.textGrey
  );


  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );



  /// Full app theme — pass this straight to MaterialApp's `theme`.
  static ThemeData get themeData => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.bgColor),
    textTheme: textTheme,
    inputDecorationTheme: inputDecorationTheme,
    elevatedButtonTheme: elevatedButtonTheme,
  );
}
