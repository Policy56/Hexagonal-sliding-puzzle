import 'package:flutter/cupertino.dart';

/// classs of ShimmerWidget
class ShimmerWidget extends StatefulWidget {
  ///ctor
  const ShimmerWidget({
    Key? key,
    required this.linearGradient,
    this.child,
  }) : super(key: key);

  /// LinerGradient of Shimmerwidger
  final LinearGradient linearGradient; // = _shimmerGradient;
  ///Child
  final Widget? child;

  /// return state of ShimmerWidget
  static ShimmerWidgetState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerWidgetState>();
  }

  @override
  ShimmerWidgetState createState() => ShimmerWidgetState();
}

///State : en public car use in shimmer_loading to call changes
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

  ///getter of gradient
  LinearGradient get gradient => LinearGradient(
        colors: widget.linearGradient.colors,
        stops: widget.linearGradient.stops,
        begin: widget.linearGradient.begin,
        end: widget.linearGradient.end,
        transform:
            _SlidingGradientTransform(slidePercent: _shimmerController.value),
      );

////Getter isSider renderbox
  bool get isSized => (context.findRenderObject()! as RenderBox).hasSize;

  ///getter of size
  Size get size => (context.findRenderObject()! as RenderBox).size;

  ///Return getDescendantOffset
  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject()! as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  ///Listenable if shimmer changes !
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
