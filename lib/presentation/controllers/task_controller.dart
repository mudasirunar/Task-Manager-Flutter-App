import 'package:flutter/foundation.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_filter.dart';
import '../../domain/repositories/task_repository.dart';

/// State management controller managing task business state using [ChangeNotifier].
class TaskController extends ChangeNotifier {
  final TaskRepository _repository;

  TaskController(this._repository);

  List<TaskEntity> _tasks = [];
  TaskFilter _activeFilter = TaskFilter.all;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<TaskEntity> get tasks => List.unmodifiable(_tasks);
  TaskFilter get activeFilter => _activeFilter;
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

  // Live Metrics
  int get totalCount => _tasks.length;
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;

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
