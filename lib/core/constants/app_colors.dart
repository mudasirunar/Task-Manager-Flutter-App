import 'package:flutter/material.dart';

/// Semantic color tokens designed for a calm, professional, and modern UI.
/// Supports both refined Light and deep Obsidian Dark mode palettes.
abstract final class AppColors {
  // Brand / Primary (Deep Slate Palette)
  static const Color primary = Color(0xFF1E293B);
  static const Color primaryLight = Color(0xFF334155);
  static const Color accent = Color(0xFF3B82F6);
  static const Color accentLight = Color(0xFF60A5FA);

  // Light Theme: Backgrounds & Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSubtle = Color(0xFFF1F5F9);

  // Light Theme: Typography
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Light Theme: Outlines & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocused = Color(0xFF1E293B);

  // Dark Theme: Backgrounds & Surfaces (Deep Obsidian)
  static const Color darkBackground = Color(0xFF0B0F17);
  static const Color darkSurface = Color(0xFF151D2A);
  static const Color darkSurfaceSubtle = Color(0xFF1E293B);

  // Dark Theme: Typography
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Dark Theme: Outlines & Dividers
  static const Color darkBorder = Color(0xFF263345);
  static const Color darkBorderFocused = Color(0xFF60A5FA);

  // Semantic Status: Completed (Emerald)
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color darkSuccessLight = Color(0xFF064E3B);

  // Semantic Status: Pending (Amber)
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color darkWarningLight = Color(0xFF451A03);

  // Semantic Action: Destructive / Error (Rose / Red)
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color darkErrorLight = Color(0xFF450A0A);

  // Shadows
  static const Color shadow = Color(0x0F0F172A);
  static const Color darkShadow = Color(0x33000000);

  // Gradients for progress & cards
  static const LinearGradient progressGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF10B981)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient cardAccentGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
