/// Centralized user-facing strings across the application.
abstract final class AppStrings {
  // App General
  static const String appName = 'Task Manager';
  static const String appTagline = 'Stay organized, daily.';

  // Home Screen
  static const String homeTitle = 'Task Flow';
  static const String totalTasks = 'Total';
  static const String pendingTasks = 'Pending';
  static const String completedTasks = 'Completed';

  // Filters
  static const String filterAll = 'All';
  static const String filterPending = 'Pending';
  static const String filterCompleted = 'Completed';

  // Task Form (Add / Edit)
  static const String addTaskTitle = 'New Task';
  static const String editTaskTitle = 'Edit Task';
  static const String titleLabel = 'Task Title';
  static const String titleHint = 'What needs to be done?';
  static const String descriptionLabel = 'Description (Optional)';
  static const String descriptionHint = 'Add any additional notes or details...';
  static const String saveButton = 'Save Task';
  static const String updateButton = 'Update Task';
  static const String cancelButton = 'Cancel';

  // Validation Messages
  static const String titleRequiredError = 'Task title cannot be empty';
  static const String titleWhitespaceError = 'Title cannot contain only spaces';

  // Confirmation Dialog
  static const String deleteDialogTitle = 'Delete Task?';
  static const String deleteDialogContent =
      'Are you sure you want to delete this task? This action cannot be undone.';
  static const String deleteConfirmButton = 'Delete';

  // Empty States
  static const String emptyAllTitle = 'No tasks yet';
  static const String emptyAllSubtitle =
      'Tap the button below to add your first task and start staying productive.';
  static const String emptyPendingTitle = 'All caught up!';
  static const String emptyPendingSubtitle =
      'You have no pending tasks right now. Great job!';
  static const String emptyCompletedTitle = 'No completed tasks';
  static const String emptyCompletedSubtitle =
      'Complete tasks from your list to see them reflected here.';

  // Snackbars & Feedback
  static const String taskCreatedMessage = 'Task created successfully';
  static const String taskUpdatedMessage = 'Task updated successfully';
  static const String taskDeletedMessage = 'Task deleted';
  static const String taskCompletedMessage = 'Task marked as completed';
  static const String taskPendingMessage = 'Task marked as pending';
}
