import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexagonal_sliding_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:hexagonal_sliding_puzzle/theme/theme.dart';
import 'package:hexagonal_sliding_puzzle/theme/widgets/share_button.dart';
import 'package:hexagonal_sliding_puzzle/layout/links_helper.dart';

/// Displays the action button to start or shuffle the puzzle
/// based on the current puzzle state.
class AppDownloadButton extends StatefulWidget {
  const AppDownloadButton({Key? key}) : super(key: key);

  @override
  State<AppDownloadButton> createState() => _AppDownloadButtonState();
}

class _AppDownloadButtonState extends State<AppDownloadButton> {
  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final status = context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Tooltip(
          key: ValueKey('${status}_ios'),
          message: 'Download iOS App of Hexagonal Sliding Puzzle.',
          verticalOffset: 40,
          child: ShareButton(
            title: 'Ios app',
            icon: Image.asset(
              'assets/images/ios_icon.png',
              width: 15,
              height: 30,
            ),
            color: theme.defaultColor,
            colorTitle: Colors.white,
            onPressed: () => openLink(
              'https://apps.apple.com/app/id1609083334',
            ),
          ),
        ),
        const Gap(20),
        Tooltip(
          key: ValueKey('${status}_android'),
          message: 'Download Android App of Hexagonal Sliding Puzzle.',
          verticalOffset: 40,
          child: ShareButton(
            title: 'Android app',
            icon: Image.asset(
              'assets/images/android_icon.png',
              width: 15,
              height: 30,
            ),
            color: theme.defaultColor,
            colorTitle: Colors.white,
            onPressed: () => openLink(
              'https://play.google.com/store/apps/details?id=com.policy.hexagonalslidingpuzzle',
            ),
          ),
        ),
      ],
    );
  }
}
