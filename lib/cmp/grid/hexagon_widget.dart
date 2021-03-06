library hexagon;

import 'package:flutter/material.dart';
import 'package:hexagonal_sliding_puzzle/cmp/grid/hexagon_clipper.dart';
import 'package:hexagonal_sliding_puzzle/cmp/grid/hexagon_painter.dart';
import 'package:hexagonal_sliding_puzzle/cmp/grid/hexagon_path_builder.dart';
import 'package:hexagonal_sliding_puzzle/cmp/grid/hexagon_type.dart';
import 'package:hexagonal_sliding_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:provider/src/provider.dart';

///Class of HexagonWidget
class HexagonWidget extends StatefulWidget {
  /// Preferably provide one dimension ([width] or [height])
  /// and the other will be calculated accordingly to hexagon aspect ratio
  ///
  /// [elevation] - Mustn't be negative. Default = 0
  ///
  /// [padding] - Mustn't be negative.
  ///
  /// [color] - Color used to fill hexagon. Use transparency with 0 elevation
  ///
  /// [cornerRadius] - Radius of hexagon corners. Values <= 0 have no effect.
  ///
  /// [inBounds] - Set to false if you want to overlap
  ///  hexagon corners outside it's space.
  ///
  /// [child] - You content. Keep in mind that it will be clipped.
  ///
  /// [type] - A type of hexagon has to be either
  ///  [HexagonType.flat] or [HexagonType.pointy]
  const HexagonWidget({
    Key? key,
    this.width,
    this.height,
    this.color,
    this.child,
    this.padding = 0.0,
    this.cornerRadius = 0.0,
    this.elevation = 0,
    this.inBounds = true,
    required this.type,
  })  : assert(
          width != null || height != null,
          'need width != null && height != null',
        ),
        assert(elevation >= 0, 'need elevation >=0'),
        super(key: key);

  /// Preferably provide one dimension ([width] or [height]) and the
  ///  other will be calculated accordingly to hexagon aspect ratio
  ///
  /// [elevation] - Mustn't be negative. Default = 0
  ///
  /// [padding] - Mustn't be negative.
  ///
  /// [color] - Color used to fill hexagon. Use transparency with 0 elevation
  ///
  /// [cornerRadius] - Border radius of hexagon corners.
  ///  Values <= 0 have no effect.
  ///
  /// [inBounds] - Set to false if you want to overlap hexagon
  ///  corners outside it's space.
  ///
  /// [child] - You content. Keep in mind that it will be clipped.
  const HexagonWidget.flat({
    Key? key,
    this.width,
    this.height,
    this.color,
    this.child,
    this.padding = 0.0,
    this.elevation = 0,
    this.cornerRadius = 0.0,
    this.inBounds = true,
  })  : assert(
          width != null || height != null,
          'need width != null && height != null',
        ),
        assert(elevation >= 0, 'need elevation >=0'),
        type = HexagonType.flat,
        super(key: key);

  /// Preferably provide one dimension ([width] or [height]) and
  ///  the other will be calculated accordingly to hexagon aspect ratio
  ///
  /// [elevation] - Mustn't be negative. Default = 0
  ///
  /// [padding] - Mustn't be negative.
  ///
  /// [color] - Color used to fill hexagon. Use transparency with 0 elevation
  ///
  /// [cornerRadius] - Border radius of hexagon corners.
  ///  Values <= 0 have no effect.
  ///
  /// [inBounds] - Set to false if you want to overlap hexagon
  /// corners outside it's space.
  ///
  /// [child] - You content. Keep in mind that it will be clipped.
  const HexagonWidget.pointy({
    Key? key,
    this.width,
    this.height,
    this.color,
    this.child,
    this.padding = 0.0,
    this.elevation = 0,
    this.cornerRadius = 0.0,
    this.inBounds = true,
  })  : assert(
          width != null || height != null,
          'need width != null && height != null',
        ),
        assert(elevation >= 0, 'need elevation >=0'),
        type = HexagonType.pointy,
        super(key: key);

  ///type of HexagonWidget
  final HexagonType type;

  ///width of HexagonWidget
  final double? width;

  ///height of HexagonWidget
  final double? height;

  ///elevation of HexagonWidget
  final double elevation;

  ///inbounds of HexagonWidget
  final bool inBounds;

  ///child of HexagonWidget
  final Widget? child;

  ///color of HexagonWidget
  final Color? color;

