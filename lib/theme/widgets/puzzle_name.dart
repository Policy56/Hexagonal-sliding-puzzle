import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexagonal_sliding_puzzle/layout/layout.dart';
import 'package:hexagonal_sliding_puzzle/theme/theme.dart';
import 'package:hexagonal_sliding_puzzle/typography/typography.dart';

/// {@template puzzle_name}
/// Displays the name of the current puzzle theme.
/// Visible only on a large layout.
/// {@endtemplate}
class PuzzleName extends StatelessWidget {
  /// {@macro puzzle_name}
  const PuzzleName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = context.select((ThemeBloc bloc) => bloc.state.theme).name;
    final color =
        context.select((ThemeBloc bloc) => bloc.state.theme).hoverColor;

    return ResponsiveLayoutBuilder(
      small: (context, child) => const SizedBox(),
      medium: (context, child) => const SizedBox(),
      large: (context, child) => Text(
        name,
        style: PuzzleTextStyle.headline5.copyWith(
          color: color,
        ),
      ),
    );
  }
}
