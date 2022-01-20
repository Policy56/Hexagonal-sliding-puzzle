// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:hexagonal_sliding_puzzle/models/models.dart';
import 'package:hexagonal_sliding_puzzle/puzzle/puzzle.dart';

void main() {
  final position = Position(x: 1, y: 1);
  final tile1 = Tile(
    value: 1,
    correctPosition: position,
    currentPosition: position,
  );
  final tile2 = Tile(
    value: 2,
    correctPosition: position,
    currentPosition: position,
  );

  group('PuzzleEvent', () {
    group('PuzzleInitialized', () {
      test('supports value comparisons', () {
        expect(
          PuzzleInitialized(shufflePuzzle: true, size: 5),
          equals(PuzzleInitialized(shufflePuzzle: true, size: 5)),
        );

        expect(
          PuzzleInitialized(shufflePuzzle: true, size: 5),
          isNot(PuzzleInitialized(shufflePuzzle: false, size: 5)),
        );
      });
    });

    group('TileTapped', () {
      test('supports value comparisons', () {
        expect(TileTapped(tile1, size: 5), equals(TileTapped(tile1, size: 5)));
        expect(TileTapped(tile2, size: 5), isNot(TileTapped(tile1, size: 5)));
      });
    });

    group('PuzzleReset', () {
      test('supports value comparisons', () {
        expect(PuzzleReset(size: 5), equals(PuzzleReset(size: 5)));
      });
    });
  });
}
