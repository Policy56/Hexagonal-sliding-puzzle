import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexagonal_sliding_puzzle/colors/colors.dart';
import 'package:hexagonal_sliding_puzzle/l10n/l10n.dart';
import 'package:hexagonal_sliding_puzzle/layout/layout.dart';
import 'package:hexagonal_sliding_puzzle/models/ranking.dart';
import 'package:hexagonal_sliding_puzzle/models/rankings_dao.dart';
import 'package:hexagonal_sliding_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:hexagonal_sliding_puzzle/theme/bloc/theme_bloc.dart';
import 'package:hexagonal_sliding_puzzle/theme/widgets/share/share_dialog_animated_builder.dart';
import 'package:hexagonal_sliding_puzzle/theme/widgets/shimmer/shimmer_loading.dart';
import 'package:hexagonal_sliding_puzzle/theme/widgets/shimmer/shimmer_widget.dart';
import 'package:hexagonal_sliding_puzzle/timer/bloc/timer_bloc.dart';
import 'package:hexagonal_sliding_puzzle/typography/text_styles.dart';
import 'package:valuable/valuable.dart';

/// {@template ranking_dialog}
/// Displays a ranking dialog with the best score of the completed puzzle in
/// this difficulty
/// {@endtemplate}
class RankingDialog extends StatefulWidget {
  /// {@macro ranking_dialog}
  ///

  RankingDialog({
    Key? key,
  }) : super(key: key);

  /// Dao of rankings
  final rankingsDao = RankingsDAO();

  @override
  State<RankingDialog> createState() => _RankingDialogState();
}

