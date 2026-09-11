import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../domain/entities/task_filter.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/task/task_card.dart';
import '../../widgets/task/task_filter_chips.dart';
import '../task_form/task_form_screen.dart';

/// Main home dashboard screen displaying task metrics, filter chips, and task list.
class HomeScreen extends StatelessWidget {
  final TaskController controller;

  const HomeScreen({
    super.key,
    required this.controller,
  });

  void _navigateToCreateTask(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(controller: controller),
      ),
    );
  }

  void _navigateToEditTask(BuildContext context, TaskEntity task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(
          controller: controller,
          task: task,
        ),
      ),
    );
  }

  Future<void> _handleDeleteTask(BuildContext context, TaskEntity task) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: AppStrings.deleteDialogTitle,
      message: 'Are you sure you want to delete "${task.title}"?',
    );

    if (confirmed) {
      await controller.deleteTask(task.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.taskDeletedMessage),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    switch (controller.activeFilter) {
      case TaskFilter.all:
        return AppEmptyState(
          icon: Icons.checklist_rounded,
          title: AppStrings.emptyAllTitle,
          subtitle: AppStrings.emptyAllSubtitle,
          actionLabel: 'Add Your First Task',
          onAction: () => _navigateToCreateTask(context),
        );
      case TaskFilter.pending:
        return const AppEmptyState(
          icon: Icons.task_alt_rounded,
          title: AppStrings.emptyPendingTitle,
          subtitle: AppStrings.emptyPendingSubtitle,
        );
      case TaskFilter.completed:
        return const AppEmptyState(
          icon: Icons.done_all_rounded,
          title: AppStrings.emptyCompletedTitle,
          subtitle: AppStrings.emptyCompletedSubtitle,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final tasks = controller.filteredTasks;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(AppStrings.homeTitle),
                Text(
                  '${controller.pendingCount} pending, ${controller.completedCount} completed',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Filter Chips Bar
                TaskFilterChips(
                  activeFilter: controller.activeFilter,
                  totalCount: controller.totalCount,
                  pendingCount: controller.pendingCount,
                  completedCount: controller.completedCount,
                  onFilterChanged: controller.setFilter,
                ),

                const SizedBox(height: AppDimensions.spaceXS),

                // Main Tasks View
                Expanded(
                  child: controller.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.primary,
                          ),
                        )
                      : tasks.isEmpty
                          ? _buildEmptyState(context)
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                AppDimensions.spaceMD,
                                AppDimensions.spaceSM,
                                AppDimensions.spaceMD,
                                AppDimensions.spaceXXL + 32, // Space for FAB
                              ),
                              itemCount: tasks.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: AppDimensions.spaceSM + 2),
                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                return TaskCard(
                                  task: task,
                                  onToggle: () => controller.toggleTaskStatus(task.id),
                                  onTap: () => _navigateToEditTask(context, task),
                                  onDelete: () => _handleDeleteTask(context, task),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _navigateToCreateTask(context),
            icon: const Icon(Icons.add_rounded, size: AppDimensions.iconLG),
            label: const Text(
              'Add Task',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}
