import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexagonal_sliding_puzzle/colors/colors.dart';
import 'package:hexagonal_sliding_puzzle/layout/layout.dart';
import 'package:hexagonal_sliding_puzzle/theme/themes/themes.dart';

/// {@template simple_theme}
/// The simple puzzle theme.
/// {@endtemplate}
class HexagonalThemeMedium extends PuzzleTheme {
  /// {@macro simple_theme}
  const HexagonalThemeMedium() : super();

  @override
  String get name => 'Medium';

  @override
  int get size => 7;

  @override
  int get baseScore => 5000;

  @override
  bool get hasTimer => true;

  @override
  bool get hasCountdown => false;

  @override
  Color get backgroundColor => Colors.yellow.shade800;

  @override
  Color get defaultColor => Colors.yellow.shade900;

  @override
  Color get correctTileColor => Colors.green;

  @override
  Color get hoverColor => darker(defaultColor, 20);

  @override
  Color get pressedColor => lighter(defaultColor, 20);

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
  Color get menuActiveColor => darker(defaultColor, 30);

  @override
  Color get menuInactiveColor => defaultColor;

  @override
  String get successThemeAsset =>
      'assets/images/success/success_rotate_medium.png';

  @override
  Color get menuUnderlineColor => defaultColor;
}

/// Darken a color by [percent] amount (100 = black)
// ........................................................
Color darker(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round());
}

/// Lighten a color by [percent] amount (100 = white)
// ........................................................
Color lighter(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var p = percent / 100;
  return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round());
}