class _RankingDialogState extends State<RankingDialog>
    with TickerProviderStateMixin {
  final StatefulValuable<bool> _isLoading = StatefulValuable<bool>(true);
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    Future.delayed(
      const Duration(milliseconds: 140),
      _controller.forward,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    /*final stateBloc = context.watch<PuzzleBloc>().state;
    final secondsElapsed =
        context.select((TimerBloc bloc) => bloc.state.secondsElapsed);*/

    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final padding = currentSize == ResponsiveLayoutSize.large
            ? const EdgeInsets.fromLTRB(68, 82, 68, 73)
            : (currentSize == ResponsiveLayoutSize.medium
                ? const EdgeInsets.fromLTRB(48, 54, 48, 53)
                : const EdgeInsets.fromLTRB(20, 99, 20, 76));

        final closeIconOffset = currentSize == ResponsiveLayoutSize.large
            ? const Offset(44, 37)
            : (currentSize == ResponsiveLayoutSize.medium
                ? const Offset(25, 28)
                : const Offset(17, 63));

        final crossAxisAlignment = currentSize == ResponsiveLayoutSize.large
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center;

        var firedatabaseOnValue = widget.rankingsDao
            .getRefOfInstance()
            .child(theme.name.toLowerCase())
            .orderByChild('score')
            // .limitToFirst(10)
            .onValue;

        return Stack(
          key: const Key('key_ranking_dialog'),
          children: [
            SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: Padding(
                      padding: padding,
                      child: ShareDialogAnimatedBuilder(
                        animation: _controller,
                        builder: (context, child, animation) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: crossAxisAlignment,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SlideTransition(
                                position: animation.scoreOffset,
                                child: Opacity(
                                  opacity: animation.scoreOpacity.value,
                                  child: Text(
                                    context.l10n.rankingMenuMessage,
                                    textAlign: TextAlign.center,
                                    style: PuzzleTextStyle.headline3.copyWith(
                                      color: theme.menuActiveColor,
                                    ),
                                  ),
                                ),
                              ),
                              const ResponsiveGap(
                                small: 10,
                                medium: 20,
                                large: 40,
                              ),
                              SlideTransition(
                                position: animation.scoreOffset,
                                child: Opacity(
                                  opacity: animation.scoreOpacity.value,
                                  child: ShimmerWidget(
                                    linearGradient: _returnedGradient(
                                      theme.backgroundColor,
                                      theme.defaultColor,
                                    ),
                                    child: ValuableConsumer(
                                      builder: (BuildContext context,
                                          ValuableWatcher watch, _) {
                                        return StreamBuilder<DatabaseEvent>(
                                          stream: firedatabaseOnValue,
                                          builder: (
                                            context,
                                            AsyncSnapshot<DatabaseEvent>
                                                snapEvent,
                                          ) {
                                            if (snapEvent.hasData &&
                                                !snapEvent.hasError &&
                                                snapEvent.data != null) {
                                              if (snapEvent.data!.snapshot
                                                          .value !=
                                                      null &&
                                                  (snapEvent.data!.snapshot
                                                          .value as Map)
                                                      .isNotEmpty) {
                                                List<Widget> _listWidget = [
                                                  const SizedBox(height: 8)
                                                ];
                                                //taking the data snapshot.
                                                final snapshot =
                                                    snapEvent.data!.snapshot;

                                                List<RankingItem> items =
                                                    <RankingItem>[];
                                                Map<String, dynamic> _list =
                                                    (snapshot.value as Map<
                                                        String, dynamic>);

                                                var snapList =
                                                    Map<String, dynamic>.from(
                                                            snapshot.value
                                                                as Map<String,
                                                                    dynamic>)
                                                        .values
                                                        .toList()
                                                      ..sort((dynamic a,
                                                              dynamic b) =>
                                                          (b['score'] as int)
                                                              .compareTo(
                                                                  (a['score']
                                                                      as int)));

                                                snapList
                                                    .forEach((dynamic value) {
                                                  //print(value.toString());
                                                  RankingItem tempRankingItem =
                                                      RankingItem.fromJson(value
                                                          as Map<String,
                                                              dynamic>);
                                                  items.add(tempRankingItem);
                                                  _listWidget.add(
                                                    _buildListItem(
                                                      index: items.length,
                                                      rankingItem:
                                                          tempRankingItem,
                                                      backgroundColor:
                                                          theme.backgroundColor,
                                                      l10n: context.l10n,
                                                    ),
                                                  );
                                                });

                                                _isLoading.setValue(false);
                                                return ListView(
                                                  shrinkWrap: true,
                                                  physics: watch(_isLoading)
                                                          as bool
                                                      ? const NeverScrollableScrollPhysics()
                                                      : const BouncingScrollPhysics(
                                                          parent:
                                                              NeverScrollableScrollPhysics(),
                                                        ),
                                                  children: _listWidget,
                                                );
                                              } else {
                                                return Text(
                                                  context.l10n.noRankingMessage,
                                                  textAlign: TextAlign.center,
                                                  style: PuzzleTextStyle
                                                      .headline5
                                                      .copyWith(
                                                    color:
                                                        theme.menuActiveColor,
                                                  ),
                                                );
                                              }
                                            } else {
                                              return ListView(
                                                shrinkWrap: true,
                                                physics: watch(_isLoading)
                                                        as bool
                                                    ? const NeverScrollableScrollPhysics()
                                                    : const BouncingScrollPhysics(
                                                        parent:
                                                            NeverScrollableScrollPhysics(),
                                                      ),
                                                children: [
                                                  const SizedBox(height: 8),
                                                  _buildListItem(),
                                                  _buildListItem(),
                                                  _buildListItem(),
                                                  _buildListItem(),
                                                  _buildListItem(),
                                                  _buildListItem(),
                                                  _buildListItem(),
                                                  _buildListItem(),
                                                ],
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              right: closeIconOffset.dx,
              top: closeIconOffset.dy,
              child: IconButton(
                key: const Key('ranking_dialog_close_button'),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 18,
                icon: const Icon(
                  Icons.close,
                  color: PuzzleColors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  LinearGradient _returnedGradient(Color pColorBg, Color pColorHL) {
    return LinearGradient(
      colors: [
        //  Color(0xFFEBEBF4),
        //Color(0xFFF4F4F4),
        //Color(0xFFEBEBF4),
        pColorBg,
        pColorHL,
        pColorBg,
      ],
      stops: const [
        0.1,
        0.3,
        0.4,
      ],
      begin: const Alignment(-1.0, -0.3),
      end: const Alignment(1.0, 0.3),
      tileMode: TileMode.clamp,
    );
  }

  Widget _buildListItem(
      {int? index,
      RankingItem? rankingItem,
      Color? backgroundColor,
      AppLocalizations? l10n}) {
    return ValuableConsumer(
      builder: (BuildContext context, ValuableWatcher watch, _) {
        return ShimmerLoading(
          isLoading: watch(_isLoading) as bool,
          child: PlayerRankItem(
            index: index,
            isLoading: watch(_isLoading) as bool,
            rankingItem: rankingItem,
            backgroundColor: backgroundColor,
            l10n: l10n,
          ),
        );
      },
    );
  }
}

/// Ligne of the User
class PlayerRankItem extends StatelessWidget {
  const PlayerRankItem({
    Key? key,
    required this.isLoading,
    required this.index,
    required this.rankingItem,
    required this.backgroundColor,
    required this.l10n,
  }) : super(key: key);

  final bool isLoading;

  final RankingItem? rankingItem;

  final Color? backgroundColor;

  final int? index;

  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLine(),
        ],
      ),
    );
  }

  Widget _buildLine() {
    var timeDuration = Duration(
        seconds: (rankingItem != null) ? rankingItem!.nbSeconds.floor() : 0);

    return AspectRatio(
      aspectRatio: 16 / 2,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ValuableConsumer(
            builder: (BuildContext context, ValuableWatcher watch, _) {
              return isLoading
                  ? Image.network(
                      'https://flutter'
                      '.dev/docs/cookbook/img-files/effects/split-check/Food1.jpg',
                      fit: BoxFit.cover,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            index.toString(),
                            textAlign: TextAlign.center,
                            style: PuzzleTextStyle.headline3.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            rankingItem!.user,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: PuzzleTextStyle.headline4Soft.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    rankingItem!.nbTilesMoved.toString(),
                                    textAlign: TextAlign.center,
                                    style: PuzzleTextStyle.headline5.copyWith(
                                      overflow: TextOverflow.fade,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.fade,
                                  ),
                                  Text(
                                    l10n!.puzzleNumberOfMovesShort,
                                    textAlign: TextAlign.center,
                                    style: PuzzleTextStyle.headline5.copyWith(
                                      overflow: TextOverflow.fade,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.fade,
                                  ),
                                ],
                              ),
                              Text(
                                _formatDuration(timeDuration),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: PuzzleTextStyle.headline5.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}

class CardListItem extends StatelessWidget {
  const CardListItem({
    Key? key,
    required this.isLoading,
  }) : super(key: key);

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          const SizedBox(height: 16),
          _buildText(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            'https://flutter'
            '.dev/docs/cookbook/img-files/effects/split-check/Food1.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    if (isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 250,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
          'eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        ),
      );
    }
  }
}
