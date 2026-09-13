import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/task_entity.dart';
import 'task_status_badge.dart';

/// Elevated, interactive task item card with swipe gestures, status accent strip,
/// and smooth micro-animations.
class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final Future<bool?> Function(DismissDirection)? onConfirmDismiss;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
    this.onConfirmDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final cardBorder = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    final statusColor = task.isCompleted ? AppColors.success : AppColors.warning;

    final cardContent = Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppDimensions.borderRadiusLarge,
        border: Border.all(
          color: task.isCompleted
              ? cardBorder.withValues(alpha: 0.6)
              : cardBorder,
          width: 1.2,
        ),
        boxShadow: isDark
            ? [
                const BoxShadow(
                  color: Color(0x22000000),
                  offset: Offset(0, 2),
                  blurRadius: 8,
                ),
              ]
            : AppDimensions.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: AppDimensions.borderRadiusLarge,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vertical Left Status Accent Stripe (4px)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 4.5,
                color: statusColor,
              ),

              // Card Inner Content
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Circular Animated Status Toggle Checkbox
                          GestureDetector(
                            onTap: onToggle,
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0, right: 12.0),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeOutBack,
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: task.isCompleted
                                      ? AppColors.success
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: task.isCompleted
                                        ? AppColors.success
                                        : textMuted,
                                    width: 2,
                                  ),
                                ),
                                child: AnimatedScale(
                                  scale: task.isCompleted ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOutBack,
                                  child: const Icon(
                                    Icons.check_rounded,
                                    size: 16,
                                    color: AppColors.surface,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Center Content (Title, Description, Footer)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Animated Title with Strikethrough
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: TextStyle(
                                    color: task.isCompleted
                                        ? textMuted
                                        : textPrimary,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.2,
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    decorationColor: textMuted,
                                    decorationThickness: 1.8,
                                  ),
                                  child: Text(
                                    task.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                // Optional Description
                                if (task.description != null &&
                                    task.description!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    task.description!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: task.isCompleted
                                          ? textMuted.withValues(alpha: 0.8)
                                          : textSecondary,
                                      fontSize: 13.5,
                                      height: 1.4,
                                    ),
                                  ),
                                ],

                                const SizedBox(height: AppDimensions.spaceSM + 2),

                                // Footer: Status Badge & Creation Date
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: AppDimensions.spaceSM,
                                  runSpacing: 4,
                                  children: [
                                    TaskStatusBadge(isCompleted: task.isCompleted),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          size: 13,
                                          color: textMuted,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          DateFormatter.format(task.createdAt),
                                          style: TextStyle(
                                            color: textMuted,
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Delete Action Button
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: textMuted,
                              size: AppDimensions.iconMD + 2,
                            ),
                            splashRadius: 20,
                            tooltip: 'Delete Task',
                            onPressed: onDelete,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (onConfirmDismiss == null) {
      return cardContent;
    }

    return Dismissible(
      key: ValueKey(task.id),
      confirmDismiss: onConfirmDismiss,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.85),
          borderRadius: AppDimensions.borderRadiusLarge,
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLG),
        child: const Row(
          children: [
            Icon(Icons.check_circle_outline_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Toggle Status',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.85),
          borderRadius: AppDimensions.borderRadiusLarge,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLG),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete_outline_rounded, color: Colors.white),
          ],
        ),
      ),
      child: cardContent,
    );
  }
}
