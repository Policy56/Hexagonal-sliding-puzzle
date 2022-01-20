// ignore_for_file: public_member_api_docs

part of 'puzzle_bloc.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent(this.size);

  final int size;

  @override
  List<Object> get props => [];
}

class PuzzleInitialized extends PuzzleEvent {
  const PuzzleInitialized({required this.shufflePuzzle, required int size})
      : super(size);

  final bool shufflePuzzle;

  @override
  List<Object> get props => [shufflePuzzle, size];
}

class TileTapped extends PuzzleEvent {
  const TileTapped(this.tile, {required int size}) : super(size);

  final Tile tile;

  @override
  List<Object> get props => [tile];
}

class PuzzleReset extends PuzzleEvent {
  const PuzzleReset({required int size}) : super(size);
}
