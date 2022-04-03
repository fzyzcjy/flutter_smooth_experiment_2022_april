import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Smoother extends StatelessWidget {
  final SmootherPlaceholder placeholder;
  final WidgetBuilder builder;

  const Smoother({
    Key? key,
    this.placeholder = const SmootherPlaceholder(),
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SmootherRaw(
      // NOTE try to use [LayoutBuilder] to merge "build" phase into "layout" phase
      // TODO ok?
      child: LayoutBuilder(
        builder: (context, _) => builder(context),
      ),
    );
  }

  @override
  // ignore: unnecessary_overrides
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // TODO some info
  }
}

@immutable
class SmootherPlaceholder {
  final Size size;
  final Color color;

  const SmootherPlaceholder({
    this.size = const Size(20, 20),
    this.color = Colors.transparent,
  });
}

class _SmootherRaw extends SingleChildRenderObjectWidget {
  const _SmootherRaw({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  _RenderSmootherRaw createRenderObject(BuildContext context) {
    return _RenderSmootherRaw();
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSmootherRaw renderObject) {
    // nothing yet
  }

  @override
  // ignore: unnecessary_overrides
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // TODO some info
  }
}

class _RenderSmootherRaw extends RenderProxyBox {
  _RenderSmootherRaw({
    RenderBox? child,
  }) : super(child);

  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    // TODO
    super.layout(constraints, parentUsesSize: parentUsesSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // TODO
    super.paint(context, offset);
  }

  @override
  // ignore: unnecessary_overrides
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // TODO some info
  }
}
