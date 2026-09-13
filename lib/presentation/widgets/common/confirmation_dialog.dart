import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_haptics.dart';
import 'custom_button.dart';

/// Modal dialog prompting confirmation before destructive actions (such as deletion).
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;

  const ConfirmationDialog({
    super.key,
    this.title = AppStrings.deleteDialogTitle,
    this.message = AppStrings.deleteDialogContent,
    this.confirmText = AppStrings.deleteConfirmButton,
    this.cancelText = AppStrings.cancelButton,
  });

  /// Displays the confirmation dialog and returns `true` if confirmed, `false` otherwise.
  static Future<bool> show(
    BuildContext context, {
    String title = AppStrings.deleteDialogTitle,
    String message = AppStrings.deleteDialogContent,
    String confirmText = AppStrings.deleteConfirmButton,
    String cancelText = AppStrings.cancelButton,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final dialogBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final iconBg = isDark
        ? AppColors.error.withValues(alpha: 0.15)
        : AppColors.errorLight;

    return Dialog(
      backgroundColor: dialogBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: AppColors.error,
          width: 1.4,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceLG,
          vertical: AppDimensions.spaceLG + 4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Warning Icon (Centered)
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 26,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMD),

            // Dialog Title (Centered)
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSM),

            // Dialog Message (Centered)
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textSecondary,
                fontSize: 14,
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLG + 4),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: cancelText,
                    variant: ButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceMD),
                Expanded(
                  child: CustomButton(
                    text: confirmText,
                    variant: ButtonVariant.danger,
                    onPressed: () {
                      AppHaptics.heavyImpact();
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
