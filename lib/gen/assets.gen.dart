/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/android_icon.png
  AssetGenImage get androidIcon =>
      const AssetGenImage('assets/images/android_icon.png');

  /// File path: assets/images/facebook_icon.png
  AssetGenImage get facebookIcon =>
      const AssetGenImage('assets/images/facebook_icon.png');

  /// File path: assets/images/ios_icon.png
  AssetGenImage get iosIcon =>
      const AssetGenImage('assets/images/ios_icon.png');

  /// File path: assets/images/logo_launch.png
  AssetGenImage get logoLaunch =>
      const AssetGenImage('assets/images/logo_launch.png');

  /// File path: assets/images/shuffle_icon.png
  AssetGenImage get shuffleIcon =>
      const AssetGenImage('assets/images/shuffle_icon.png');

  /// File path: assets/images/simple_dash_large.png
  AssetGenImage get simpleDashLarge =>
      const AssetGenImage('assets/images/simple_dash_large.png');

  /// File path: assets/images/simple_dash_medium.png
  AssetGenImage get simpleDashMedium =>
      const AssetGenImage('assets/images/simple_dash_medium.png');

  /// File path: assets/images/simple_dash_small.png
  AssetGenImage get simpleDashSmall =>
      const AssetGenImage('assets/images/simple_dash_small.png');

  $AssetsImagesSuccessGen get success => const $AssetsImagesSuccessGen();

  /// File path: assets/images/timer_icon.png
  AssetGenImage get timerIcon =>
      const AssetGenImage('assets/images/timer_icon.png');

  /// File path: assets/images/twitter_icon.png
  AssetGenImage get twitterIcon =>
      const AssetGenImage('assets/images/twitter_icon.png');
}

class $AssetsImagesSuccessGen {
  const $AssetsImagesSuccessGen();

  /// File path: assets/images/success/blue.png
  AssetGenImage get blue =>
      const AssetGenImage('assets/images/success/blue.png');

  /// File path: assets/images/success/green.png
  AssetGenImage get green =>
      const AssetGenImage('assets/images/success/green.png');

  /// File path: assets/images/success/success_rotate_easy.png
  AssetGenImage get successRotateEasy =>
      const AssetGenImage('assets/images/success/success_rotate_easy.png');

  /// File path: assets/images/success/success_rotate_hard.png
  AssetGenImage get successRotateHard =>
      const AssetGenImage('assets/images/success/success_rotate_hard.png');

  /// File path: assets/images/success/success_rotate_medium.png
  AssetGenImage get successRotateMedium =>
      const AssetGenImage('assets/images/success/success_rotate_medium.png');

  /// File path: assets/images/success/yellow.png
  AssetGenImage get yellow =>
      const AssetGenImage('assets/images/success/yellow.png');
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
