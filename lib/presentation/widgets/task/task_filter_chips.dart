import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../domain/entities/task_filter.dart';

/// Row of filter chips (All, Pending, Completed) with live count indicators.
class TaskFilterChips extends StatelessWidget {
  final TaskFilter activeFilter;
  final int totalCount;
  final int pendingCount;
  final int completedCount;
  final ValueChanged<TaskFilter> onFilterChanged;

  const TaskFilterChips({
    super.key,
    required this.activeFilter,
    required this.totalCount,
    required this.pendingCount,
    required this.completedCount,
    required this.onFilterChanged,
  });

  int _countForFilter(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return totalCount;
      case TaskFilter.pending:
        return pendingCount;
      case TaskFilter.completed:
        return completedCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMD,
        vertical: AppDimensions.spaceSM,
      ),
      child: Row(
        children: TaskFilter.values.map((filter) {
          final isSelected = filter == activeFilter;
          final count = _countForFilter(filter);

          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spaceSM),
            child: Material(
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: AppDimensions.borderRadiusFull,
              elevation: 0,
              child: InkWell(
                onTap: () => onFilterChanged(filter),
                borderRadius: AppDimensions.borderRadiusFull,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: AppDimensions.borderRadiusFull,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        filter.label,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.surface
                              : AppColors.textPrimary,
                          fontSize: 13.5,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceSM),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.surface.withValues(alpha: 0.2)
                              : AppColors.surfaceSubtle,
                          borderRadius: AppDimensions.borderRadiusFull,
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.surface
                                : AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
