import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/presentation/widgets/common/theme_toggle_button.dart';

void main() {
  group('ThemeToggleButton Tests', () {
    testWidgets('renders Moon icon in light mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemeToggleButton(
              isDarkMode: false,
              onToggle: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
      expect(find.byIcon(Icons.light_mode_rounded), findsNothing);
      expect(find.byTooltip('Switch to Dark Mode'), findsOneWidget);
    });

    testWidgets('renders Sun icon in dark mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemeToggleButton(
              isDarkMode: true,
              onToggle: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode_rounded), findsNothing);
      expect(find.byTooltip('Switch to Light Mode'), findsOneWidget);
    });

    testWidgets('tapping toggle button triggers onToggle and animates', (tester) async {
      bool toggled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemeToggleButton(
              isDarkMode: false,
              onToggle: () {
                toggled = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ThemeToggleButton));
      expect(toggled, isTrue);

      // Verify animation ticks cleanly to completion
      await tester.pumpAndSettle();
    });
  });
}
