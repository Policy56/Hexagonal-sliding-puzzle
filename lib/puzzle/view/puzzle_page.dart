import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexagonal_sliding_puzzle/cmp/app_download_button.dart';
import 'package:hexagonal_sliding_puzzle/cmp/switch/puzzle_switch_button.dart';
import 'package:hexagonal_sliding_puzzle/cmp/switch/switch_bloc.dart';
import 'package:hexagonal_sliding_puzzle/l10n/l10n.dart';
import 'package:hexagonal_sliding_puzzle/layout/layout.dart';
import 'package:hexagonal_sliding_puzzle/layout/modal_helper.dart';
import 'package:hexagonal_sliding_puzzle/models/models.dart';
import 'package:hexagonal_sliding_puzzle/puzzle/puzzle.dart';
import 'package:hexagonal_sliding_puzzle/theme/theme.dart';
import 'package:hexagonal_sliding_puzzle/theme/widgets/ranking/ranking_dialog.dart';
import 'package:hexagonal_sliding_puzzle/theme/widgets/share/share_dialog.dart';
import 'package:hexagonal_sliding_puzzle/timer/timer.dart';
import 'package:hexagonal_sliding_puzzle/typography/text_styles.dart';

/// {@template puzzle_page}
/// The root page of the puzzle UI.
///
/// Builds the puzzle based on the current [PuzzleTheme]
/// from [ThemeBloc].
/// {@endtemplate}
class PuzzlePage extends StatelessWidget {
  /// {@macro puzzle_page}
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(
            initialThemes: [
              //const SimpleTheme(),
              const HexagonalThemeEasy(),
              const HexagonalThemeMedium(),
              const HexagonalThemeHard(),
            ],
          ),
        ),
        BlocProvider(
          create: (_) => TimerBloc(
            ticker: const Ticker(),
          ),
        ),
        BlocProvider(
          create: (_) => SwitchBloc(
            pIsSwitched: false,
          ),
        ),
      ],
      child: const PuzzleView(),
    );
  }
}

/// {@template puzzle_view}
/// Displays the content for the [PuzzlePage].
/// {@endtemplate}
class PuzzleView extends StatelessWidget {
  /// {@macro puzzle_view}
  const PuzzleView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final size = theme.size;

    /// Shuffle only if the current theme is Simple.
    final shufflePuzzle = theme is SimpleTheme; //TODO(CCL): shuffle ici ?

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 900),
        decoration: BoxDecoration(color: theme.backgroundColor),
        child: BlocListener<ThemeBloc, ThemeState>(
          listener: (context, state) {
            final theme = context.read<ThemeBloc>().state.theme;
            context.read<ThemeBloc>().add(ThemeUpdated(theme: theme));
          },
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => TimerBloc(
                  ticker: const Ticker(),
                ),
              ),
              BlocProvider(
                create: (context) => PuzzleBloc()
                  ..add(
                    PuzzleInitialized(
                      size: size,
                      shufflePuzzle: shufflePuzzle,
                    ),
                  ),
              ),
            ],
            child: const _Puzzle(
              key: Key('puzzle_view_puzzle'),
            ),
          ),
        ),
      ),
    );
  }
}

