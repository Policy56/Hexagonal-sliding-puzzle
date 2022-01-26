import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexagonal_sliding_puzzle/colors/colors.dart';
import 'package:hexagonal_sliding_puzzle/layout/layout.dart';
import 'package:hexagonal_sliding_puzzle/theme/themes/themes.dart';

/// {@template simple_theme}
/// The simple puzzle theme.
/// {@endtemplate}
class SimpleTheme extends PuzzleTheme {
  /// {@macro simple_theme}
  const SimpleTheme() : super();

  @override
  String get name => 'Simple';

  @override
  int get size => 7;

  @override
  bool get hasTimer => false;

  @override
  bool get hasCountdown => false;

  @override
  Color get backgroundColor => PuzzleColors.white;

  @override
  Color get defaultColor => PuzzleColors.primary5;

  @override
  Color get correctTileColor => Colors.green;

  @override
  Color get hoverColor => PuzzleColors.primary3;

  @override
  Color get pressedColor => PuzzleColors.primary7;

  @override
  PuzzleLayoutDelegate get layoutDelegate => const SimplePuzzleLayoutDelegate();

  @override
  List<Object?> get props => [
        name,
        hasTimer,
        hasCountdown,
        backgroundColor,
        defaultColor,
        hoverColor,
        pressedColor,
        layoutDelegate,
        menuActiveColor,
        menuInactiveColor,
        menuUnderlineColor
      ];

  @override
  Color get menuActiveColor => Colors.orange;

  @override
  Color get menuInactiveColor => Colors.orange;

  @override
  String get successThemeAsset => '';

  @override
  Color get menuUnderlineColor => Colors.orange;
}
