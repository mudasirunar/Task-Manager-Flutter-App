import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../domain/entities/task_filter.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/common/app_snackbar.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/task/task_card.dart';
import '../../widgets/task/task_filter_chips.dart';
import '../../widgets/task/task_progress_header.dart';
import '../task_form/task_form_screen.dart';

/// Main home dashboard screen displaying task metrics, filter chips, and task list.
class HomeScreen extends StatelessWidget {
  final TaskController controller;

  const HomeScreen({
    super.key,
    required this.controller,
  });

  void _navigateToCreateTask(BuildContext context) {
    AppSnackBar.dismiss(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(controller: controller),
      ),
    );
  }

  void _navigateToEditTask(BuildContext context, TaskEntity task) {
    AppSnackBar.dismiss(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(
          controller: controller,
          task: task,
        ),
      ),
    );
  }

  void _handleDeleteTask(BuildContext context, TaskEntity task) {
    controller.deleteTask(task.id);
    if (context.mounted) {
      AppSnackBar.showDelete(
        context,
        taskTitle: task.title,
        onUndo: () => controller.restoreTask(task),
      );
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    // When there are no tasks in the app at all, all tabs show the CTA button to create the first task.
    if (controller.totalCount == 0) {
      return AppEmptyState(
        icon: Icons.checklist_rounded,
        title: AppStrings.emptyAllTitle,
        subtitle: AppStrings.emptyAllSubtitle,
        actionLabel: 'Add Your First Task',
        onAction: () => _navigateToCreateTask(context),
      );
    }

    // When at least one task exists in the app, show specific filter messages.
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
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.asset(
                      'assets/app_icon.png',
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  AppStrings.homeTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: controller.isDarkMode
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
                icon: Icon(
                  controller.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                onPressed: () => controller.toggleTheme(context),
              ),
              const SizedBox(width: AppDimensions.spaceSM),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Productivity Overview Card
              if (controller.totalCount > 0)
                TaskProgressHeader(
                  totalCount: controller.totalCount,
                  pendingCount: controller.pendingCount,
                  completedCount: controller.completedCount,
                  completionRate: controller.completionRate,
                  completionPercentage: controller.completionPercentage,
                ),

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
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    : tasks.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.builder(
                            padding: EdgeInsets.fromLTRB(
                              AppDimensions.spaceMD,
                              AppDimensions.spaceSM,
                              AppDimensions.spaceMD,
                              controller.totalCount > 0
                                  ? 80.0
                                  : AppDimensions.spaceMD,
                            ),
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return TaskCard(
                                key: ValueKey(task.id),
                                task: task,
                                onToggle: () =>
                                    controller.toggleTaskStatus(task.id),
                                onTap: () =>
                                    _navigateToEditTask(context, task),
                                onDelete: () =>
                                    _handleDeleteTask(context, task),
                                onConfirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    // Swipe right: toggle status
                                    await controller.toggleTaskStatus(task.id);
                                    return false;
                                  } else if (direction ==
                                      DismissDirection.endToStart) {
                                    // Swipe left: delete
                                    final confirmed =
                                        await ConfirmationDialog.show(
                                      context,
                                      title: AppStrings.deleteDialogTitle,
                                      message:
                                          'Are you sure you want to delete "${task.title}"?',
                                    );
                                    if (confirmed) {
                                      await Future.delayed(
                                        const Duration(milliseconds: 140),
                                      );
                                      return true;
                                    }
                                    return false;
                                  }
                                  return false;
                                },
                                onDismissed: (direction) {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    TaskCard.removeSeen(task.id);
                                    controller.deleteTask(task.id);
                                    if (context.mounted) {
                                      AppSnackBar.showDelete(
                                        context,
                                        taskTitle: task.title,
                                        onUndo: () =>
                                            controller.restoreTask(task),
                                      );
                                    }
                                  }
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
          // Only show FAB when there are tasks; on empty state, the central action button is shown.
          floatingActionButton: controller.totalCount > 0
              ? FloatingActionButton.extended(
                  onPressed: () => _navigateToCreateTask(context),
                  icon: const Icon(
                    Icons.add_rounded,
                    size: AppDimensions.iconLG,
                  ),
                  label: const Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
