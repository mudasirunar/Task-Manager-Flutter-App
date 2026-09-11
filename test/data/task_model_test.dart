import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/data/models/task_model.dart';
import 'package:task_manager_app/domain/entities/task_entity.dart';

void main() {
  group('TaskModel', () {
    final now = DateTime(2026, 9, 12, 10, 0);

    test('serializes to Map and deserializes from Map accurately', () {
      final model = TaskModel(
        id: 'task-101',
        title: 'Build Data Layer',
        description: 'Implement models and data sources',
        isCompleted: true,
        createdAt: now,
        updatedAt: now,
      );

      final map = model.toMap();
      final fromMap = TaskModel.fromMap(map);

      expect(fromMap.id, 'task-101');
      expect(fromMap.title, 'Build Data Layer');
      expect(fromMap.description, 'Implement models and data sources');
      expect(fromMap.isCompleted, isTrue);
      expect(fromMap.createdAt, now);
      expect(fromMap.updatedAt, now);
    });

    test('serializes to JSON string and deserializes from JSON string', () {
      final model = TaskModel(
        id: 'task-102',
        title: 'JSON Serialization Test',
        description: null,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final jsonString = model.toJson();
      final fromJson = TaskModel.fromJson(jsonString);

      expect(fromJson.id, 'task-102');
      expect(fromJson.title, 'JSON Serialization Test');
      expect(fromJson.description, isNull);
      expect(fromJson.isCompleted, isFalse);
    });

    test('creates TaskModel from TaskEntity', () {
      final entity = TaskEntity(
        id: 'entity-1',
        title: 'Domain Entity',
        description: 'From domain layer',
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final model = TaskModel.fromEntity(entity);
      expect(model.id, entity.id);
      expect(model.title, entity.title);
      expect(model.description, entity.description);
    });
  });
}
