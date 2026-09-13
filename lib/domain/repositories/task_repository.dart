import '../entities/task_entity.dart';

/// Abstract domain repository defining contract for task data access.
/// Decoupled from any concrete storage engine or network provider.
abstract interface class TaskRepository {
  /// Retrieves all tasks ordered by creation date descending.
  Future<List<TaskEntity>> getTasks();

  /// Saves or updates a task. If a task with the same ID exists, it is overwritten.
  Future<void> saveTask(TaskEntity task);

  /// Deletes a task by its unique [id].
  Future<void> deleteTask(String id);

  /// Toggles the completion status of the task identified by [id].
  Future<void> toggleTaskStatus(String id);

  /// Retrieves the saved theme mode string ('system', 'light', 'dark').
  String? getThemeMode();

  /// Saves the selected theme mode string.
  Future<void> setThemeMode(String mode);
}
