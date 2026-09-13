import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/data/datasources/task_local_datasource.dart';
import 'package:task_manager_app/data/models/task_model.dart';
import 'package:task_manager_app/data/repositories/task_repository_impl.dart';
import 'package:task_manager_app/domain/entities/task_entity.dart';

class FakeTaskLocalDataSource implements TaskLocalDataSource {
  List<TaskModel> storedTasks = [];
  String? storedThemeMode;

  @override
  Future<List<TaskModel>> getCachedTasks() async {
    return List.from(storedTasks);
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    storedTasks = List.from(tasks);
  }

  @override
  Future<void> clearTasks() async {
    storedTasks.clear();
  }

  @override
  String? getStoredThemeMode() => storedThemeMode;

  @override
  Future<void> saveThemeMode(String mode) async {
    storedThemeMode = mode;
  }
}

void main() {
  group('TaskRepositoryImpl', () {
    late FakeTaskLocalDataSource fakeDataSource;
    late TaskRepositoryImpl repository;

    final baseTime = DateTime(2026, 9, 12, 10, 0);

    setUp(() {
      fakeDataSource = FakeTaskLocalDataSource();
      repository = TaskRepositoryImpl(fakeDataSource);
    });

    test('saves a new task and retrieves it sorted by createdAt descending', () async {
      final task1 = TaskEntity(
        id: '1',
        title: 'First Task',
        createdAt: baseTime,
        updatedAt: baseTime,
      );
      final task2 = TaskEntity(
        id: '2',
        title: 'Second Task',
        createdAt: baseTime.add(const Duration(hours: 1)),
        updatedAt: baseTime.add(const Duration(hours: 1)),
      );

      await repository.saveTask(task1);
      await repository.saveTask(task2);

      final tasks = await repository.getTasks();
      expect(tasks.length, 2);
      expect(tasks[0].id, '2'); // Newer task comes first
      expect(tasks[1].id, '1');
    });

    test('updates existing task content when saving with existing id', () async {
      final task = TaskEntity(
        id: '1',
        title: 'Original Title',
        description: 'Original Desc',
        createdAt: baseTime,
        updatedAt: baseTime,
      );

      await repository.saveTask(task);

      final updatedTask = task.copyWith(
        title: 'Updated Title',
        description: 'Updated Desc',
      );
      await repository.saveTask(updatedTask);

      final tasks = await repository.getTasks();
      expect(tasks.length, 1);
      expect(tasks.first.title, 'Updated Title');
      expect(tasks.first.description, 'Updated Desc');
    });

    test('toggles task status correctly', () async {
      final task = TaskEntity(
        id: '1',
        title: 'Task to toggle',
        isCompleted: false,
        createdAt: baseTime,
        updatedAt: baseTime,
      );

      await repository.saveTask(task);
      await repository.toggleTaskStatus('1');

      var tasks = await repository.getTasks();
      expect(tasks.first.isCompleted, isTrue);

      await repository.toggleTaskStatus('1');
      tasks = await repository.getTasks();
      expect(tasks.first.isCompleted, isFalse);
    });

    test('deletes a task by id', () async {
      final task1 = TaskEntity(
        id: '1',
        title: 'Task 1',
        createdAt: baseTime,
        updatedAt: baseTime,
      );
      final task2 = TaskEntity(
        id: '2',
        title: 'Task 2',
        createdAt: baseTime,
        updatedAt: baseTime,
      );

      await repository.saveTask(task1);
      await repository.saveTask(task2);

      await repository.deleteTask('1');

      final tasks = await repository.getTasks();
      expect(tasks.length, 1);
      expect(tasks.first.id, '2');
    });

    test('retrieves and persists theme mode', () async {
      expect(repository.getThemeMode(), isNull);

      await repository.setThemeMode('dark');
      expect(repository.getThemeMode(), 'dark');

      await repository.setThemeMode('light');
      expect(repository.getThemeMode(), 'light');
    });
  });
}
