import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import 'task_local_datasource.dart';

/// Concrete implementation of [TaskLocalDataSource] using [SharedPreferences].
class TaskSharedPrefsDataSource implements TaskLocalDataSource {
  static const String _storageKey = 'cached_tasks_v1';
  final SharedPreferences _prefs;

  const TaskSharedPrefsDataSource(this._prefs);

  @override
  Future<List<TaskModel>> getCachedTasks() async {
    final rawJson = _prefs.getString(_storageKey);
    if (rawJson == null || rawJson.isEmpty) {
      return [];
    }

    try {
      final decoded = json.decode(rawJson) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map((map) => TaskModel.fromMap(map))
          .toList();
    } catch (_) {
      // In case of corrupt or invalid stored JSON, gracefully return empty list
      return [];
    }
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    final listMaps = tasks.map((task) => task.toMap()).toList();
    final jsonString = json.encode(listMaps);
    await _prefs.setString(_storageKey, jsonString);
  }

  static const String _themeKey = 'theme_mode_v1';

  @override
  Future<void> clearTasks() async {
    await _prefs.remove(_storageKey);
  }

  @override
  String? getStoredThemeMode() {
    return _prefs.getString(_themeKey);
  }

  @override
  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(_themeKey, mode);
  }
}
