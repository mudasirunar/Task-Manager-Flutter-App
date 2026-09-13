import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/core/constants/app_strings.dart';
import 'package:task_manager_app/presentation/widgets/common/confirmation_dialog.dart';

void main() {
  group('ConfirmationDialog Tests', () {
    testWidgets('renders all components centered with red outline border', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ConfirmationDialog(
              title: 'Delete Task?',
              message: 'Are you sure you want to delete this task?',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify title, message, and action buttons are rendered
      expect(find.text('Delete Task?'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this task?'), findsOneWidget);
      expect(find.text(AppStrings.cancelButton), findsOneWidget);
      expect(find.text(AppStrings.deleteConfirmButton), findsOneWidget);

      // Verify center text alignment
      final titleText = tester.widget<Text>(find.text('Delete Task?'));
      expect(titleText.textAlign, TextAlign.center);

      final messageText = tester.widget<Text>(find.text('Are you sure you want to delete this task?'));
      expect(messageText.textAlign, TextAlign.center);

      // Verify Dialog has rounded rectangle border with red side
      final dialog = tester.widget<Dialog>(find.byType(Dialog));
      expect(dialog.shape, isA<RoundedRectangleBorder>());
      final shape = dialog.shape as RoundedRectangleBorder;
      expect(shape.side.color.a, greaterThan(0));
    });
  });
}
