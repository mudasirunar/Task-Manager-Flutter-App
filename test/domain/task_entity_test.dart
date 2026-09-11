import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/domain/entities/task_entity.dart';
import 'package:task_manager_app/domain/entities/task_filter.dart';

void main() {
  group('TaskEntity', () {
    final now = DateTime(2026, 9, 12, 10, 0);

    test('creates entity with expected properties', () {
      final task = TaskEntity(
        id: '1',
        title: 'Learn Clean Architecture',
        description: 'Study Uncle Bob principles',
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      expect(task.id, '1');
      expect(task.title, 'Learn Clean Architecture');
      expect(task.description, 'Study Uncle Bob principles');
      expect(task.isCompleted, isFalse);
      expect(task.createdAt, now);
      expect(task.updatedAt, now);
    });

    test('copyWith updates specified fields correctly', () {
      final task = TaskEntity(
        id: '1',
        title: 'Original Title',
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final updatedTask = task.copyWith(
        title: 'Updated Title',
        isCompleted: true,
      );

      expect(updatedTask.id, '1');
      expect(updatedTask.title, 'Updated Title');
      expect(updatedTask.isCompleted, isTrue);
      expect(updatedTask.createdAt, now);
    });

    test('equality and hashCode work as expected', () {
      final taskA = TaskEntity(
        id: '1',
        title: 'Task A',
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final taskB = TaskEntity(
        id: '1',
        title: 'Task A',
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      expect(taskA, equals(taskB));
      expect(taskA.hashCode, equals(taskB.hashCode));
    });
  });

  group('TaskFilter', () {
    test('provides correct user-facing labels', () {
      expect(TaskFilter.all.label, 'All');
      expect(TaskFilter.pending.label, 'Pending');
      expect(TaskFilter.completed.label, 'Completed');
    });
  });
}
