import 'package:flutter/material.dart';

/// Semantic color tokens designed for a calm, professional, and modern UI.
/// Avoids aggressive neon/saturated colors.
abstract final class AppColors {
  // Brand / Primary (Deep Slate Palette)
  static const Color primary = Color(0xFF1E293B);
  static const Color primaryLight = Color(0xFF334155);
  static const Color accent = Color(0xFF3B82F6);

  // Backgrounds & Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSubtle = Color(0xFFF1F5F9);

  // Typography / Content
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Outlines & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocused = Color(0xFF1E293B);

  // Semantic Status: Completed (Emerald)
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);

  // Semantic Status: Pending (Amber)
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);

  // Semantic Action: Destructive / Error (Rose / Red)
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEF2F2);

  // Shadows
  static const Color shadow = Color(0x0F0F172A);
}
