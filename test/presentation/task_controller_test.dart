import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/core/constants/app_strings.dart';
import 'package:task_manager_app/domain/entities/task_entity.dart';
import 'package:task_manager_app/domain/entities/task_filter.dart';
import 'package:task_manager_app/domain/repositories/task_repository.dart';
import 'package:task_manager_app/presentation/controllers/task_controller.dart';

class MockTaskRepository implements TaskRepository {
  List<TaskEntity> tasksList = [];
  String? storedThemeMode;

  @override
  Future<List<TaskEntity>> getTasks() async {
    return List.from(tasksList);
  }

  @override
  Future<void> saveTask(TaskEntity task) async {
    final idx = tasksList.indexWhere((t) => t.id == task.id);
    if (idx >= 0) {
      tasksList[idx] = task;
    } else {
      tasksList.insert(0, task);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    tasksList.removeWhere((t) => t.id == id);
  }

  @override
  Future<void> toggleTaskStatus(String id) async {
    final idx = tasksList.indexWhere((t) => t.id == id);
    if (idx >= 0) {
      final item = tasksList[idx];
      tasksList[idx] = item.copyWith(isCompleted: !item.isCompleted);
    }
  }

  @override
  String? getThemeMode() => storedThemeMode;

  @override
  Future<void> setThemeMode(String mode) async {
    storedThemeMode = mode;
  }
}

void main() {
  group('TaskController', () {
    late MockTaskRepository mockRepo;
    late TaskController controller;

    setUp(() {
      mockRepo = MockTaskRepository();
      controller = TaskController(mockRepo);
    });

    test('initial state is empty with All filter and no loading', () {
      expect(controller.tasks, isEmpty);
      expect(controller.activeFilter, TaskFilter.all);
      expect(controller.isLoading, isFalse);
      expect(controller.totalCount, 0);
      expect(controller.pendingCount, 0);
      expect(controller.completedCount, 0);
    });

    test('rejects empty and whitespace-only titles with error message', () async {
      final emptyResult = await controller.addTask(title: '');
      expect(emptyResult, isFalse);
      expect(controller.errorMessage, AppStrings.titleRequiredError);

      final whitespaceResult = await controller.addTask(title: '    ');
      expect(whitespaceResult, isFalse);
      expect(controller.errorMessage, AppStrings.titleWhitespaceError);
    });

    test('adds valid task and updates metrics correctly', () async {
      final success = await controller.addTask(
        title: 'New Assessment Task',
        description: 'Complete according to PRD',
      );

      expect(success, isTrue);
      expect(controller.tasks.length, 1);
      expect(controller.totalCount, 1);
      expect(controller.pendingCount, 1);
      expect(controller.completedCount, 0);
      expect(controller.tasks.first.title, 'New Assessment Task');
    });

    test('toggles task status and updates pending/completed counts', () async {
      await controller.addTask(title: 'Task to complete');
      final taskId = controller.tasks.first.id;

      await controller.toggleTaskStatus(taskId);
      expect(controller.tasks.first.isCompleted, isTrue);
      expect(controller.completedCount, 1);
      expect(controller.pendingCount, 0);

      await controller.toggleTaskStatus(taskId);
      expect(controller.tasks.first.isCompleted, isFalse);
      expect(controller.completedCount, 0);
      expect(controller.pendingCount, 1);
    });

    test('filters tasks correctly by All, Pending, and Completed', () async {
      await controller.addTask(title: 'Task 1');
      await controller.addTask(title: 'Task 2');

      final task1Id = controller.tasks.first.id;
      await controller.toggleTaskStatus(task1Id);

      // All filter
      controller.setFilter(TaskFilter.all);
      expect(controller.filteredTasks.length, 2);

      // Pending filter
      controller.setFilter(TaskFilter.pending);
      expect(controller.filteredTasks.length, 1);
      expect(controller.filteredTasks.first.isCompleted, isFalse);

      // Completed filter
      controller.setFilter(TaskFilter.completed);
      expect(controller.filteredTasks.length, 1);
      expect(controller.filteredTasks.first.isCompleted, isTrue);
    });

    test('updates an existing task title and description', () async {
      await controller.addTask(title: 'Original Title');
      final taskId = controller.tasks.first.id;

      final updated = await controller.updateTask(
        id: taskId,
        title: 'Revised Title',
        description: 'Updated Description',
      );

      expect(updated, isTrue);
      expect(controller.tasks.first.title, 'Revised Title');
      expect(controller.tasks.first.description, 'Updated Description');
    });

    test('deletes task and removes it from state', () async {
      await controller.addTask(title: 'Task to remove');
      expect(controller.totalCount, 1);

      final taskId = controller.tasks.first.id;
      await controller.deleteTask(taskId);

      expect(controller.totalCount, 0);
      expect(controller.tasks, isEmpty);
    });

    test('calculates completion rate and percentage accurately', () async {
      expect(controller.completionRate, 0.0);
      expect(controller.completionPercentage, 0);

      await controller.addTask(title: 'Task 1');
      await controller.addTask(title: 'Task 2');
      expect(controller.totalCount, 2);
      expect(controller.completionRate, 0.0);
      expect(controller.completionPercentage, 0);

      await controller.toggleTaskStatus(controller.tasks.first.id);
      expect(controller.completionRate, 0.5);
      expect(controller.completionPercentage, 50);

      await controller.toggleTaskStatus(controller.tasks.last.id);
      expect(controller.completionRate, 1.0);
      expect(controller.completionPercentage, 100);
    });

    test('toggles theme mode between light and dark and persists choice', () async {
      expect(controller.themeMode, ThemeMode.system);
      expect(controller.isDarkMode, isFalse);

      await controller.toggleTheme();
      expect(controller.themeMode, ThemeMode.dark);
      expect(controller.isDarkMode, isTrue);
      expect(mockRepo.storedThemeMode, 'dark');

      await controller.toggleTheme();
      expect(controller.themeMode, ThemeMode.light);
      expect(controller.isDarkMode, isFalse);
      expect(mockRepo.storedThemeMode, 'light');
    });
  });
}
