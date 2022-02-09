import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexagonal_sliding_puzzle/colors/colors.dart';
import 'package:hexagonal_sliding_puzzle/l10n/l10n.dart';
import 'package:hexagonal_sliding_puzzle/layout/layout.dart';
import 'package:hexagonal_sliding_puzzle/theme/bloc/theme_bloc.dart';
import 'package:hexagonal_sliding_puzzle/theme/widgets/share/share_dialog_animated_builder.dart';
import 'package:hexagonal_sliding_puzzle/theme/widgets/shimmer/shimmer_loading.dart';
import 'package:hexagonal_sliding_puzzle/theme/widgets/shimmer/shimmer_widget.dart';
import 'package:hexagonal_sliding_puzzle/typography/text_styles.dart';

/// {@template ranking_dialog}
/// Displays a ranking dialog with the best score of the completed puzzle in
/// this difficulty
/// {@endtemplate}
class RankingDialog extends StatefulWidget {
  /// {@macro ranking_dialog}
  const RankingDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<RankingDialog> createState() => _RankingDialogState();
}

class _RankingDialogState extends State<RankingDialog>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  late final AnimationController _controller;

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

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
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: _isLoading
                                          ? const NeverScrollableScrollPhysics()
                                          : const BouncingScrollPhysics(
                                              parent:
                                                  NeverScrollableScrollPhysics(),
                                            ),
                                      /* physics: _isLoading
                                          ? const NeverScrollableScrollPhysics()
                                          : null,*/
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
                  _toggleLoading();
                  //Navigator.of(context).pop();
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
      stops: [
        0.1,
        0.3,
        0.4,
      ],
      begin: Alignment(-1.0, -0.3),
      end: Alignment(1.0, 0.3),
      tileMode: TileMode.clamp,
    );
  }

  Widget _buildListItem() {
    return ShimmerLoading(
      isLoading: _isLoading,
      child: PlayerRankItem(
        isLoading: _isLoading,
      ),
    );
  }
}

/// Ligne of the User
class PlayerRankItem extends StatelessWidget {
  const PlayerRankItem({
    Key? key,
    required this.isLoading,
  }) : super(key: key);

  final bool isLoading;

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
    return AspectRatio(
      aspectRatio: 16 / 2,
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
