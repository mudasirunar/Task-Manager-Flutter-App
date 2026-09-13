import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/core/utils/app_haptics.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppHaptics Tests', () {
    test('selection triggers without uncaught exception', () async {
      await expectLater(AppHaptics.selection(), completes);
    });

    test('lightImpact triggers without uncaught exception', () async {
      await expectLater(AppHaptics.lightImpact(), completes);
    });

    test('mediumImpact triggers without uncaught exception', () async {
      await expectLater(AppHaptics.mediumImpact(), completes);
    });

    test('heavyImpact triggers without uncaught exception', () async {
      await expectLater(AppHaptics.heavyImpact(), completes);
    });
  });
}