class _Puzzle extends StatelessWidget {
  const _Puzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            //theme.layoutDelegate.backgroundBuilder(state),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: const [
                    _PuzzleHeader(
                      key: Key('puzzle_header'),
                    ), // TODO(CCL): Ici ajout du logo Flutter en haut -> Mettre logo auto
                    _PuzzleSections(
                      key: Key('puzzle_sections'),
                    ),
                    _PuzzleFooter(
                      key: Key('puzzle_footer'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PuzzleHeader extends StatelessWidget {
  const _PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ResponsiveLayoutBuilder(
        small: (context, child) => Stack(
          children: const [
            SizedBox(),
            Align(
              child: _PuzzleRanking(),
              //_PuzzleLogo(),
            ),
          ],
        ),
        medium: (context, child) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              // _PuzzleLogo(),
              _PuzzleRanking(),
              PuzzleMenu(),
            ],
          ),
        ),
        large: (context, child) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              //_PuzzleLogo(),
              _PuzzleRanking(),
              PuzzleMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PuzzleFooter extends StatelessWidget {
  const _PuzzleFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, child) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              PuzzleSwitchButton(),
            ],
          ),
          if (kIsWeb) const AppDownloadButton() else const SizedBox(),
        ],
      ),
      medium: (context, child) => SizedBox(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                PuzzleSwitchButton(),
              ],
            ),
            if (kIsWeb) const AppDownloadButton() else const SizedBox(),
          ],
        ),
      ),
      large: (context, child) => SizedBox(
        height: 30,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              if (kIsWeb) AppDownloadButton() else SizedBox(),
              PuzzleSwitchButton()
            ],
          ),
        ),
      ),
    );
  }
}

class _PuzzleLogo extends StatelessWidget {
  const _PuzzleLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, child) => const SizedBox(
        height: 24,
        child: FlutterLogo(
          style: FlutterLogoStyle.horizontal,
          size: 86,
        ),
      ),
      medium: (context, child) => const SizedBox(
        height: 29,
        child: FlutterLogo(
          style: FlutterLogoStyle.horizontal,
          size: 104,
        ),
      ),
      large: (context, child) => const SizedBox(
        height: 32,
        child: FlutterLogo(
          style: FlutterLogoStyle.horizontal,
          size: 114,
        ),
      ),
    );
  }
}

class _PuzzleRanking extends StatelessWidget {
  const _PuzzleRanking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final leftPadding =
            currentSize != ResponsiveLayoutSize.small ? 40.0 : 0.0;

        return Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Tooltip(
            message: context.l10n.rankingMenuToolTip,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ).copyWith(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () async {
                //TODO(ccl): ici affichage du ranking
                await showAppDialog<void>(
                  context: context,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: context.read<ThemeBloc>(),
                      ),
                    ],
                    child: RankingDialog(),
                  ),
                );
              },
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 400),
                style: PuzzleTextStyle.headline5.copyWith(
                  color: Colors.white, //currentTheme.menuInactiveColor,
                ),
                child: Text(context.l10n.rankingMenuMessage),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PuzzleSections extends StatelessWidget {
  const _PuzzleSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return ResponsiveLayoutBuilder(
      small: (context, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(state),
          const PuzzleMenu(),
          const PuzzleBoard(),
          theme.layoutDelegate.endSectionBuilder(state),
        ],
      ),
      medium: (context, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(state),
          const PuzzleBoard(),
          theme.layoutDelegate.endSectionBuilder(state),
        ],
      ),
      large: (context, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: theme.layoutDelegate.startSectionBuilder(state),
          ),
          const PuzzleBoard(),
          Expanded(
            child: theme.layoutDelegate.endSectionBuilder(state),
          ),
        ],
      ),
    );
  }
}

/// {@template puzzle_board}
/// Displays the board of the puzzle.
/// {@endtemplate}
class PuzzleBoard extends StatefulWidget {
  /// {@macro puzzle_board}
  const PuzzleBoard({Key? key}) : super(key: key);

  @override
  State<PuzzleBoard> createState() => _PuzzleBoardState();
}

class _PuzzleBoardState extends State<PuzzleBoard> {
  Timer? _completePuzzleTimer;

