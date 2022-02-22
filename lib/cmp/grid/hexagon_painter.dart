import 'package:flutter/material.dart';
import 'package:hexagonal_sliding_puzzle/cmp/grid/hexagon_path_builder.dart';

/// This class is responsible for painting HexagonWidget color
///  and shadow in proper shape.
class HexagonPainter extends CustomPainter {
  ///ctor
  HexagonPainter(this.pathBuilder, {this.color, this.elevation = 0});

  ///pathBuilder of HexagonPainter
  final HexagonPathBuilder pathBuilder;

  ///elevation of HexagonPainter
  final double elevation;

  ///color of HexagonPainter
  final Color? color;

  final Paint _paint = Paint();
  Path? _path;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = color ?? Colors.white;
    //_paint.isAntiAlias = true;
    //_paint.style = PaintingStyle.fill;

    final path = pathBuilder.build(size);
    _path = path;

    if (elevation > 0) {
      canvas.drawShadow(path, Colors.black, elevation, false);
    }
    canvas.drawPath(path, _paint);
  }

  @override
  bool hitTest(Offset position) {
    return _path?.contains(position) ?? false;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HexagonPainter &&
          runtimeType == other.runtimeType &&
          pathBuilder == other.pathBuilder &&
          elevation == other.elevation &&
          color == other.color;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode =>
      pathBuilder.hashCode ^ elevation.hashCode ^ color.hashCode;
}
