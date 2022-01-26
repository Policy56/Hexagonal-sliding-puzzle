import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hexagonal_sliding_puzzle/layout/layout.dart';

/// {@template puzzle_theme}
/// Template for creating custom puzzle UI.
/// {@endtemplate}
abstract class PuzzleTheme extends Equatable {
  /// {@macro puzzle_theme}
  const PuzzleTheme();

  /// The display name of this theme.
  String get name;

  /// Size of the Puzzle
  int get size;

  /// Whether this theme displays the puzzle timer.
  bool get hasTimer;

  /// Whether this theme displays the countdown
  /// from 3 to 0 seconds when the puzzle is started.
  bool get hasCountdown;

  /// The background color of this theme.
  Color get backgroundColor;

  /// The default color of this theme.
  ///
  /// Used for puzzle tiles and buttons.
  Color get defaultColor;

  /// The default color of this theme.
  ///
  /// Used for puzzle tiles and buttons.
  Color get correctTileColor;

  /// The hover color of this theme.
  ///
  /// Used for the puzzle tile that was hovered over.
  Color get hoverColor;

  /// The pressed color of this theme.
  ///
  /// Used for the puzzle tile that was pressed.
  Color get pressedColor;

  /// The active menu color.
  ///
  /// Applied to the text color of the currently active
  /// theme in menu.
  Color get menuActiveColor;

  /// The underline menu color.
  ///
  /// Applied to the underline of the currently active
  /// theme in menu, on a small layout.
  Color get menuUnderlineColor;

  /// The inactive menu color.
  ///
  /// Applied to the text color of the currently inactive
  /// theme in menu.
  Color get menuInactiveColor;

  /// The path to the success image asset of this theme.
  ///
  /// This asset is shown in the success state of the puzzle.
  String get successThemeAsset;

  /// The puzzle layout delegate of this theme.
  ///
  /// Used for building sections of the puzzle UI.
  PuzzleLayoutDelegate get layoutDelegate;
}
