import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Semantic pill badge showing task status (Pending or Completed).
class TaskStatusBadge extends StatelessWidget {
  final bool isCompleted;

  const TaskStatusBadge({
    super.key,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? (isCompleted ? AppColors.darkSuccessLight : AppColors.darkWarningLight)
        : (isCompleted ? AppColors.successLight : AppColors.warningLight);
    final foregroundColor =
        isCompleted ? AppColors.success : AppColors.warning;
    final label = isCompleted ? 'Completed' : 'Pending';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSM,
        vertical: 3.5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppDimensions.borderRadiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: foregroundColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceXS + 1),
          Text(
            label,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
