import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexagonal_sliding_puzzle/cmp/grid/help/coordinates.dart';
import 'package:hexagonal_sliding_puzzle/cmp/grid/hexagon_grid.dart';
import 'package:hexagonal_sliding_puzzle/cmp/grid/hexagon_type.dart';
import 'package:hexagonal_sliding_puzzle/cmp/grid/hexagon_widget.dart';
import 'package:hexagonal_sliding_puzzle/cmp/switch/switch_bloc.dart';
import 'package:hexagonal_sliding_puzzle/colors/colors.dart';
import 'package:hexagonal_sliding_puzzle/l10n/l10n.dart';
import 'package:hexagonal_sliding_puzzle/layout/layout.dart';
import 'package:hexagonal_sliding_puzzle/models/models.dart';
import 'package:hexagonal_sliding_puzzle/puzzle/puzzle.dart';
import 'package:hexagonal_sliding_puzzle/theme/theme.dart';
import 'package:hexagonal_sliding_puzzle/timer/bloc/timer_bloc.dart';
import 'package:hexagonal_sliding_puzzle/timer/timer_widget.dart';
import 'package:hexagonal_sliding_puzzle/typography/typography.dart';

/// {@template simple_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses a [SimpleTheme].
/// {@endtemplate}
class SimplePuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro simple_puzzle_layout_delegate}
  const SimplePuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => SimpleStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => SimplePuzzleShuffleButton(state),
          medium: (_, child) => SimplePuzzleShuffleButton(state),
          large: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
      ],
    );
  }

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: ResponsiveLayoutBuilder(
        small: (_, __) => SizedBox(
          width: 184,
          height: 118,
          child: Image.asset(
            'assets/images/simple_dash_small.png',
            key: const Key('simple_puzzle_dash_small'),
          ),
        ),
        medium: (_, __) => SizedBox(
          width: 380.44,
          height: 214,
          child: Image.asset(
            'assets/images/simple_dash_medium.png',
            key: const Key('simple_puzzle_dash_medium'),
          ),
        ),
        large: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 53),
          child: SizedBox(
            width: 568.99,
            height: 320,
            child: Image.asset(
              'assets/images/simple_dash_large.png',
              key: const Key('simple_puzzle_dash_large'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    return Stack(
      children: [
        Positioned(
          top: 24,
          left: 0,
          right: 0,
          child: ResponsiveLayoutBuilder(
            small: (_, child) => const SizedBox(),
            medium: (_, child) => const SizedBox(),
            large: (_, child) => const TimerWidget(),
          ),
        ),
        Column(
          children: [
            const ResponsiveGap(
              small: 32,
              medium: 48,
              large: 60,
            ),
            ResponsiveLayoutBuilder(
              small: (_, __) => SizedBox.square(
                dimension: _BoardSize.small,
                child: SimplePuzzleBoard(
                  key: const Key('simple_puzzle_board_small'),
                  size: size,
                  tiles: tiles,
                  spacing: 5,
                ),
              ),
              medium: (_, __) => SizedBox.square(
                dimension: _BoardSize.medium,
                child: SimplePuzzleBoard(
                  key: const Key('simple_puzzle_board_medium'),
                  size: size,
                  tiles: tiles,
                ),
              ),
              large: (_, __) => SizedBox.square(
                dimension: _BoardSize.large,
                child: SimplePuzzleBoard(
                  key: const Key('simple_puzzle_board_large'),
                  size: size,
                  tiles: tiles,
                ),
              ),
            ),
            const ResponsiveGap(),
          ],
        ),
      ],
    );
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_small'),
        tile: tile,
        tileFontSize: _TileFontSize.small,
        boardSize: _BoardSize.small,
        state: state,
      ),
      medium: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_medium'),
        tile: tile,
        boardSize: _BoardSize.medium,
        tileFontSize: _TileFontSize.medium, //CCL Change font
        state: state,
      ),
      large: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_large'),
        tile: tile,
        boardSize: _BoardSize.large,
        tileFontSize: _TileFontSize.large, //CCL Change font
        state: state,
      ),
    );

    /*
    return AnimatedAlign(
      alignment: Alignment.center,
      duration: const Duration(seconds: 5),
      curve: Curves.easeInOut,
      child: ResponsiveLayoutBuilder(
        small: (_, child) => SizedBox.square(
          key: Key('simple_puzzle_tile_${tile.value}_small'),
          dimension: _TileFontSize.small,
        ),
        medium: (_, child) => SizedBox.square(
          key: Key('simple_puzzle_tile_${tile.value}_medium'),
          dimension: _TileFontSize.medium, //CCL Change font
        ),
        large: (_, child) => SimplePuzzleTile(
          key: Key('simple_puzzle_tile_${tile.value}_large'),
          tileFontSize: _TileFontSize.large, //CCL Change font
          state: state,
        ),
        child: (_) => MouseRegion(
            onEnter: (_) {
              if (canPress) {
                _controller.forward();
              }
            },
            onExit: (_) {
              if (canPress) {
                _controller.reverse();
              }
            },
            child: ScaleTransition(
              key: Key('scale_simple_puzzle_tile_${tile.value}'),
              scale: _scale,
              child: SimplePuzzleTile(
                tile: tile,
                state: state,
                tileFontSize: _TileFontSize.medium,
key: Key('tile_simple_puzzle_tile_${tile.value}'),
              )
            ),
              /*IconButton(
                padding: EdgeInsets.zero,
                onPressed: canPress
                    ? () {
                        context.read<PuzzleBloc>().add(TileTapped(widget.tile));
                        unawaited(_audioPlayer?.replay());
                      }
                    : null,
                icon: Image.asset(
                  theme.dashAssetForTile(widget.tile),
                  semanticLabel: context.l10n.puzzleTileLabelText(
                    tile.value.toString(),
                    tile.currentPosition.x.toString(),
                    tile.currentPosition.y.toString(),
                  ),
                ),
              ),*/
            ),
      ),
      
    );*/
  }

  @override
  Widget whitespaceTileBuilder(Color bgColor) {
    return Container(
      color: bgColor,
    );
  }

  @override
  List<Object?> get props => [];
}

