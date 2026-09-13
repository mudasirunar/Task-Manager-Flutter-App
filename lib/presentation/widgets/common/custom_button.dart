import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

enum ButtonVariant { primary, secondary, danger, ghost }

/// A modern, accessible, and responsive button component with smooth interaction feedback.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? borderSide;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = isDark ? AppColors.accent : AppColors.primary;
        foregroundColor = AppColors.surface;
        break;
      case ButtonVariant.secondary:
        backgroundColor = isDark ? AppColors.darkSurface : AppColors.surface;
        foregroundColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
        borderSide = BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1.5,
        );
        break;
      case ButtonVariant.danger:
        backgroundColor = AppColors.error;
        foregroundColor = AppColors.surface;
        break;
      case ButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
        break;
    }

    final Widget child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppDimensions.iconMD, color: foregroundColor),
                const SizedBox(width: AppDimensions.spaceSM),
              ],
              Text(
                text,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          );

    final button = Material(
      color: backgroundColor,
      borderRadius: AppDimensions.borderRadiusMedium,
      elevation: variant == ButtonVariant.primary ? 1 : 0,
      shadowColor: AppColors.shadow,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: AppDimensions.borderRadiusMedium,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLG,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: AppDimensions.borderRadiusMedium,
            border: borderSide != null ? Border.fromBorderSide(borderSide) : null,
          ),
          child: Center(
            widthFactor: isExpanded ? null : 1.0,
            child: child,
          ),
        ),
      ),
    );

    return isExpanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
