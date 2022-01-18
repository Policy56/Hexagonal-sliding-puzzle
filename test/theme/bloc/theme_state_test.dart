// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:hexagonal_sliding_puzzle/theme/theme.dart';

void main() {
  group('ThemeState', () {
    test('supports value comparisons', () {
      expect(ThemeState(), equals(ThemeState()));
    });

    test('default theme is SimpleTheme', () {
      expect(ThemeState().theme, equals(SimpleTheme()));
    });
  });
}
