import 'package:flutter/material.dart';
import 'package:hexagonal_sliding_puzzle/cmp/grid/hexagon_path_builder.dart';

///class of Hexagon Clipper
class HexagonClipper extends CustomClipper<Path> {
  ///ctor
  HexagonClipper(this.pathBuilder);

  ///pathBuilder
  final HexagonPathBuilder pathBuilder;

  @override
  Path getClip(Size size) {
    return pathBuilder.build(size);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    if (oldClipper is HexagonClipper) {
      return oldClipper.pathBuilder != pathBuilder;
    }
    return true;
  }
}
