import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.scaffold,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: AppColors.surface,
      ),
      textTheme: _buildTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnDark,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.sourceSans3(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 50),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.sourceSans3(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.scaffold,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderFocus, width: 1.5),
        ),
        hintStyle: GoogleFonts.sourceSans3(color: AppColors.textHint, fontSize: 15),
        labelStyle: GoogleFonts.sourceSans3(color: AppColors.textMuted, fontSize: 15),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1, space: 0),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryLighter,
        labelStyle: GoogleFonts.sourceSans3(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
    );
  }

  static TextTheme _buildTextTheme() => TextTheme(
    displayLarge:  GoogleFonts.merriweather(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3),
    displayMedium: GoogleFonts.merriweather(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3),
    headlineLarge: GoogleFonts.merriweather(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.35),
    headlineMedium:GoogleFonts.merriweather(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.4),
    headlineSmall: GoogleFonts.merriweather(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.4),
    titleLarge:    GoogleFonts.sourceSans3(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
    titleMedium:   GoogleFonts.sourceSans3(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    titleSmall:    GoogleFonts.sourceSans3(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    bodyLarge:     GoogleFonts.sourceSans3(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.65),
    bodyMedium:    GoogleFonts.sourceSans3(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.6),
    bodySmall:     GoogleFonts.sourceSans3(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textMuted, height: 1.5),
    labelLarge:    GoogleFonts.sourceSans3(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textOnDark),
    labelMedium:   GoogleFonts.sourceSans3(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
    labelSmall:    GoogleFonts.sourceSans3(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 0.6),
  );
}