  ///padding of HexagonWidget
  final double padding;

  ///radius corner of HexagonWidget
  final double cornerRadius;

  @override
  State<HexagonWidget> createState() => _HexagonWidgetState();
}

class _HexagonWidgetState extends State<HexagonWidget>
    with SingleTickerProviderStateMixin {
  /// The controller that drives [_scale] animation.
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
    );

    _scale = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );
  }

  Size _innerSize() {
    final flatFactor = widget.type.flatFactor(widget.inBounds);
    final pointyFactor = widget.type.pointyFactor(widget.inBounds);

    if (widget.height != null && widget.width != null) {
      return Size(widget.width!, widget.height!);
    }
    if (widget.height != null) {
      return Size(
        (widget.height! * widget.type.ratio) * flatFactor / pointyFactor,
        widget.height!,
      );
    }
    if (widget.width != null) {
      return Size(
        widget.width!,
        (widget.width! / widget.type.ratio) / flatFactor * pointyFactor,
      );
    }
    return Size.zero; //dead path
  }

  Size _contentSize() {
    final flatFactor = widget.type.flatFactor(widget.inBounds);
    final pointyFactor = widget.type.pointyFactor(widget.inBounds);

    if (widget.height != null && widget.width != null) {
      return Size(widget.width!, widget.height!);
    }
    if (widget.height != null) {
      return Size(
        (widget.height! * widget.type.ratio) / pointyFactor,
        widget.height! / pointyFactor,
      );
    }
    if (widget.width != null) {
      return Size(
        widget.width! / flatFactor,
        (widget.width! / widget.type.ratio) / flatFactor,
      );
    }
    return Size.zero; //dead path
  }

  @override
  Widget build(BuildContext context) {
    final innerSize = _innerSize();
    final contentSize = _contentSize();

    final puzzleIncomplete =
        context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus) ==
            PuzzleStatus.incomplete;

    final canPress = /*hasStarted && */ puzzleIncomplete;

    final pathBuilder = HexagonPathBuilder(
      widget.type,
      inBounds: widget.inBounds,
      borderRadius: widget.cornerRadius,
    );

    return AnimatedAlign(
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: MouseRegion(
        onEnter: (_) {
          if (canPress) {
            _controller.forward();
          }
        },
        onExit: (_) {
          if (canPress) {
            _controller.reverse();
          }
        },
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            padding: EdgeInsets.all(widget.padding),
            width: innerSize.width,
            height: innerSize.height,
            child: CustomPaint(
              painter: HexagonPainter(
                pathBuilder,
                color: widget.color,
                elevation: widget.elevation,
              ),
              child: ClipPath(
                clipper: HexagonClipper(pathBuilder),
                child: OverflowBox(
                  maxHeight: contentSize.height * 2,
                  maxWidth: contentSize.width,
                  child: //Container(
                      //color: Colors.orange,
                      /*child:*/ Align(
                    child: widget.child,
                    //),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// class of HexagonWidgetBuilder
class HexagonWidgetBuilder {
  ///ctor
  HexagonWidgetBuilder({
    this.key,
    this.elevation,
    this.color,
    this.padding,
    this.cornerRadius,
    this.child,
  });

  /// ctor tranparent
  HexagonWidgetBuilder.transparent({
    this.key,
    this.padding,
    this.cornerRadius,
    this.child,
  })  : elevation = 0,
        color = Colors.transparent;

  ///key of HexagonWidgetBuilder
  final Key? key;

  ///elevation of HexagonWidgetBuilder
  final double? elevation;

  ///color of HexagonWidgetBuilder
  final Color? color;

  ///padding of HexagonWidgetBuilder
  final double? padding;

  ///cordner Radius of HexagonWidgetBuilder
  final double? cornerRadius;

  ///child of HexagonWidgetBuilder
  final Widget? child;

  ///Builder of HexagonWidget
  HexagonWidget build({
    required HexagonType type,
    required bool inBounds,
    double? width,
    double? height,
    Widget? child,
    bool replaceChild = false,
  }) {
    return HexagonWidget(
      key: key,
      type: type,
      inBounds: inBounds,
      width: width,
      height: height,
      color: color,
      padding: padding ?? 0.0,
      cornerRadius: cornerRadius ?? 0.0,
      elevation: elevation ?? 0,
      child: replaceChild ? child : this.child,
    );
  }
}
