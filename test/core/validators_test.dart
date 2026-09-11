import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/core/constants/app_strings.dart';
import 'package:task_manager_app/core/utils/validators.dart';

void main() {
  group('Validators.validateTitle', () {
    test('rejects null title with required error', () {
      final result = Validators.validateTitle(null);
      expect(result, AppStrings.titleRequiredError);
    });

    test('rejects empty title with required error', () {
      final result = Validators.validateTitle('');
      expect(result, AppStrings.titleRequiredError);
    });

    test('rejects spaces-only title with whitespace error', () {
      final result = Validators.validateTitle('    ');
      expect(result, AppStrings.titleWhitespaceError);
    });

    test('rejects tabs and newlines only with whitespace error', () {
      final result = Validators.validateTitle('\t \n ');
      expect(result, AppStrings.titleWhitespaceError);
    });

    test('accepts valid non-empty title', () {
      final result = Validators.validateTitle('Complete Flutter Assessment');
      expect(result, isNull);
    });

    test('accepts valid title with leading and trailing whitespace', () {
      final result = Validators.validateTitle('  Valid Task  ');
      expect(result, isNull);
    });
  });
}
