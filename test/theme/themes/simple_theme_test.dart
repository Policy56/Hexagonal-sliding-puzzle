// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:hexagonal_sliding_puzzle/layout/layout.dart';
import 'package:hexagonal_sliding_puzzle/theme/theme.dart';

void main() {
  group('SimpleTheme', () {
    test('supports value equality', () {
      expect(
        SimpleTheme(),
        equals(SimpleTheme()),
      );
    });

    test('uses SimplePuzzleLayoutDelegate', () {
      expect(
        SimpleTheme().layoutDelegate,
        equals(SimplePuzzleLayoutDelegate()),
      );
    });
  });
}
