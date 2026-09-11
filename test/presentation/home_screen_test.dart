import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/core/constants/app_strings.dart';
import 'package:task_manager_app/domain/entities/task_entity.dart';
import 'package:task_manager_app/domain/repositories/task_repository.dart';
import 'package:task_manager_app/presentation/controllers/task_controller.dart';
import 'package:task_manager_app/presentation/screens/home/home_screen.dart';
import 'package:task_manager_app/presentation/widgets/task/task_card.dart';

class MockTaskRepository implements TaskRepository {
  List<TaskEntity> tasks = [];

  @override
  Future<List<TaskEntity>> getTasks() async => List.from(tasks);

  @override
  Future<void> saveTask(TaskEntity task) async {
    final idx = tasks.indexWhere((t) => t.id == task.id);
    if (idx >= 0) {
      tasks[idx] = task;
    } else {
      tasks.insert(0, task);
    }
  }

  @override
  Future<void> deleteTask(String id) async => tasks.removeWhere((t) => t.id == id);

  @override
  Future<void> toggleTaskStatus(String id) async {
    final idx = tasks.indexWhere((t) => t.id == id);
    if (idx >= 0) {
      tasks[idx] = tasks[idx].copyWith(isCompleted: !tasks[idx].isCompleted);
    }
  }
}

void main() {
  group('HomeScreen Tests', () {
    late MockTaskRepository mockRepo;
    late TaskController controller;

    setUp(() {
      mockRepo = MockTaskRepository();
      controller = TaskController(mockRepo);
    });

    Widget buildTestWidget() {
      return MaterialApp(
        home: HomeScreen(controller: controller),
      );
    }

    testWidgets('shows empty state when no tasks exist', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.emptyAllTitle), findsOneWidget);
      expect(find.text(AppStrings.emptyAllSubtitle), findsOneWidget);
    });

    testWidgets('renders list of tasks when tasks are added', (tester) async {
      final now = DateTime(2026, 9, 12);
      mockRepo.tasks = [
        TaskEntity(
          id: '1',
          title: 'First Task',
          isCompleted: false,
          createdAt: now,
          updatedAt: now,
        ),
        TaskEntity(
          id: '2',
          title: 'Second Task',
          isCompleted: true,
          createdAt: now,
          updatedAt: now,
        ),
      ];
      await controller.loadTasks();

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TaskCard), findsNWidgets(2));
      expect(find.text('First Task'), findsOneWidget);
      expect(find.text('Second Task'), findsOneWidget);
    });

    testWidgets('canceling deletion dialog preserves the task', (tester) async {
      final now = DateTime(2026, 9, 12);
      mockRepo.tasks = [
        TaskEntity(
          id: '1',
          title: 'Task To Delete',
          isCompleted: false,
          createdAt: now,
          updatedAt: now,
        ),
      ];
      await controller.loadTasks();

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap delete icon button
      await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
      await tester.pumpAndSettle();

      // Verify dialog is visible
      expect(find.text(AppStrings.deleteDialogTitle), findsOneWidget);

      // Tap Cancel button
      await tester.tap(find.text(AppStrings.cancelButton));
      await tester.pumpAndSettle();

      // Verify task still exists
      expect(find.byType(TaskCard), findsOneWidget);
      expect(controller.tasks.length, 1);
    });

    testWidgets('confirming deletion removes the task', (tester) async {
      final now = DateTime(2026, 9, 12);
      mockRepo.tasks = [
        TaskEntity(
          id: '1',
          title: 'Task To Delete',
          isCompleted: false,
          createdAt: now,
          updatedAt: now,
        ),
      ];
      await controller.loadTasks();

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap delete icon button
      await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
      await tester.pumpAndSettle();

      // Tap Confirm Delete button in dialog
      await tester.tap(find.text(AppStrings.deleteConfirmButton));
      await tester.pumpAndSettle();

      // Verify task removed and empty state shown
      expect(find.byType(TaskCard), findsNothing);
      expect(controller.tasks, isEmpty);
    });
  });
}
