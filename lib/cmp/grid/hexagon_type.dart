import 'dart:math';

///Enum for hexagon "orientation".
enum HexagonType {
  ///flat Hexagon
  flat,

  /// pointy Hexagon
  pointy
}

/// extension of
extension HexagonTypeExtension on HexagonType {
  static final double _ratioPointy = sqrt(3) / 2;
  static final double _ratioFlat = 1 / _ratioPointy;

  /// Hexagon width to height ratio
  double get ratio {
    if (isFlat) return _ratioFlat;
    return _ratioPointy;
  }

  /// Returns true for POINTY;
  bool get isPointy => this == HexagonType.pointy;

  /// Returns true for FLAT;
  bool get isFlat => this == HexagonType.flat;

  /// flat factor
  // ignore: avoid_positional_boolean_parameters
  double flatFactor(bool inBounds) => (isFlat && inBounds == false) ? 0.75 : 1;

  /// pointy factor
  // ignore: avoid_positional_boolean_parameters
  double pointyFactor(bool inBounds) =>
      (isPointy && inBounds == false) ? 0.75 : 1;
}
