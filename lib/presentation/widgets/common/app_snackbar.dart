import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Centralized, theme-reactive SnackBar system for notifications, success states,
/// and enhanced undoable delete actions.
///
/// Automatically and dynamically re-renders all colors (background, borders, typography,
/// icons, and action buttons) when the user switches themes while the SnackBar is visible.
abstract final class AppSnackBar {
  /// Immediately dismisses any active SnackBar on screen.
  static void dismiss(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  /// Displays an enhanced deletion SnackBar with a lightened red border,
  /// dynamic theme-reactive background, task title, and instant "UNDO" action.
  static void showDelete(
    BuildContext context, {
    required String taskTitle,
    VoidCallback? onUndo,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMD,
          vertical: AppDimensions.spaceMD,
        ),
        padding: EdgeInsets.zero,
        duration: const Duration(seconds: 4),
        content: _DynamicDeleteSnackBar(
          taskTitle: taskTitle,
          onUndo: onUndo,
        ),
      ),
    );
  }

  /// Displays an enhanced success SnackBar (e.g. task created or updated)
  /// with a theme-reactive green border, background, and checkmark.
  static void showSuccess(
    BuildContext context, {
    required String message,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMD,
          vertical: AppDimensions.spaceMD,
        ),
        padding: EdgeInsets.zero,
        duration: const Duration(seconds: 2),
        content: _DynamicSuccessSnackBar(
          message: message,
        ),
      ),
    );
  }
}

/// Dynamically reacts to runtime theme changes (Light <-> Dark) for deleted task toasts.
class _DynamicDeleteSnackBar extends StatelessWidget {
  final String taskTitle;
  final VoidCallback? onUndo;

  const _DynamicDeleteSnackBar({
    required this.taskTitle,
    this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamically reads theme on every rebuild/theme switch
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? AppColors.darkSurface : AppColors.surface;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    // Lightened, soft red border matching the success snackbar border style
    final deleteBorderColor = isDark
        ? const Color(0xFFF87171).withValues(alpha: 0.5)
        : const Color(0xFFEF4444).withValues(alpha: 0.45);

    // Same radiant Amber color for both Light and Dark modes
    const undoColor = Color(0xFFFBBF24);

    final iconBg =
        isDark ? AppColors.darkErrorLight : AppColors.errorLight;
    final iconColor =
        isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444);

    final displayTitle = taskTitle.length > 28
        ? '${taskTitle.substring(0, 28)}...'
        : taskTitle;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppDimensions.borderRadiusLarge,
        border: Border.all(color: deleteBorderColor, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 4),
            blurRadius: 14,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
      child: Row(
        children: [
          // Circular delete icon badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),

          // Message & task title
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task deleted',
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  '"$displayTitle"',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Interactive UNDO Action Button
          if (onUndo != null) ...[
            const SizedBox(width: 8),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  onUndo!();
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Text(
                    'UNDO',
                    style: TextStyle(
                      color: undoColor,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Dynamically reacts to runtime theme changes (Light <-> Dark) for success toasts.
class _DynamicSuccessSnackBar extends StatelessWidget {
  final String message;

  const _DynamicSuccessSnackBar({required this.message});

  @override
  Widget build(BuildContext context) {
    // Dynamically reads theme on every rebuild/theme switch
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? AppColors.darkSurface : AppColors.surface;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    final greenBorderColor = isDark
        ? const Color(0xFF34D399).withValues(alpha: 0.5)
        : const Color(0xFF10B981).withValues(alpha: 0.45);

    final iconColor = isDark ? AppColors.accentLight : AppColors.primary;
    final iconBgColor = isDark
        ? AppColors.darkSuccessLight
        : AppColors.successLight;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppDimensions.borderRadiusLarge,
        border: Border.all(color: greenBorderColor, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 4),
            blurRadius: 14,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
