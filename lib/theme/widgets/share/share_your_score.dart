import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hexagonal_sliding_puzzle/colors/colors.dart';
import 'package:hexagonal_sliding_puzzle/l10n/l10n.dart';
import 'package:hexagonal_sliding_puzzle/layout/layout.dart';
import 'package:hexagonal_sliding_puzzle/theme/widgets/share/share_button.dart';
import 'package:hexagonal_sliding_puzzle/theme/widgets/share/share_dialog_animated_builder.dart';
import 'package:hexagonal_sliding_puzzle/typography/text_styles.dart';

/// {@template share_your_score}
/// Displays buttons to share a score of the completed puzzle.
/// {@endtemplate}
class ShareYourScore extends StatelessWidget {
  /// {@macro share_your_score}
  const ShareYourScore({
    Key? key,
    required this.animation,
    required this.shareImageFunction,
  }) : super(key: key);

  /// The entry animation of this widget.
  final ShareDialogEnterAnimation animation;

  ///final function to shareimage
  final Function shareImageFunction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // const playerScore = 0;

    final shareButton = <Widget>[];
    if (!kIsWeb) {
      shareButton.add(const Gap(32));
      // ignore: cascade_invocations
      shareButton.add(
        SizedBox(
          height: 32,
          child: ShareMyScoreImage(
            shareImage: shareImageFunction,
          ),
        ),
      );
    }

    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final titleTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.headline4
            : PuzzleTextStyle.headline3;

        final messageTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.bodyXSmall
            : PuzzleTextStyle.bodySmall;

        final titleAndMessageCrossAxisAlignment =
            currentSize == ResponsiveLayoutSize.large
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center;

        final textAlign = currentSize == ResponsiveLayoutSize.large
            ? TextAlign.left
            : TextAlign.center;

        final messageWidth = currentSize == ResponsiveLayoutSize.large
            ? double.infinity
            : (currentSize == ResponsiveLayoutSize.medium ? 434.0 : 307.0);

        /*final buttonsMainAxisAlignment =
            currentSize == ResponsiveLayoutSize.large
                ? MainAxisAlignment.start
                : MainAxisAlignment.center;*/

        return Column(
          key: const Key('share_your_score'),
          crossAxisAlignment: titleAndMessageCrossAxisAlignment,
          children: [
            SlideTransition(
              position: animation.shareYourScoreOffset,
              child: Opacity(
                opacity: animation.shareYourScoreOpacity.value,
                child: Column(
                  crossAxisAlignment: titleAndMessageCrossAxisAlignment,
                  children: [
                    Text(
                      l10n.successShareYourScoreTitle,
                      key: const Key('share_your_score_title'),
                      textAlign: textAlign,
                      style: titleTextStyle.copyWith(
                        color: PuzzleColors.black,
                      ),
                    ),
                    const Gap(16),
                    SizedBox(
                      width: messageWidth,
                      child: Text(
                        l10n.successShareYourScoreMessage,
                        key: const Key('share_your_score_message'),
                        textAlign: textAlign,
                        style: messageTextStyle.copyWith(
                          color: PuzzleColors.grey1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const ResponsiveGap(
              small: 40,
              medium: 40,
              large: 24,
            ),
            SlideTransition(
              position: animation.socialButtonsOffset,
              child: Opacity(
                opacity: animation.socialButtonsOpacity.value,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 32,
                      child: SaveScoreButton(),
                    ),
                    if (shareButton.isNotEmpty)
                      shareButton[0]
                    else
                      const SizedBox(),
                    if (shareButton.length > 1)
                      shareButton[1]
                    else
                      const SizedBox(),
                    const Gap(16),
                    SizedBox(
                      height: 32,
                      child: Row(
                        children: const [
                          Expanded(child: TwitterButton()),
                          Gap(16),
                          Expanded(child: FacebookButton()),
                        ],
                      ),
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