/// {@template simple_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
@visibleForTesting
class SimpleStartSection extends StatelessWidget {
  /// {@macro simple_start_section}
  const SimpleStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveGap(
          small: 5,
          medium: 30,
          large: 111,
        ),
        const PuzzleName(),
        const ResponsiveGap(large: 16),
        SimplePuzzleTitle(
          status: state.puzzleStatus,
          color: theme.menuActiveColor,
        ),
        const ResponsiveGap(
          small: 12,
          medium: 16,
          large: 32,
        ),
        Column(
          children: [
            NumberOfMovesAndTilesLeft(
              numberOfMoves: state.numberOfMoves,
              numberOfTilesLeft: state.numberOfTilesLeft,
            ),
            const ResponsiveGap(small: 12, large: 32),
            ResponsiveLayoutBuilder(
              small: (_, __) => const SizedBox(),
              medium: (_, __) => const SizedBox(),
              large: (_, __) => SimplePuzzleShuffleButton(state),
            ),
          ],
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => const TimerWidget(),
          medium: (_, __) => const TimerWidget(),
          large: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(small: 12),
      ],
    );
  }
}

/// {@template simple_puzzle_title}
/// Displays the title of the puzzle based on [status].
///
/// Shows the success state when the puzzle is completed,
/// otherwise defaults to the Puzzle Challenge title.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTitle extends StatelessWidget {
  /// {@macro simple_puzzle_title}
  const SimplePuzzleTitle({Key? key, required this.status, required this.color})
      : super(key: key);

  /// The state of the puzzle.
  final PuzzleStatus status;

  /// The color of the title.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return PuzzleTitle(
      title: status == PuzzleStatus.complete
          ? context.l10n.puzzleCompleted
          : context.l10n.puzzleChallengeTitle,
      color: color,
    );
  }
}

abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 650;
}

/// {@template simple_puzzle_board}
/// Display the board of the puzzle in a [size]x[size] layout
/// filled with [tiles]. Each tile is spaced with [spacing].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleBoard extends StatelessWidget {
  /// {@macro simple_puzzle_board}
  const SimplePuzzleBoard({
    Key? key,
    required this.size,
    required this.tiles,
    this.spacing = 8,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  /// The spacing between each tile from [tiles].
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return _buildGrid(context, HexagonType.pointy);
    /*return Stack(
      children: [
        Positioned.fill(child: _buildGrid(context, HexagonType.POINTY))
      ],
    );*/
    /*return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: size,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      children: tiles,
    );*/
  }

  Widget _buildGrid(BuildContext context, HexagonType type) {
    var cpt = 0;
    final depth = ((size - 1) / 2).round();
    return HexagonGrid(
      hexType: type,
      depth: depth,
      buildTile: (Coordinates coordinates) {
        Widget returnItem;
        do {
          returnItem = tiles[cpt];
          cpt++;
        } while ((returnItem as PuzzleTile).tile.correctPosition.x == 0 &&
            returnItem.tile.correctPosition.y == 0 &&
            cpt < tiles.length);

        /*if (cpt >= tiles.length) {
          print('2 $cpt');
        }*/

        if (returnItem.tile.isWhitespace) {
          return HexagonWidgetBuilder(
            child: returnItem,
            elevation: 0,
            padding: 0,
            cornerRadius: 0,
            color: Colors.transparent,
          );
        } else {
          return HexagonWidgetBuilder(
            padding: 2,
            cornerRadius: 10,
            child: returnItem,
          );
        }
      },
      /* buildTile: (Coordinates coordinates) => HexagonWidgetBuilder(
        padding: 2.0,
        cornerRadius: 8.0,
        child: // Text('${coordinates.q + 3}, ${coordinates.r + 3}  \n ${testTiles[coordinates.r + 3][coordinates.q + 3]!.x} ${testTiles[coordinates.r + 3][coordinates.q + 3]!.y}'),
            Text("${coordinates.q + depth}, ${coordinates.r + depth}"),
        // Text(    '/${coordinates.x}, ${coordinates.y}, ${coordinates.z}\n  ${coordinates.q + 3}, ${coordinates.r + 3}'),
      ),*/
    );
  }
}

