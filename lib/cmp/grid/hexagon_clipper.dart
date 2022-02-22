
import 'package:flutter/material.dart';
import 'package:hexagonal_sliding_puzzle/cmp/grid/hexagon_path_builder.dart';

class HexagonClipper extends CustomClipper<Path> {
  HexagonClipper(this.pathBuilder);

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
