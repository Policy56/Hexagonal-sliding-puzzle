import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexagonal_sliding_puzzle/colors/colors.dart';
import 'package:hexagonal_sliding_puzzle/layout/layout.dart';
import 'package:hexagonal_sliding_puzzle/timer/bloc/timer_bloc.dart';
import 'package:hexagonal_sliding_puzzle/typography/text_styles.dart';

/// Displays how many seconds elapsed since starting the puzzle.
class TimerWidget extends StatelessWidget {
  /// ctor
  const TimerWidget({
    Key? key,
    this.textStyle,
    this.iconSize,
    this.iconPadding,
    this.mainAxisAlignment,
  }) : super(key: key);

  /// The optional [TextStyle] of this timer.
  final TextStyle? textStyle;

  /// The optional icon [Size] of this timer.
  final Size? iconSize;

  /// The optional icon padding of this timer.
  final double? iconPadding;

  /// The optional [MainAxisAlignment] of this timer.
  /// Defaults to [MainAxisAlignment.center] if not provided.
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final secondsElapsed =
        context.select((TimerBloc bloc) => bloc.state.secondsElapsed);

    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final currentTextStyle = textStyle ??
            (currentSize == ResponsiveLayoutSize.small
                ? PuzzleTextStyle.headline4
                : PuzzleTextStyle.headline3);

        final currentIconSize = iconSize ??
            (currentSize == ResponsiveLayoutSize.small
                ? const Size(28, 28)
                : const Size(32, 32));

        final timeElapsed = Duration(seconds: secondsElapsed);

        return Row(
          key: const Key('timer'),
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              style: currentTextStyle.copyWith(
                color: PuzzleColors.white,
              ),
              duration: const Duration(milliseconds: 400),
              child: Text(
                _formatDuration(timeElapsed),
                key: ValueKey(secondsElapsed),
                //semanticsLabel: _getDurationLabel(timeElapsed, context),
              ),
            ),
            Gap(iconPadding ?? 8),
            Image.asset(
              'assets/images/timer_icon.png',
              key: const Key('timer_icon'),
              width: currentIconSize.width,
              height: currentIconSize.height,
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