abstract class _TileFontSize {
  static double small = 18;
  static double medium = 25;
  static double large = 54;
}

/// {@template simple_puzzle_tile}
/// Displays the puzzle tile associated with [tile] and
/// the font size of [tileFontSize] based on the puzzle [state].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTile extends StatelessWidget {
  /// {@macro simple_puzzle_tile}
  const SimplePuzzleTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.boardSize,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The font size of the tile to be displayed.
  final double tileFontSize;

  /// The font size of the tile to be displayed.
  final double boardSize;

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final isSwitchHelp =
        context.select((SwitchBloc bloc) => bloc.state.isTapped);

    return TextButton(
      style: TextButton.styleFrom(
        primary: PuzzleColors.white,
        textStyle: //PuzzleTextStyle.bodySmall,
            PuzzleTextStyle.headline5.copyWith(
          fontSize: (boardSize / theme.size) / 3, //tileFontSize,
        ),
        // shape: const PolygonBorder(sides: 6, borderRadius: 5),
        //const PolygonBorder(sides: 6, borderRadius: 5),

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ).copyWith(
        fixedSize: MaterialStateProperty.resolveWith<Size?>((states) {
          return Size(
            boardSize / (0.9 * theme.size),
            boardSize / (0.9 * theme.size),
          );
        }),
        foregroundColor: MaterialStateProperty.all(
          PuzzleColors.white,
        ), //CCL change color text + hover
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (tile.value == state.lastTappedTile?.value) {
              if (isSwitchHelp && (state.puzzle.isTileCorrect(tile))) {
                return lighter(theme.correctTileColor, 20);
              } else {
                return theme.pressedColor;
              }
            } else if (states.contains(MaterialState.hovered)) {
              return theme.hoverColor;
            } else {
              if (isSwitchHelp && (state.puzzle.isTileCorrect(tile))) {
                return theme.correctTileColor;
              } else {
                return theme.defaultColor;
              }

              /*if (state.puzzle.isTileMovable(tile)) {
                returnColor = Colors.green;
              } else {
                returnColor = Colors.red;
              }
              return returnColor;
*/
              /*Color returnColor;
                  if (state.puzzle.isTileCorrect(tile)) {
                    returnColor = Colors.green;
                  } else {
                    returnColor = Colors.red;
                  }
                  return returnColor;*/

            }
          },
        ),
      ),
      onPressed: state.puzzleStatus == PuzzleStatus.incomplete
          ? () => context.read<PuzzleBloc>().add(
                TileTapped(
                  tile,
                  size: theme.size,
                ),
              )
          : null,
      child: Text(tile.value.toString()),
      //" ${tile.value} \n ${tile.currentPosition.x} - ${tile.currentPosition.y} "),
    );
  }
}

/// {@template puzzle_shuffle_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleShuffleButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleShuffleButton(
    this.state, {
    Key? key,
  }) : super(key: key);

  ///State du puzzle
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: theme.defaultColor,
      onPressed: () {
        if (state.puzzleStatus == PuzzleStatus.notStarted) {
          context.read<TimerBloc>().add(const TimerStarted());
          context.read<PuzzleBloc>().add(
                PuzzleInitialized(shufflePuzzle: true, size: theme.size),
              );
          /* emit(
          state.copyWith(
              //puzzle: puzzle.sort(),
              puzzleStatus: PuzzleStatus.incomplete,
            ),
          );*/
        } else {
          context.read<TimerBloc>().add(const TimerReset(restartGame: true));
          context.read<PuzzleBloc>().add(PuzzleReset(size: theme.size));
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shuffle_icon.png',
            width: 17,
            height: 17,
          ),
          const Gap(10),
          Text(
            /*numberOfMoves == 0
                ? context.l10n.puzzleStart
                :*/
            (state.puzzleStatus == PuzzleStatus.notStarted)
                ? context.l10n.puzzleStart
                : context.l10n.puzzleShuffle,
          ),
        ],
      ),
    );
  }
}
