import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Text styles for the app, built on the DM Sans font family.
/// Named after Flutter's Material TextTheme roles.
class AppTheme {
  AppTheme._();

  static TextStyle get displayLarge =>
      GoogleFonts.dmSans(fontSize: 57, fontWeight: FontWeight.w400);

  static TextStyle get displayMedium =>
      GoogleFonts.dmSans(fontSize: 45, fontWeight: FontWeight.w400);

  static TextStyle get displaySmall =>
      GoogleFonts.dmSans(fontSize: 36, fontWeight: FontWeight.w400);

  static TextStyle get headlineLarge =>
      GoogleFonts.dmSans(fontSize: 32, fontWeight: FontWeight.w400);

  static TextStyle get headlineMedium =>
      GoogleFonts.dmSans(fontSize: 28, fontWeight: FontWeight.w400);

  static TextStyle get headlineSmall =>
      GoogleFonts.dmSans(fontSize: 24, fontWeight: FontWeight.w400);

  static TextStyle get titleLarge =>
      GoogleFonts.dmSans(fontSize: 22, fontWeight: FontWeight.w500);

  static TextStyle get titleMedium =>
      GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w500);

  static TextStyle get titleSmall =>
      GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500);

  static TextStyle get bodyLarge =>
      GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w400);

  static TextStyle get bodyMedium =>
      GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w400);

  static TextStyle get bodySmall =>
      GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w400);

  static TextStyle get labelLarge =>
      GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500);

  static TextStyle get labelMedium =>
      GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle get labelSmall =>
      GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w500);

  /// Full TextTheme built from the styles above, for use with ThemeData.
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
}
