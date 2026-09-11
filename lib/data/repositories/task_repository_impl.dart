import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_model.dart';

/// Concrete implementation of [TaskRepository] bridging domain contracts to the local data source.
class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _localDataSource;

  const TaskRepositoryImpl(this._localDataSource);

  @override
  Future<List<TaskEntity>> getTasks() async {
    final models = await _localDataSource.getCachedTasks();
    // Sort tasks by creation date descending (newest first)
    models.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return models;
  }

  @override
  Future<void> saveTask(TaskEntity task) async {
    final currentModels = await _localDataSource.getCachedTasks();
    final taskModel = TaskModel.fromEntity(task);

    final existingIndex = currentModels.indexWhere((m) => m.id == task.id);
    if (existingIndex >= 0) {
      currentModels[existingIndex] = taskModel;
    } else {
      currentModels.insert(0, taskModel);
    }

    await _localDataSource.cacheTasks(currentModels);
  }

  @override
  Future<void> deleteTask(String id) async {
    final currentModels = await _localDataSource.getCachedTasks();
    currentModels.removeWhere((m) => m.id == id);
    await _localDataSource.cacheTasks(currentModels);
  }

  @override
  Future<void> toggleTaskStatus(String id) async {
    final currentModels = await _localDataSource.getCachedTasks();
    final index = currentModels.indexWhere((m) => m.id == id);

    if (index >= 0) {
      final target = currentModels[index];
      currentModels[index] = target.copyWith(
        isCompleted: !target.isCompleted,
        updatedAt: DateTime.now(),
      );
      await _localDataSource.cacheTasks(currentModels);
    }
  }
}