  @override
  void dispose() {
    _completePuzzleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    return BlocListener<PuzzleBloc, PuzzleState>(
      listener: (context, state) {
        if (theme.hasTimer && state.puzzleStatus == PuzzleStatus.complete) {
          context.read<TimerBloc>().add(const TimerStopped());
          _completePuzzleTimer =
              Timer(const Duration(milliseconds: 370), () async {
            await showAppDialog<void>(
              context: context,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: context.read<ThemeBloc>(),
                  ),
                  BlocProvider.value(
                    value: context.read<PuzzleBloc>(),
                  ),
                  BlocProvider.value(
                    value: context.read<TimerBloc>(),
                  ),
                ],
                child: const ShareDialog(),
              ),
            );
          });
        }
      },
      child: theme.layoutDelegate.boardBuilder(
        size,
        puzzle.tiles
            .map(
              (tile) => PuzzleTile(
                key: Key('puzzle_tile_${tile.value.toString()}'),
                tile: tile,
              ),
            )
            .toList(),
      ),
    );
  }
}

class PuzzleTile extends StatelessWidget {
  ///ctor
  const PuzzleTile({
    Key? key,
    required this.tile,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return tile.isWhitespace
        ? theme.layoutDelegate.whitespaceTileBuilder(theme.backgroundColor)
        : theme.layoutDelegate.tileBuilder(tile, state);
  }
}

/// {@template puzzle_menu}
/// Displays the menu of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleMenu extends StatelessWidget {
  /// {@macro puzzle_menu}
  const PuzzleMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themes = context.select((ThemeBloc bloc) => bloc.state.themes);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          themes.length,
          (index) => PuzzleMenuItem(
            theme: themes[index],
            themeIndex: index,
          ),
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => const SizedBox(),
          medium: (_, child) => child!,
          large: (_, child) => child!,
          child: (currentSize) {
            return Row(
              children: const [
                Gap(44),
                /*AudioControl(
                  key: audioControlKey,
                )*/
              ],
            );
          },
        ),
      ],
    );
  }
}

/// {@template puzzle_menu_item}
/// Displays the menu item of the [PuzzleMenu].
/// {@endtemplate}
@visibleForTesting
class PuzzleMenuItem extends StatelessWidget {
  /// {@macro puzzle_menu_item}
  const PuzzleMenuItem({
    Key? key,
    required this.theme,
    required this.themeIndex,
  }) : super(key: key);

  /// The theme corresponding to this menu item.
  final PuzzleTheme theme;

  /// The index of [theme] in [ThemeState.themes].
  final int themeIndex;

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final isCurrentTheme = theme == currentTheme;

    return ResponsiveLayoutBuilder(
      small: (_, child) => Column(
        children: [
          Container(
            width: 100,
            height: 40,
            decoration: isCurrentTheme
                ? BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: currentTheme.menuUnderlineColor,
                      ),
                    ),
                  )
                : null,
            child: child,
          ),
        ],
      ),
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final leftPadding =
            themeIndex > 0 && currentSize != ResponsiveLayoutSize.small
                ? 40.0
                : 0.0;

        return Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Tooltip(
            message:
                theme != currentTheme ? context.l10n.puzzleChangeTooltip : '',
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ).copyWith(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                // Ignore if this theme is already selected.
                if (theme == currentTheme) {
                  return;
                }

                // Update the currently selected theme.
                context
                    .read<ThemeBloc>()
                    .add(ThemeChanged(themeIndex: themeIndex));

                // Reset the timer of the currently running puzzle.
                context.read<TimerBloc>().add(const TimerReset());

                // Initialize the puzzle board for the newly selected theme.
                context.read<PuzzleBloc>().add(
                      PuzzleInitialized(
                        size: theme.size,
                        shufflePuzzle: theme
                            is SimpleTheme, //TODO(CCL) : ici on dis si on shuffle le puzzle
                      ),
                    );

                context.read<SwitchBloc>().add(
                      const SwitchTap(isSwitched: false),
                    );
              },
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 400),
                style: PuzzleTextStyle.headline5.copyWith(
                  color: isCurrentTheme
                      ? currentTheme.menuActiveColor
                      : currentTheme.menuInactiveColor,
                ),
                child: Text(theme.name),
              ),
            ),
          ),
        );
      },
    );
  }
}
