import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Elevated productivity dashboard header card displaying live task completion progress.
class TaskProgressHeader extends StatelessWidget {
  final int totalCount;
  final int pendingCount;
  final int completedCount;
  final double completionRate;
  final int completionPercentage;

  const TaskProgressHeader({
    super.key,
    required this.totalCount,
    required this.pendingCount,
    required this.completedCount,
    required this.completionRate,
    required this.completionPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final cardBorder = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    String headlineText;
    if (totalCount == 0) {
      headlineText = 'No tasks yet. Ready to start?';
    } else if (completionRate >= 1.0) {
      headlineText = '🎉 All tasks completed! Excellent work.';
    } else {
      headlineText = '$completedCount of $totalCount completed';
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMD,
        vertical: AppDimensions.spaceSM,
      ),
      padding: const EdgeInsets.all(AppDimensions.spaceMD + 2),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppDimensions.borderRadiusLarge,
        border: Border.all(color: cardBorder, width: 1.2),
        boxShadow: isDark
            ? [
                const BoxShadow(
                  color: Color(0x22000000),
                  offset: Offset(0, 4),
                  blurRadius: 12,
                ),
              ]
            : AppDimensions.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title & Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Today\'s Progress',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              if (totalCount > 0)
                Text(
                  '$completionPercentage%',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 4),

          // Subtitle Status
          Text(
            headlineText,
            style: TextStyle(
              color: textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: AppDimensions.spaceMD),

          // Animated Smooth Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 7,
              color: isDark ? AppColors.darkSurfaceSubtle : AppColors.surfaceSubtle,
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(
                  begin: 0.0,
                  end: completionRate,
                ),
                builder: (context, value, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.progressGradient,
                        borderRadius: BorderRadius.all(Radius.circular(999)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spaceMD),

          // Mini Stats Pills Row
          Row(
            children: [
              _buildMiniStat(
                label: 'Total',
                count: totalCount,
                color: textSecondary,
                isDark: isDark,
              ),
              const SizedBox(width: AppDimensions.spaceSM),
              _buildMiniStat(
                label: 'Pending',
                count: pendingCount,
                color: AppColors.warning,
                isDark: isDark,
              ),
              const SizedBox(width: AppDimensions.spaceSM),
              _buildMiniStat(
                label: 'Done',
                count: completedCount,
                color: AppColors.success,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat({
    required String label,
    required int count,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $count',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
