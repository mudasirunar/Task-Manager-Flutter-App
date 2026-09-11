import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Centralized Material 3 Theme configuration.
abstract final class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.surface,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.surface,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusLarge,
          side: BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLG,
            vertical: AppDimensions.spaceMD,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMedium,
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLG,
            vertical: AppDimensions.spaceMD,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMedium,
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMD,
          vertical: AppDimensions.spaceMD,
        ),
        hintStyle: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.border, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.borderFocused, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.error, width: 1.8),
        ),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Dialog Theme
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        elevation: 6,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        elevation: 3,
        focusElevation: 4,
        hoverElevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
