import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/task_shared_prefs_datasource.dart';
import 'data/repositories/task_repository_impl.dart';
import 'presentation/controllers/task_controller.dart';
import 'presentation/screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable true edge-to-edge system UI mode for a modern bottom-touching layout
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Initialize persistence and Clean Architecture dependency graph
  final sharedPreferences = await SharedPreferences.getInstance();
  final localDataSource = TaskSharedPrefsDataSource(sharedPreferences);
  final taskRepository = TaskRepositoryImpl(localDataSource);
  final taskController = TaskController(taskRepository);

  runApp(TaskManagerApp(controller: taskController));
}

/// Root widget configuring the application theme and initial route.
class TaskManagerApp extends StatelessWidget {
  final TaskController controller;

  const TaskManagerApp({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: controller.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: SplashScreen(controller: controller),
        );
      },
    );
  }
}
