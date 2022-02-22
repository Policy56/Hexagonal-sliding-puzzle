import 'dart:math';
import 'dart:ui';

import 'package:hexagonal_sliding_puzzle/cmp/grid/hexagon_type.dart';

/// class of HexagonPathBuilder
class HexagonPathBuilder {
  ///ctor of HexagonPathBuilder
  HexagonPathBuilder(this.type, {this.inBounds = true, this.borderRadius = 0})
      : assert(borderRadius >= 0, 'Border radius need to be >= 0');

  /// type of Hexagon
  final HexagonType type;

  ///inbounds
  final bool inBounds;

  ///Borderradius
  final double borderRadius;

  /// Builds hexagon shaped path in given size.
  Path build(Size size) => _hexagonPath(size);

  Point<double> _flatHexagonCorner(Offset center, double size, int i) {
    final angleDeg = 60 * i;
    final angleRad = pi / 180 * angleDeg;
    return Point(
      center.dx + size * cos(angleRad),
      center.dy + size * sin(angleRad),
    );
  }

  Point<double> _pointyHexagonCorner(Offset center, double size, int i) {
    final angleDeg = 60 * i - 30;
    final angleRad = pi / 180 * angleDeg;
    return Point(
      center.dx + size * cos(angleRad),
      center.dy + size * sin(angleRad),
    );
  }

  /// Calculates hexagon corners for given size and center.
  List<Point<double>> _flatHexagonCornerList(Offset center, double size) =>
      List<Point<double>>.generate(
        6,
        (index) => _flatHexagonCorner(center, size, index),
        growable: false,
      );

  /// Calculates hexagon corners for given size and center.
  List<Point<double>> _pointyHexagonCornerList(Offset center, double size) =>
      List<Point<double>>.generate(
        6,
        (index) => _pointyHexagonCorner(center, size, index),
        growable: false,
      );

  Point<double> _pointBetween(
    Point<double> start,
    Point<double> end, {
    double? distance,
    double? pFraction,
  }) {
    final xLength = end.x - start.x;
    final yLength = end.y - start.y;
    var fraction = pFraction;
    if (fraction == null) {
      if (distance == null) {
        throw Exception('Distance or fraction should be specified.');
      }
      final length = sqrt(xLength * xLength + yLength * yLength);
      fraction = distance / length;
    }
    return Point(start.x + xLength * fraction, start.y + yLength * fraction);
  }

  Point<double> _radiusStart(
    Point<double> corner,
    int index,
    List<Point<double>> cornerList,
    double radius,
  ) {
    final prevCorner =
        index > 0 ? cornerList[index - 1] : cornerList[cornerList.length - 1];
    final distance = radius * tan(pi / 6);
    return _pointBetween(corner, prevCorner, distance: distance);
  }

  Point<double> _radiusEnd(
    Point<double> corner,
    int index,
    List<Point<double>> cornerList,
    double radius,
  ) {
    final nextCorner =
        index < cornerList.length - 1 ? cornerList[index + 1] : cornerList[0];
    final distance = radius * tan(pi / 6);
    return _pointBetween(corner, nextCorner, distance: distance);
  }

  /// Returns path in shape of hexagon.
  Path _hexagonPath(Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    List<Point<double>> cornerList;
    if (type == HexagonType.flat) {
      cornerList = _flatHexagonCornerList(
        center,
        size.width / type.flatFactor(inBounds) / 2,
      );
    } else {
      cornerList = _pointyHexagonCornerList(
        center,
        size.height / type.pointyFactor(inBounds) / 2,
      );
    }

    final path = Path();
    if (borderRadius > 0) {
      Point<double> rStart;
      Point<double> rEnd;
      cornerList.asMap().forEach((index, point) {
        rStart = _radiusStart(point, index, cornerList, borderRadius);
        rEnd = _radiusEnd(point, index, cornerList, borderRadius);
        if (index == 0) {
          path.moveTo(rStart.x, rStart.y);
        } else {
          path.lineTo(rStart.x, rStart.y);
        }
        // rough approximation of an circular arc for 120 deg angle.
        final control1 = _pointBetween(rStart, point, pFraction: 0.7698);
        final control2 = _pointBetween(rEnd, point, pFraction: 0.7698);
        path.cubicTo(
          control1.x,
          control1.y,
          control2.x,
          control2.y,
          rEnd.x,
          rEnd.y,
        );
      });
    } else {
      cornerList.asMap().forEach((index, point) {
        if (index == 0) {
          path.moveTo(point.x, point.y);
        } else {
          path.lineTo(point.x, point.y);
        }
      });
    }

    return path..close();
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HexagonPathBuilder &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          inBounds == other.inBounds &&
          borderRadius == other.borderRadius;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => type.hashCode ^ inBounds.hashCode ^ borderRadius.hashCode;
}
