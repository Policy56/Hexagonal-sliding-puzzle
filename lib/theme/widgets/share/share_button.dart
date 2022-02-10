import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexagonal_sliding_puzzle/l10n/l10n.dart';
import 'package:hexagonal_sliding_puzzle/layout/links_helper.dart';
import 'package:hexagonal_sliding_puzzle/models/rankings_dao.dart';
import 'package:hexagonal_sliding_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:hexagonal_sliding_puzzle/theme/bloc/theme_bloc.dart';
import 'package:hexagonal_sliding_puzzle/timer/bloc/timer_bloc.dart';
import 'package:hexagonal_sliding_puzzle/typography/text_styles.dart';
import 'package:twitter_intent/twitter_intent.dart';
import 'package:url_launcher/url_launcher.dart';

/// The url to share for this Flutter Puzzle challenge.
const _shareUrl = 'https://hexagonal-sliding-puzzle.web.app/';

/// {@template twitter_button}
/// Displays a button that shares the Flutter Puzzle challenge
/// on Twitter when tapped.
/// {@endtemplate}
class TwitterButton extends StatelessWidget {
  /// {@macro twitter_button}
  const TwitterButton({Key? key}) : super(key: key);

  String _twitterShareUrl(BuildContext context, String nbMoves) {
    final shareText = context.l10n.successShareText(nbMoves);
    final encodedShareText = Uri.encodeComponent(shareText);
    return 'https://twitter.com/intent/tweet?url=$_shareUrl&text=$encodedShareText';
  }

  TweetIntent _twitterShareIntent(BuildContext context, String nbMoves) {
    final shareText = context.l10n.successShareText(nbMoves);

    return TweetIntent(
      hashtags: ['Hexagonal'],
      text: shareText,
      via: 'HexagonalGame',
      url: _shareUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PuzzleBloc>().state;
    final l10n = context.l10n;
    return ShareButton(
      title: 'Twitter',
      icon: Image.asset(
        'assets/images/twitter_icon.png',
        width: 13.13,
        height: 10.67,
      ),
      color: const Color(0xFF13B9FD),
      onPressed: () {
        if (kIsWeb) {
          openLink(
            _twitterShareUrl(
              context,
              state.numberOfMoves.toString(),
            ),
          );
        } else {
          launch(
            '${_twitterShareIntent(
              context,
              state.numberOfMoves.toString(),
            )}',
          );
        }
      },
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

  String _facebookShareUrl(BuildContext context, String nbMoves) {
    final shareText = context.l10n.successShareText(nbMoves);
    final encodedShareText = Uri.encodeComponent(shareText);
    return 'https://www.facebook.com/sharer.php?u=$_shareUrl&quote=$encodedShareText';
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PuzzleBloc>().state;
    final l10n = context.l10n;

    return ShareButton(
      title: 'Facebook',
      icon: Image.asset(
        'assets/images/facebook_icon.png',
        width: 6.56,
        height: 13.13,
      ),
      color: const Color(0xFF0468D7),
      onPressed: () => openLink(
        _facebookShareUrl(
          context,
          state.numberOfMoves.toString(),
        ),
      ),
    );
  }
}

/// {@template save_my_score_button}
/// Save my Score button with Username Texfield
/// {@endtemplate}
class SaveScoreButton extends StatefulWidget {
  /// {@macro save_my_score_button}
  SaveScoreButton({Key? key}) : super(key: key);

  @override
  State<SaveScoreButton> createState() => _SaveScoreButtonState();
}

class _SaveScoreButtonState extends State<SaveScoreButton> {
  TextEditingController usernameController = TextEditingController();

  bool _validate = true;
  bool _send = false;

  /// Dao of rankings
  final rankingsDao = RankingsDAO();

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final stateBloc = context.watch<PuzzleBloc>().state;
    final secondsElapsed =
        context.select((TimerBloc bloc) => bloc.state.secondsElapsed);

    final l10n = context.l10n;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 53, 215, 4)),
        color: _send ? Color.fromARGB(121, 131, 131, 131) : null,
        borderRadius: BorderRadius.circular(32),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          primary: const Color.fromARGB(255, 53, 215, 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          backgroundColor: Colors.transparent,
        ),
        onPressed: _send
            ? null
            : () async {
                if (usernameController.text == '' ||
                    usernameController.text.length > 10) {
                  setState(() {
                    _validate = true;
                  });
                } else {
                  rankingsDao.saveMyRank(
                      usernameController.text,
                      theme.name.toLowerCase(),
                      stateBloc.numberOfMoves,
                      secondsElapsed,
                      theme.baseScore);
                  setState(() {
                    _send = true;
                  });
                }
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
                color: const Color.fromARGB(255, 53, 215, 4),
                child: const Icon(
                  Icons.save_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            const Gap(10),
            /**/
            Container(
              height: 32,
              width: 120,
              child: TextFormField(
                enabled: _send == false,
                controller: usernameController,
                textAlign: TextAlign.center,
                maxLength: 10,
                decoration: InputDecoration(
                  hintText: 'Username',
                  errorText: _validate ? null : 'Enter a valid username.',
                  hintStyle: Theme.of(context).textTheme.caption!.copyWith(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  // errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,

                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 15, right: 15),
                  counterText: "",
                  fillColor: Colors.red,
                ),
              ),
            ),
            const Gap(24),
            Text(
              "Save",
              style: PuzzleTextStyle.headline5.copyWith(
                color: const Color.fromARGB(255, 53, 215, 4),
              ),
            ),
            const Gap(24),
          ],
        ),
      ),
    );

    /*return ShareButton(
      title: 'Facebook',
      icon: Icon(Icons.save_rounded),
      color: const Color.fromARGB(255, 53, 215, 4),
      onPressed: () => print("CCL SAVE")
    );*/
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
