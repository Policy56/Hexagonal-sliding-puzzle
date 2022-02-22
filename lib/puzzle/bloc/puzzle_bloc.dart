// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hexagonal_sliding_puzzle/models/models.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc({this.random}) : super(const PuzzleState()) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<TileTapped>(_onTileTapped);
    on<PuzzleReset>(_onPuzzleReset);
  }

  final Random? random;

  void _onPuzzleInitialized(
    PuzzleInitialized event,
    Emitter<PuzzleState> emit,
  ) {
    final puzzle =
        _generateHexagonPuzzle(event.size, shuffle: event.shufflePuzzle);

    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        puzzleStatus: event.shufflePuzzle
            ? PuzzleStatus.incomplete
            : PuzzleStatus.notStarted,
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  void _onTileTapped(TileTapped event, Emitter<PuzzleState> emit) {
    final tappedTile = event.tile;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(tappedTile)) {
        final mutablePuzzle = Puzzle(tiles: [...state.puzzle.tiles]);
        final puzzle = mutablePuzzle.moveTiles(tappedTile, []);

        if (puzzle.isComplete()) {
          final analytics = FirebaseAnalytics.instance;
          // ignore: cascade_invocations
          analytics.logEvent(
            name: 'level_complete',
            parameters: <String, dynamic>{
              'numberOfMoves': state.numberOfMoves,
              'size': event.size
            },
          );
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              puzzleStatus: PuzzleStatus.complete,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        } else {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
        );
      }
    } else {
      emit(
        state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
      );
    }
  }

  void _onPuzzleReset(PuzzleReset event, Emitter<PuzzleState> emit) {
    final puzzle = _generateHexagonPuzzle(event.size);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        puzzleStatus: PuzzleStatus.incomplete,
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  /// Build a randomized, solvable puzzle of the given size.
  Puzzle _generateHexagonPuzzle(int size, {bool shuffle = true}) {
    final correctPositions = <Position?>[];
    final currentPositions = <Position?>[];
    final tempCurrentPositions = <Position?>[];
    final List<Tile> tiles;
    List<Position> listPosition;

    final depth = ((size - 1) / 2).round();

    if (depth == 3) {
      //Medium
      listPosition = [
        const Position(x: 3, y: 0),
        const Position(x: 4, y: 0),
        const Position(x: 5, y: 0),
        const Position(x: 6, y: 0),
        const Position(x: 2, y: 1),
        const Position(x: 3, y: 1),
        const Position(x: 4, y: 1),
        const Position(x: 5, y: 1),
        const Position(x: 6, y: 1),
        const Position(x: 1, y: 2),
        const Position(x: 2, y: 2),
        const Position(x: 3, y: 2),
        const Position(x: 4, y: 2),
        const Position(x: 5, y: 2),
        const Position(x: 6, y: 2),
        const Position(x: 0, y: 3),
        const Position(x: 1, y: 3),
        const Position(x: 2, y: 3),
        //const Position(x: 3, y: 3),
        const Position(x: 4, y: 3),
        const Position(x: 5, y: 3),
        const Position(x: 6, y: 3),
        const Position(x: 0, y: 4),
        const Position(x: 1, y: 4),
        const Position(x: 2, y: 4),
        const Position(x: 3, y: 4),
        const Position(x: 4, y: 4),
        const Position(x: 5, y: 4),
        const Position(x: 0, y: 5),
        const Position(x: 1, y: 5),
        const Position(x: 2, y: 5),
        const Position(x: 3, y: 5),
        const Position(x: 4, y: 5),
        const Position(x: 0, y: 6),
        const Position(x: 1, y: 6),
        const Position(x: 2, y: 6),
        const Position(x: 3, y: 6),
      ];
    } else if (depth == 2) {
      //Easy
      listPosition = [
        const Position(x: 2, y: 0),
        const Position(x: 3, y: 0),
        const Position(x: 4, y: 0),
        const Position(x: 1, y: 1),
        const Position(x: 2, y: 1),
        const Position(x: 3, y: 1),
        const Position(x: 4, y: 1),
        const Position(x: 0, y: 2),
        const Position(x: 1, y: 2),
        //   const Position(x: 2, y: 2),
        const Position(x: 3, y: 2),
        const Position(x: 4, y: 2),
        const Position(x: 0, y: 3),
        const Position(x: 1, y: 3),
        const Position(x: 2, y: 3),
        const Position(x: 3, y: 3),
        const Position(x: 0, y: 4),
        const Position(x: 1, y: 4),
        const Position(x: 2, y: 4),
      ];
    } else {
      //Hard
      listPosition = [
        const Position(x: 4, y: 0),
        const Position(x: 5, y: 0),
        const Position(x: 6, y: 0),
        const Position(x: 7, y: 0),
        const Position(x: 8, y: 0),

        const Position(x: 3, y: 1),
        const Position(x: 4, y: 1),
        const Position(x: 5, y: 1),
        const Position(x: 6, y: 1),
        const Position(x: 7, y: 1),
        const Position(x: 8, y: 1),

        const Position(x: 2, y: 2),
        const Position(x: 3, y: 2),
        const Position(x: 4, y: 2),
        const Position(x: 5, y: 2),
        const Position(x: 6, y: 2),
        const Position(x: 7, y: 2),
        const Position(x: 8, y: 2),

        const Position(x: 1, y: 3),
        const Position(x: 2, y: 3),
        const Position(x: 3, y: 3),
        const Position(x: 4, y: 3),
        const Position(x: 5, y: 3),
        const Position(x: 6, y: 3),
        const Position(x: 7, y: 3),
        const Position(x: 8, y: 3),

        const Position(x: 0, y: 4),
        const Position(x: 1, y: 4),
        const Position(x: 2, y: 4),
        const Position(x: 3, y: 4),
        //const Position(x: 4, y: 4),
        const Position(x: 5, y: 4),
        const Position(x: 6, y: 4),
        const Position(x: 7, y: 4),
        const Position(x: 8, y: 4),

        const Position(x: 0, y: 5),
        const Position(x: 1, y: 5),
        const Position(x: 2, y: 5),
        const Position(x: 3, y: 5),
        const Position(x: 4, y: 5),
        const Position(x: 5, y: 5),
        const Position(x: 6, y: 5),
        const Position(x: 7, y: 5),

        const Position(x: 0, y: 6),
        const Position(x: 1, y: 6),
        const Position(x: 2, y: 6),
        const Position(x: 3, y: 6),
        const Position(x: 4, y: 6),
        const Position(x: 5, y: 6),
        const Position(x: 6, y: 6),

        const Position(x: 0, y: 7),
        const Position(x: 1, y: 7),
        const Position(x: 2, y: 7),
        const Position(x: 3, y: 7),
        const Position(x: 4, y: 7),
        const Position(x: 5, y: 7),

        const Position(x: 0, y: 8),
        const Position(x: 1, y: 8),
        const Position(x: 2, y: 8),
        const Position(x: 3, y: 8),
        const Position(x: 4, y: 8),
      ];
    }

    for (var x = 0; x < listPosition.length; x++) {
      final positions = listPosition[x];
      correctPositions.add(positions);
      currentPositions.add(positions);
    }

    if (shuffle) {
      // Randomize only the current tile posistions.
      //S'occuper du shuffle ici + gestion du truc si null ..
      //TODO:shuffle ici
      currentPositions.shuffle(random);
    }

    final itemWhitespace = Tile(
      value: 100, //(listPosition.length / 2).round(), // 9(2/3)/18(3/5)/30(4/7)
      correctPosition: Position(x: depth, y: depth),
      currentPosition: Position(x: depth, y: depth), //CCL
      isWhitespace: true,
    );

    tiles = _getHexagonTileListFromPositions(
      size,
      correctPositions,
      currentPositions,
    );

    tiles.add(itemWhitespace);

    for (var k = 0; k < (depth * depth) + depth; k++) {
      const itemTileVide = Tile(
        value: -1,
        correctPosition: Position(x: 0, y: 0),
        currentPosition: Position(x: 0, y: 0),
      );
      tiles.add(itemTileVide);
    }

    return Puzzle(tiles: tiles);
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<Tile> _getHexagonTileListFromPositions(
    int size,
    List<Position?> correctPositions,
    List<Position?> currentPositions,
  ) {
    //final whitespacePosition = Position(x: 3, y: 3);
    final list = [
      for (int i = 0; i < correctPositions.length; i++)
        if (correctPositions[i] != null && currentPositions[i] != null)
          Tile(
            value: i + 1,
            correctPosition: correctPositions[i]!, //CCL
            currentPosition: currentPositions[i]!, //CCL
          )
        else
          const Tile(
            value: -1,
            correctPosition: Position(x: 0, y: 0),
            currentPosition: Position(x: 0, y: 0),
          )
    ];
    return list;
  }

  /// Build a randomized, solvable puzzle of the given size.
  /* Puzzle _generatePuzzle(int size, {bool shuffle = true}) {
    final correctPositions = <Position>[];
    final currentPositions = <Position>[];
    final whitespacePosition = Position(x: size, y: size);

    // Create all possible board positions.
    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        if (x == size && y == size) {
          correctPositions.add(whitespacePosition);
          currentPositions.add(whitespacePosition);
        } else {
          final position = Position(x: x, y: y);
          correctPositions.add(position);
          currentPositions.add(position);
        }
      }
    }

    if (shuffle) {
      // Randomize only the current tile posistions.
      currentPositions.shuffle(random);
    }

    var tiles = _getTileListFromPositions(
      size,
      correctPositions,
      currentPositions,
    );

    var puzzle = Puzzle(tiles: tiles);

    if (shuffle) {
      // Assign the tiles new current positions until the puzzle is solvable and
      // zero tiles are in their correct position.
      while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
        currentPositions.shuffle(random);
        tiles = _getTileListFromPositions(
          size,
          correctPositions,
          currentPositions,
        );
        puzzle = Puzzle(tiles: tiles);
      }
    }

    return puzzle;
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<Tile> _getTileListFromPositions(
    int size,
    List<Position> correctPositions,
    List<Position> currentPositions,
  ) {
    final whitespacePosition = Position(x: size, y: size);
    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            value: i,
            correctPosition: whitespacePosition,
            currentPosition: currentPositions[i - 1],
            isWhitespace: true,
          )
        else
          Tile(
            value: i,
            correctPosition: correctPositions[i - 1],
            currentPosition: currentPositions[i - 1],
          )
    ];
  }*/
}
