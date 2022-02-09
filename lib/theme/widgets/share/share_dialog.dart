import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexagonal_sliding_puzzle/colors/colors.dart';
import 'package:hexagonal_sliding_puzzle/layout/layout.dart';
import 'package:hexagonal_sliding_puzzle/theme/widgets/share/share_dialog_animated_builder.dart';
import 'package:hexagonal_sliding_puzzle/theme/widgets/share/share_your_score.dart';
import 'package:hexagonal_sliding_puzzle/theme/widgets/share/widget_score.dart';

/// {@template share_dialog}
/// Displays a share dialog with a score of the completed puzzle
/// and an option to share the score using Twitter or Facebook.
/// {@endtemplate}
class ShareDialog extends StatefulWidget {
  /// {@macro share_dialog}
  const ShareDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog>
    with TickerProviderStateMixin {
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
          key: const Key('key_share_dialog'),
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
                            children: [
                              SlideTransition(
                                position: animation.scoreOffset,
                                child: Opacity(
                                  opacity: animation.scoreOpacity.value,
                                  child: const WidgetScore(),
                                ),
                              ),
                              const ResponsiveGap(
                                small: 40,
                                medium: 40,
                                large: 80,
                              ),
                              ShareYourScore(
                                animation: animation,
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
                key: const Key('share_dialog_close_button'),
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
}
