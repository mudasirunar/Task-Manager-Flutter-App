import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_filter.dart';
import '../../domain/repositories/task_repository.dart';

/// State management controller managing task business state and theme using [ChangeNotifier].
class TaskController extends ChangeNotifier {
  final TaskRepository _repository;

  TaskController(this._repository) {
    _initTheme();
  }

  List<TaskEntity> _tasks = [];
  TaskFilter _activeFilter = TaskFilter.all;
  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<TaskEntity> get tasks => List.unmodifiable(_tasks);
  TaskFilter get activeFilter => _activeFilter;
  ThemeMode get themeMode => _themeMode;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Computed list filtered by [_activeFilter].
  List<TaskEntity> get filteredTasks {
    switch (_activeFilter) {
      case TaskFilter.all:
        return _tasks;
      case TaskFilter.pending:
        return _tasks.where((t) => !t.isCompleted).toList();
      case TaskFilter.completed:
        return _tasks.where((t) => t.isCompleted).toList();
    }
  }

  // Live Metrics & Productivity Overview
  int get totalCount => _tasks.length;
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;

  /// Whether current theme is dark.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Normalized completion progress between 0.0 and 1.0.
  double get completionRate =>
      totalCount == 0 ? 0.0 : (completedCount / totalCount).clamp(0.0, 1.0);

  /// Completion percentage formatted as integer (0 to 100).
  int get completionPercentage => (completionRate * 100).round();

  /// Initializes the stored theme mode.
  void _initTheme() {
    final stored = _repository.getThemeMode();
    if (stored == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (stored == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
  }

  /// Toggles theme between Light and Dark and persists the selection.
  Future<void> toggleTheme([BuildContext? context]) async {
    final bool isCurrentlyDark;
    if (context != null && _themeMode == ThemeMode.system) {
      isCurrentlyDark =
          MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    } else {
      isCurrentlyDark = _themeMode == ThemeMode.dark;
    }

    _themeMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();

    await _repository.setThemeMode(_themeMode == ThemeMode.dark ? 'dark' : 'light');
  }

  /// Explicitly sets the theme mode.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      await _repository.setThemeMode(mode.name);
    }
  }

  /// Sets the active filter and notifies listeners.
  void setFilter(TaskFilter filter) {
    if (_activeFilter != filter) {
      _activeFilter = filter;
      notifyListeners();
    }
  }

  /// Loads tasks from the repository.
  Future<void> loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _repository.getTasks();
    } catch (e) {
      _errorMessage = 'Failed to load tasks: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a new task after strict title validation.
  /// Returns `true` if successful, or `false` if rejected.
  Future<bool> addTask({
    required String title,
    String? description,
  }) async {
    final validationError = Validators.validateTitle(title);
    if (validationError != null) {
      _errorMessage = validationError;
      notifyListeners();
      return false;
    }

    final trimmedTitle = title.trim();
    final trimmedDesc = description?.trim().isEmpty ?? true
        ? null
        : description!.trim();

    final now = DateTime.now();
    final newTask = TaskEntity(
      id: 'task_${now.microsecondsSinceEpoch}',
      title: trimmedTitle,
      description: trimmedDesc,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _repository.saveTask(newTask);
      _tasks = await _repository.getTasks();
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create task: $e';
      notifyListeners();
      return false;
    }
  }

  /// Updates an existing task with new title and optional description.
  Future<bool> updateTask({
    required String id,
    required String title,
    String? description,
  }) async {
    final validationError = Validators.validateTitle(title);
    if (validationError != null) {
      _errorMessage = validationError;
      notifyListeners();
      return false;
    }

    final existingIndex = _tasks.indexWhere((t) => t.id == id);
    if (existingIndex < 0) return false;

    final existingTask = _tasks[existingIndex];
    final trimmedTitle = title.trim();
    final trimmedDesc = description?.trim().isEmpty ?? true
        ? null
        : description!.trim();

    final updatedTask = existingTask.copyWith(
      title: trimmedTitle,
      description: trimmedDesc,
      updatedAt: DateTime.now(),
    );

    try {
      await _repository.saveTask(updatedTask);
      _tasks = await _repository.getTasks();
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update task: $e';
      notifyListeners();
      return false;
    }
  }

  /// Toggles task status between pending and completed.
  Future<void> toggleTaskStatus(String id) async {
    try {
      await _repository.toggleTaskStatus(id);
      _tasks = await _repository.getTasks();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update task status: $e';
      notifyListeners();
    }
  }

  /// Deletes a task by ID.
  Future<void> deleteTask(String id) async {
    try {
      await _repository.deleteTask(id);
      _tasks = await _repository.getTasks();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete task: $e';
      notifyListeners();
    }
  }

  /// Clears any transient error message.
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}
