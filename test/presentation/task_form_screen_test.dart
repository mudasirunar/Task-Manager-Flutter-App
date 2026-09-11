import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/core/constants/app_strings.dart';
import 'package:task_manager_app/domain/entities/task_entity.dart';
import 'package:task_manager_app/domain/repositories/task_repository.dart';
import 'package:task_manager_app/presentation/controllers/task_controller.dart';
import 'package:task_manager_app/presentation/screens/task_form/task_form_screen.dart';

class FakeTaskRepository implements TaskRepository {
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
  Future<void> toggleTaskStatus(String id) async {}
}

void main() {
  group('TaskFormScreen Validation & Submission', () {
    late FakeTaskRepository fakeRepo;
    late TaskController controller;

    setUp(() {
      fakeRepo = FakeTaskRepository();
      controller = TaskController(fakeRepo);
    });

    Widget buildTestWidget({TaskEntity? task}) {
      return MaterialApp(
        home: TaskFormScreen(
          controller: controller,
          task: task,
        ),
      );
    }

    testWidgets('rejects blank title and shows required error', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Tap Save without entering title
      await tester.tap(find.text(AppStrings.saveButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.titleRequiredError), findsOneWidget);
      expect(fakeRepo.tasks, isEmpty);
    });

    testWidgets('rejects whitespace-only title and shows whitespace error', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Enter only spaces
      final titleField = find.byType(TextFormField).first;
      await tester.enterText(titleField, '     ');
      await tester.tap(find.text(AppStrings.saveButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.titleWhitespaceError), findsOneWidget);
      expect(fakeRepo.tasks, isEmpty);
    });

    testWidgets('successfully creates task with valid title and description', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'Complete Assignment');
      await tester.enterText(textFields.last, 'Ensure Clean Architecture');

      await tester.tap(find.text(AppStrings.saveButton));
      await tester.pumpAndSettle();

      expect(controller.tasks.length, 1);
      expect(controller.tasks.first.title, 'Complete Assignment');
      expect(controller.tasks.first.description, 'Ensure Clean Architecture');
    });

    testWidgets('pre-populates existing task data in edit mode', (tester) async {
      final existingTask = TaskEntity(
        id: '123',
        title: 'Existing Task',
        description: 'Existing Description',
        createdAt: DateTime(2026, 9, 12),
        updatedAt: DateTime(2026, 9, 12),
      );

      await tester.pumpWidget(buildTestWidget(task: existingTask));

      expect(find.text(AppStrings.editTaskTitle), findsOneWidget);
      expect(find.text('Existing Task'), findsOneWidget);
      expect(find.text('Existing Description'), findsOneWidget);
      expect(find.text(AppStrings.updateButton), findsOneWidget);
    });
  });
}
