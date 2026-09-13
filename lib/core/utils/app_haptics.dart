import 'package:flutter/services.dart';

/// Centralized semantic haptic feedback system calibrated for iOS and Android.
/// Provides subtle, non-intrusive tactile responses tailored to specific user actions.
abstract final class AppHaptics {
  /// Subtle crisp tick for micro-interactions.
  /// Used for: Theme toggle, Filter chip selection, Task checkbox toggle.
  static Future<void> selection() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {}
  }

  /// Gentle physical impact for standard primary button actions.
  /// Used for: Add Task button (FAB & empty CTA), Save/Update task submission.
  static Future<void> lightImpact() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {}
  }

  /// Distinct, satisfying feedback for deliberate positive actions or gesture confirmations.
  /// Used for: SnackBar Undo restore, triggering swipe gesture action.
  static Future<void> mediumImpact() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  /// Authoritative feedback reserved strictly for destructive actions.
  /// Used for: Confirming task deletion in dialog or completing dismiss delete.
  static Future<void> heavyImpact() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }
}
