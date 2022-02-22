
import 'package:flutter/material.dart';
import 'package:hexagonal_sliding_puzzle/layout/layout.dart';
import 'package:hexagonal_sliding_puzzle/theme/themes/themes.dart';

/// {@template simple_theme}
/// The simple puzzle theme.
/// {@endtemplate}
class HexagonalThemeEasy extends PuzzleTheme {
  /// {@macro simple_theme}
  const HexagonalThemeEasy() : super();

  @override
  String get name => 'Easy';

  @override
  int get size => 5;

  @override
  int get baseScore => 1000;

  @override
  bool get hasTimer => true;

  @override
  bool get hasCountdown => false;

  @override
  Color get backgroundColor => Colors.teal.shade400;

  @override
  Color get defaultColor => const Color(0xFF00504C);

  @override
  Color get correctTileColor => Colors.lightGreen.shade700;

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
      'assets/images/success/success_rotate_easy.png';

  @override
  Color get menuUnderlineColor => defaultColor;
}
