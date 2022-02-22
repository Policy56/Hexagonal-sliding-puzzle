import 'package:flutter/cupertino.dart';

class ShimmerWidget extends StatefulWidget {
  static ShimmerWidgetState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerWidgetState>();
  }

  const ShimmerWidget({
    Key? key,
    required this.linearGradient,
    this.child,
  }) : super(key: key);

  final LinearGradient linearGradient; // = _shimmerGradient;
  final Widget? child;

  @override
  ShimmerWidgetState createState() => ShimmerWidgetState();
}

class ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  LinearGradient get gradient => LinearGradient(
        colors: widget.linearGradient.colors,
        stops: widget.linearGradient.stops,
        begin: widget.linearGradient.begin,
        end: widget.linearGradient.end,
        transform:
            _SlidingGradientTransform(slidePercent: _shimmerController.value),
      );

  bool get isSized => (context.findRenderObject() as RenderBox).hasSize;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  Listenable get shimmerChanges => _shimmerController;

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}
