// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/cmp/grid/help/coordinates.dart';
import 'package:very_good_slide_puzzle/models/models.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc(this._size, {this.random}) : super(const PuzzleState()) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<TileTapped>(_onTileTapped);
    on<PuzzleReset>(_onPuzzleReset);
  }

  final int _size;

  final Random? random;

  void _onPuzzleInitialized(
    PuzzleInitialized event,
    Emitter<PuzzleState> emit,
  ) {
    final puzzle = _generateHexagonPuzzle(_size, shuffle: event.shufflePuzzle);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
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
    final puzzle = _generateHexagonPuzzle(_size);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  /// Build a randomized, solvable puzzle of the given size.
  Puzzle _generateHexagonPuzzle(int size, {bool shuffle = true}) {
    final List<List<Position?>> correctPositions = <List<Position?>>[];
    final List<List<Position?>> currentPositions = <List<Position?>>[];
    final List<List<Position?>> tempCurrentPositions = <List<Position?>>[
      [],
      [],
      [],
      [],
      [],
      [],
      []
    ];
    final whitespacePosition = Position(x: size, y: size);

    int depth = 3;

    /*final test =List.generate(
                6,
                (int mainIndex) {
                  int currentDepth = mainIndex - depth;
                 
                      return List.generate(6, (crossIndex) {
                        if (currentDepth <= 0)
                          crossIndex = -depth - currentDepth + crossIndex;
                        else
                          crossIndex = -depth + crossIndex;

                        final coordinates = Coordinates.axial(
                          crossIndex,// : currentDepth,
                           currentDepth,// : crossIndex,
                        );
                        
                        return coordinates;
                        //return buildHex.call(coordinates);
                      });
                    
                  
                },
              );*/
    List<List<Position?>> testTiles = [
      [
        null,
        null,
        null,
        const Position(x: 3, y: 0),
        const Position(x: 4, y: 0),
        const Position(x: 5, y: 0),
        const Position(x: 6, y: 0)
      ],
      [
        null,
        null,
        const Position(x: 2, y: 1),
        const Position(x: 3, y: 1),
        const Position(x: 4, y: 1),
        const Position(x: 5, y: 1),
        const Position(x: 6, y: 1)
      ],
      [
        null,
        const Position(x: 1, y: 2),
        const Position(x: 2, y: 2),
        const Position(x: 3, y: 2),
        const Position(x: 4, y: 2),
        const Position(x: 5, y: 2),
        const Position(x: 6, y: 2)
      ],
      [
        const Position(x: 0, y: 3),
        const Position(x: 1, y: 3),
        const Position(x: 2, y: 3),
        const Position(x: 3, y: 3),
        const Position(x: 4, y: 3),
        const Position(x: 5, y: 3),
        const Position(x: 6, y: 3)
      ],
      [
        const Position(x: 0, y: 4),
        const Position(x: 1, y: 4),
        const Position(x: 2, y: 4),
        const Position(x: 3, y: 4),
        const Position(x: 4, y: 4),
        const Position(x: 5, y: 4),
        null
      ],
      [
        const Position(x: 0, y: 5),
        const Position(x: 1, y: 5),
        const Position(x: 2, y: 5),
        const Position(x: 3, y: 5),
        const Position(x: 4, y: 5),
        null,
        null
      ],
      [
        const Position(x: 0, y: 6),
        const Position(x: 1, y: 6),
        const Position(x: 2, y: 6),
        const Position(x: 3, y: 6),
        null,
        null,
        null
      ],
    ];

    for (var x = 0; x < testTiles.length; x++) {
      List<Position?> positions = testTiles[x];
      correctPositions.add(positions);

      if (positions != null) {
        for (Position? itemPos in positions) {
          if (itemPos != null) {
            tempCurrentPositions[x].add(itemPos);
          }
        }
      }
    }

    /*  for (var x = 0; x <= size; x++) {
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
*/

    if (shuffle) {
      // Randomize only the current tile posistions.
      //S'occuper du shuffle ici + gestion du truc si null ..
      //TODO:shuffle ici
      tempCurrentPositions.shuffle(random);
    }
    /* currentPositions.addAll(tempCurrentPositions);
    currentPositions.insertAll(
        currentPositions.length, List.generate(10, (index) => [null]));
        */
    currentPositions.addAll(correctPositions);

    var tiles = _getHexagonTileListFromPositions(
      size,
      correctPositions,
      currentPositions,
    );

    var puzzle = Puzzle(tiles: tiles);

    if (shuffle) {
      // Assign the tiles new current positions until the puzzle is solvable and
      // zero tiles are in their correct position.
      while (
          !puzzle.isSolvable() /*|| puzzle.getNumberOfCorrectTiles() != 0*/) {
        //CCL ON enleve la vérif CCL
        currentPositions.shuffle(random);
        tiles = _getHexagonTileListFromPositions(
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
  List<Tile> _getHexagonTileListFromPositions(
    int size,
    List<List<Position?>> correctPositions,
    List<List<Position?>> currentPositions,
  ) {
    final whitespacePosition = Position(x: size, y: size);
    var list = [
      for (int i = 0; i <= size; i++)
        for (int j = 0; j <= size; j++)
          if (i == size / 2 && j == size / 2)
            Tile(
              value: 10 * i + j,
              correctPosition: whitespacePosition,
              currentPosition: const Position(x: 3, y: 3), //CCL
              isWhitespace: true,
            )
          else if (correctPositions[i][j] != null &&
              currentPositions[i][j] != null)
            Tile(
              value: 10 * i + j,
              correctPosition: correctPositions[i][j]!, //CCL
              currentPosition: currentPositions[i][j]!, //CCL
            )
          else
            Tile(
              value: -1,
              correctPosition: const Position(x: 0, y: 0),
              currentPosition: const Position(x: 0, y: 0),
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
