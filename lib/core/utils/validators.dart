import '../constants/app_strings.dart';

/// Form and input validation helper functions.
abstract final class Validators {
  /// Validates a task title according to assignment rules:
  /// - Must not be null
  /// - Must not be empty
  /// - Must not contain only whitespace
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.titleRequiredError;
    }
    if (value.trim().isEmpty) {
      return AppStrings.titleWhitespaceError;
    }
    return null;
  }
}
