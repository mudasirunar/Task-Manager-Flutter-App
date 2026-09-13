import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/core/constants/app_strings.dart';
import 'package:task_manager_app/domain/entities/task_entity.dart';
import 'package:task_manager_app/presentation/widgets/task/task_card.dart';

void main() {
  group('TaskCard Animation & Interaction Tests', () {
    setUp(() {
      TaskCard.clearSeen();
    });

    final testTask = TaskEntity(
      id: 'task-100',
      title: 'Animation Test Task',
      description: 'Testing self-contained card animation',
      isCompleted: false,
      createdAt: DateTime(2026, 9, 13),
      updatedAt: DateTime(2026, 9, 13),
    );

    testWidgets('animates entrance smoothly on new card mount', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onToggle: () {},
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // Verify card content is in tree
      expect(find.text('Animation Test Task'), findsOneWidget);

      // Settle entrance animation
      await tester.pumpAndSettle();
      expect(find.text('Animation Test Task'), findsOneWidget);
    });

    testWidgets('tapping delete shows confirmation and plays exit animation before onDelete', (tester) async {
      bool deleteCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onToggle: () {},
              onTap: () {},
              onDelete: () {
                deleteCalled = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap delete icon
      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pumpAndSettle();

      // Confirm dialog appears
      expect(find.text(AppStrings.deleteDialogTitle), findsOneWidget);

      // Confirm deletion
      await tester.tap(find.text(AppStrings.deleteConfirmButton));
      await tester.pumpAndSettle();

      // Verify onDelete was invoked after exit animation
      expect(deleteCalled, isTrue);
    });
  });
}
