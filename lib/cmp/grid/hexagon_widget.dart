library hexagon;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hexagonal_sliding_puzzle/cmp/grid/hexagon_clipper.dart';
import 'package:hexagonal_sliding_puzzle/cmp/grid/hexagon_painter.dart';
import 'package:hexagonal_sliding_puzzle/cmp/grid/hexagon_path_builder.dart';
import 'package:hexagonal_sliding_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:provider/src/provider.dart';
import 'hexagon_type.dart';

class HexagonWidget extends StatefulWidget {
  /// Preferably provide one dimension ([width] or [height]) and the other will be calculated accordingly to hexagon aspect ratio
  ///
  /// [elevation] - Mustn't be negative. Default = 0
  ///
  /// [padding] - Mustn't be negative.
  ///
  /// [color] - Color used to fill hexagon. Use transparency with 0 elevation
  ///
  /// [cornerRadius] - Radius of hexagon corners. Values <= 0 have no effect.
  ///
  /// [inBounds] - Set to false if you want to overlap hexagon corners outside it's space.
  ///
  /// [child] - You content. Keep in mind that it will be clipped.
  ///
  /// [type] - A type of hexagon has to be either [HexagonType.FLAT] or [HexagonType.POINTY]
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
  })  : assert(width != null || height != null),
        assert(elevation >= 0),
        super(key: key);

  /// Preferably provide one dimension ([width] or [height]) and the other will be calculated accordingly to hexagon aspect ratio
  ///
  /// [elevation] - Mustn't be negative. Default = 0
  ///
  /// [padding] - Mustn't be negative.
  ///
  /// [color] - Color used to fill hexagon. Use transparency with 0 elevation
  ///
  /// [cornerRadius] - Border radius of hexagon corners. Values <= 0 have no effect.
  ///
  /// [inBounds] - Set to false if you want to overlap hexagon corners outside it's space.
  ///
  /// [child] - You content. Keep in mind that it will be clipped.
  HexagonWidget.flat({
    Key? key,
    this.width,
    this.height,
    this.color,
    this.child,
    this.padding = 0.0,
    this.elevation = 0,
    this.cornerRadius = 0.0,
    this.inBounds = true,
  })  : assert(width != null || height != null),
        assert(elevation >= 0),
        this.type = HexagonType.FLAT,
        super(key: key);

  /// Preferably provide one dimension ([width] or [height]) and the other will be calculated accordingly to hexagon aspect ratio
  ///
  /// [elevation] - Mustn't be negative. Default = 0
  ///
  /// [padding] - Mustn't be negative.
  ///
  /// [color] - Color used to fill hexagon. Use transparency with 0 elevation
  ///
  /// [cornerRadius] - Border radius of hexagon corners. Values <= 0 have no effect.
  ///
  /// [inBounds] - Set to false if you want to overlap hexagon corners outside it's space.
  ///
  /// [child] - You content. Keep in mind that it will be clipped.
  HexagonWidget.pointy({
    Key? key,
    this.width,
    this.height,
    this.color,
    this.child,
    this.padding = 0.0,
    this.elevation = 0,
    this.cornerRadius = 0.0,
    this.inBounds = true,
  })  : assert(width != null || height != null),
        assert(elevation >= 0),
        this.type = HexagonType.POINTY,
        super(key: key);

  final HexagonType type;
  final double? width;
  final double? height;
  final double elevation;
  final bool inBounds;
  final Widget? child;
  final Color? color;
  final double padding;
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
          milliseconds:
              200), // TODO(CCL):scaleTIle PuzzleThemeAnimationDuration.puzzleTileScale,
    );

    _scale = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );
  }

  Size _innerSize() {
    var flatFactor = widget.type.flatFactor(widget.inBounds);
    var pointyFactor = widget.type.pointyFactor(widget.inBounds);

    if (widget.height != null && widget.width != null)
      return Size(widget.width!, widget.height!);
    if (widget.height != null)
      return Size(
          (widget.height! * widget.type.ratio) * flatFactor / pointyFactor,
          widget.height!);
    if (widget.width != null)
      return Size(widget.width!,
          (widget.width! / widget.type.ratio) / flatFactor * pointyFactor);
    return Size.zero; //dead path
  }

  Size _contentSize() {
    var flatFactor = widget.type.flatFactor(widget.inBounds);
    var pointyFactor = widget.type.pointyFactor(widget.inBounds);

    if (widget.height != null && widget.width != null)
      return Size(widget.width!, widget.height!);
    if (widget.height != null)
      return Size((widget.height! * widget.type.ratio) / pointyFactor,
          widget.height! / pointyFactor);
    if (widget.width != null)
      return Size(widget.width! / flatFactor,
          (widget.width! / widget.type.ratio) / flatFactor);
    return Size.zero; //dead path
  }

  @override
  Widget build(BuildContext context) {
    var innerSize = _innerSize();
    var contentSize = _contentSize();

    final puzzleIncomplete =
        context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus) ==
            PuzzleStatus.incomplete;

    final canPress = /*hasStarted && */ puzzleIncomplete;

    HexagonPathBuilder pathBuilder = HexagonPathBuilder(widget.type,
        inBounds: widget.inBounds, borderRadius: widget.cornerRadius);
//TODO(CCL):modif size ici
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
                  alignment: Alignment.center,
                  maxHeight: contentSize.height *
                      2, //TODO(CCL): augmentation de la hauteur du overflow
                  maxWidth: contentSize.width,
                  child: Container(
                    //color: Colors.orange,
                    child: Align(
                      alignment: Alignment.center,
                      child: widget.child,
                    ),
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

class HexagonWidgetBuilder {
  final Key? key;
  final double? elevation;
  final Color? color;
  final double? padding;
  final double? cornerRadius;
  final Widget? child;

  HexagonWidgetBuilder({
    this.key,
    this.elevation,
    this.color,
    this.padding,
    this.cornerRadius,
    this.child,
  });

  HexagonWidgetBuilder.transparent({
    this.key,
    this.padding,
    this.cornerRadius,
    this.child,
  })  : this.elevation = 0,
        this.color = Colors.transparent;

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
      child: replaceChild ? child : this.child,
      color: color,
      padding: padding ?? 0.0,
      cornerRadius: cornerRadius ?? 0.0,
      elevation: elevation ?? 0,
    );
  }
}
