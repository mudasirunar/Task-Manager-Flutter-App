import '../models/task_model.dart';

/// Abstract contract for local persistent storage of tasks and user preferences.
abstract interface class TaskLocalDataSource {
  /// Fetches cached tasks from storage. Returns empty list if none exist.
  Future<List<TaskModel>> getCachedTasks();

  /// Persists the list of tasks to storage.
  Future<void> cacheTasks(List<TaskModel> tasks);

  /// Clears all tasks from storage.
  Future<void> clearTasks();

  /// Retrieves the saved theme mode string ('system', 'light', 'dark').
  String? getStoredThemeMode();

  /// Persists the selected theme mode string.
  Future<void> saveThemeMode(String mode);
}
