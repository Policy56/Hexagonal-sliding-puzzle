import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hexagonal_sliding_puzzle/l10n/l10n.dart';
import 'package:hexagonal_sliding_puzzle/layout/links_helper.dart';
import 'package:hexagonal_sliding_puzzle/typography/text_styles.dart';

/// The url to share for this Flutter Puzzle challenge.
const _shareUrl = 'https://hexagonal-sliding-puzzle.web.app/';

/// {@template twitter_button}
/// Displays a button that shares the Flutter Puzzle challenge
/// on Twitter when tapped.
/// {@endtemplate}
class TwitterButton extends StatelessWidget {
  /// {@macro twitter_button}
  const TwitterButton({Key? key}) : super(key: key);

  String _twitterShareUrl(BuildContext context) {
    final shareText = context.l10n.successShareText;
    final encodedShareText = Uri.encodeComponent(shareText);
    return 'https://twitter.com/intent/tweet?url=$_shareUrl&text=$encodedShareText';
  }

  @override
  Widget build(BuildContext context) {
    return ShareButton(
      title: 'Twitter',
      icon: Image.asset(
        'assets/images/twitter_icon.png',
        width: 13.13,
        height: 10.67,
      ),
      color: const Color(0xFF13B9FD),
      onPressed: () => openLink(_twitterShareUrl(context)),
    );
  }
}

/// {@template facebook_button}
/// Displays a button that shares the Flutter Puzzle challenge
/// on Facebook when tapped.
/// {@endtemplate}
class FacebookButton extends StatelessWidget {
  /// {@macro facebook_button}
  const FacebookButton({Key? key}) : super(key: key);

  String _facebookShareUrl(BuildContext context) {
    final shareText = context.l10n.successShareText;
    final encodedShareText = Uri.encodeComponent(shareText);
    return 'https://www.facebook.com/sharer.php?u=$_shareUrl&quote=$encodedShareText';
  }

  @override
  Widget build(BuildContext context) {
    return ShareButton(
      title: 'Facebook',
      icon: Image.asset(
        'assets/images/facebook_icon.png',
        width: 6.56,
        height: 13.13,
      ),
      color: const Color(0xFF0468D7),
      onPressed: () => openLink(_facebookShareUrl(context)),
    );
  }
}

/// {@template share_button}
/// Displays a share button colored with [color] which
/// displays the [icon] and [title] as its content.
/// {@endtemplate}
@visibleForTesting
class ShareButton extends StatefulWidget {
  /// {@macro share_button}
  const ShareButton(
      {Key? key,
      required this.onPressed,
      required this.title,
      required this.icon,
      required this.color,
      this.colorTitle})
      : super(key: key);

  /// Called when the button is tapped or otherwise activated.
  final VoidCallback onPressed;

  /// The title of this button.
  final String title;

  /// The icon of this button.
  final Widget icon;

  /// The color of this button.
  final Color color;

  /// The color of this button.
  final Color? colorTitle;

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: widget.color),
        borderRadius: BorderRadius.circular(32),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          primary: widget.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          backgroundColor: Colors.transparent,
        ),
        onPressed: () async {
          widget.onPressed();
        },
        child: Row(
          children: [
            const Gap(12),
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                alignment: Alignment.center,
                width: 32,
                height: 32,
                color: widget.color,
                child: widget.icon,
              ),
            ),
            const Gap(10),
            Text(
              widget.title,
              style: PuzzleTextStyle.headline5.copyWith(
                color: widget.colorTitle ?? widget.color,
              ),
            ),
            const Gap(24),
          ],
        ),
      ),
    );
  }
}
