import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/task_entity.dart';
import 'task_status_badge.dart';

/// Clean, interactive task item card adhering to the design system.
class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.borderRadiusLarge,
        border: Border.all(
          color: task.isCompleted
              ? AppColors.border.withValues(alpha: 0.7)
              : AppColors.border,
          width: 1.2,
        ),
        boxShadow: AppDimensions.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppDimensions.borderRadiusLarge,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDimensions.borderRadiusLarge,
          child: Padding(
            padding: AppDimensions.paddingCard,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circular Status Toggle Button
                GestureDetector(
                  onTap: onToggle,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0, right: AppDimensions.spaceMD),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
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
                              : AppColors.textMuted,
                          width: 2,
                        ),
                      ),
                      child: task.isCompleted
                          ? const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: AppColors.surface,
                            )
                          : null,
                    ),
                  ),
                ),

                // Center Content (Title, Description, Footer)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task Title
                      Text(
                        task.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: task.isCompleted
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: AppColors.textMuted,
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
                                ? AppColors.textMuted.withValues(alpha: 0.8)
                                : AppColors.textSecondary,
                            fontSize: 13.5,
                            height: 1.4,
                          ),
                        ),
                      ],

                      const SizedBox(height: AppDimensions.spaceSM + 2),

                      // Footer: Date & Status Badge
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: AppDimensions.spaceSM,
                        runSpacing: 4,
                        children: [
                          TaskStatusBadge(isCompleted: task.isCompleted),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 13,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                DateFormatter.format(task.createdAt),
                                style: const TextStyle(
                                  color: AppColors.textMuted,
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
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.textMuted,
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
    );
  }
}
