import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexagonal_sliding_puzzle/colors/colors.dart';
import 'package:hexagonal_sliding_puzzle/layout/layout.dart';
import 'package:hexagonal_sliding_puzzle/theme/themes/themes.dart';

/// {@template simple_theme}
/// The simple puzzle theme.
/// {@endtemplate}
class HexagonalThemeHard extends PuzzleTheme {
  /// {@macro simple_theme}
  const HexagonalThemeHard() : super();

  @override
  String get name => 'Hard';

  @override
  bool get hasTimer => false;

  @override
  bool get hasCountdown => false;

  @override
  Color get backgroundColor => Colors.grey.shade800;

  @override
  Color get defaultColor => Colors.red.shade700;

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
  Color get menuActiveColor => lighter(defaultColor, 30);
  @override
  Color get menuInactiveColor => defaultColor;

  @override
  Color get menuUnderlineColor => defaultColor;
}
