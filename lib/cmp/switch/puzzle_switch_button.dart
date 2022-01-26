import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexagonal_sliding_puzzle/cmp/switch/switch_bloc.dart';
import 'package:hexagonal_sliding_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:hexagonal_sliding_puzzle/theme/theme.dart';
import 'package:hexagonal_sliding_puzzle/l10n/l10n.dart';
import 'package:hexagonal_sliding_puzzle/typography/text_styles.dart';

/// Displays the action button to start or shuffle the puzzle
/// based on the current puzzle state.
class PuzzleSwitchButton extends StatefulWidget {
  const PuzzleSwitchButton({Key? key}) : super(key: key);

  @override
  State<PuzzleSwitchButton> createState() => _PuzzleSwitchButtonState();
}

class _PuzzleSwitchButtonState extends State<PuzzleSwitchButton> {
  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final status = context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus);
    final isSwitched = context.select((SwitchBloc bloc) => bloc.state.isTapped);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Tooltip(
        key: ValueKey(status),
        message: context.l10n.puzzleSwitchTooltip,
        verticalOffset: 40,
        child: Row(
          children: [
            Text(
              'Correct tiles',
              style: PuzzleTextStyle.headline5.copyWith(
                color: theme.defaultColor,
              ),
            ),
            Switch(
              activeColor: theme.menuActiveColor,
              value: isSwitched,
              onChanged: (bool value) {
                context.read<SwitchBloc>().add(SwitchTap(isSwitched: value));
              },
            ),
          ],
        ),
      ),
    );
  }
}
