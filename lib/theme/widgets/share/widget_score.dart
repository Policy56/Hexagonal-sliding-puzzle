import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexagonal_sliding_puzzle/colors/colors.dart';
import 'package:hexagonal_sliding_puzzle/l10n/l10n.dart';
import 'package:hexagonal_sliding_puzzle/layout/layout.dart';
import 'package:hexagonal_sliding_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:hexagonal_sliding_puzzle/theme/bloc/theme_bloc.dart';
import 'package:hexagonal_sliding_puzzle/timer/bloc/timer_bloc.dart';
import 'package:hexagonal_sliding_puzzle/timer/timer_widget.dart';
import 'package:hexagonal_sliding_puzzle/typography/text_styles.dart';

/// {@template score}
/// Displays the score of the solved puzzle.
/// {@endtemplate}
class WidgetScore extends StatelessWidget {
  /// {@macro score}
  const WidgetScore({Key? key}) : super(key: key);

  static const _smallImageOffset = Offset(124, 36);
  static const _mediumImageOffset = Offset(215, -47);
  static const _largeImageOffset = Offset(215, -47);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.watch<PuzzleBloc>().state;
    final l10n = context.l10n;
    final secondsElapsed =
        context.select((TimerBloc bloc) => bloc.state.secondsElapsed);

    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final height =
            currentSize == ResponsiveLayoutSize.small ? 374.0 : 355.0;

        final imageOffset = currentSize == ResponsiveLayoutSize.large
            ? _largeImageOffset
            : (currentSize == ResponsiveLayoutSize.medium
                ? _mediumImageOffset
                : _smallImageOffset);

        final imageHeight =
            currentSize == ResponsiveLayoutSize.small ? 374.0 : 437.0;

        final completedTextWidth =
            currentSize == ResponsiveLayoutSize.small ? 160.0 : double.infinity;

        final wellDoneTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.headline4Soft
            : PuzzleTextStyle.headline3;

        final timerTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.headline5
            : PuzzleTextStyle.headline4;

        final timerIconSize = currentSize == ResponsiveLayoutSize.small
            ? const Size(21, 21)
            : const Size(28, 28);

        final timerIconPadding =
            currentSize == ResponsiveLayoutSize.small ? 4.0 : 6.0;

        final numberOfMovesTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.headline5
            : PuzzleTextStyle.headline4;

        var playingScore = 1000 - state.numberOfMoves - secondsElapsed;
        playingScore = playingScore > 0 ? playingScore : 0;

        return ClipRRect(
          key: const Key('score'),
          borderRadius: BorderRadius.circular(22),
          child: Container(
            width: double.infinity,
            height: height,
            color: theme.backgroundColor,
            child: Stack(
              children: [
                Positioned(
                  left: imageOffset.dx,
                  top: imageOffset.dy,
                  child: Image.asset(
                    theme.successThemeAsset,
                    height: imageHeight,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*const FlutterLogo(
                        size: 18,
                        //height: 18,
                        //isColored: false,
                      ),*/
                      const ResponsiveGap(
                        small: 24,
                        medium: 32,
                        large: 32,
                      ),
                      SizedBox(
                        key: const Key('score_completed'),
                        width: completedTextWidth,
                        child: AnimatedDefaultTextStyle(
                          style: PuzzleTextStyle.headline5.copyWith(
                            color: theme.defaultColor,
                          ),
                          duration: const Duration(milliseconds: 400),
                          child: Text(l10n.successCompleted),
                        ),
                      ),
                      const ResponsiveGap(
                        small: 8,
                        medium: 16,
                        large: 16,
                      ),
                      AnimatedDefaultTextStyle(
                        key: const Key('score_well_done'),
                        style: wellDoneTextStyle.copyWith(
                          color: PuzzleColors.white,
                        ),
                        duration: const Duration(milliseconds: 400),
                        child: Text(l10n.successWellDone),
                      ),
                      const ResponsiveGap(
                        small: 24,
                        medium: 32,
                        large: 32,
                      ),
                      AnimatedDefaultTextStyle(
                        key: const Key('score_score'),
                        style: PuzzleTextStyle.headline5.copyWith(
                          color: theme.defaultColor,
                        ),
                        duration: const Duration(milliseconds: 400),
                        child: Text(l10n.successScore),
                      ),
                      const ResponsiveGap(
                        small: 8,
                        medium: 9,
                        large: 9,
                      ),
                      TimerWidget(
                        textStyle: timerTextStyle,
                        iconSize: timerIconSize,
                        iconPadding: timerIconPadding,
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                      const ResponsiveGap(
                        small: 2,
                        medium: 8,
                        large: 8,
                      ),
                      AnimatedDefaultTextStyle(
                        key: const Key('score_number_of_moves'),
                        style: numberOfMovesTextStyle.copyWith(
                          color: PuzzleColors.white,
                        ),
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          l10n.successNumberOfMoves(
                            state.numberOfMoves.toString(),
                          ),
                        ),
                      ),
                      const ResponsiveGap(
                        small: 2,
                        medium: 8,
                        large: 8,
                      ),
                      AnimatedDefaultTextStyle(
                        key: const Key('score_points'),
                        style: numberOfMovesTextStyle.copyWith(
                          color: PuzzleColors.white,
                        ),
                        duration: const Duration(milliseconds: 400),
                        child: Text('$playingScore Pts'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
