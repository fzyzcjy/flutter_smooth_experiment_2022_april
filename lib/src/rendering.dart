import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smooth_render/src/misc.dart';

class Smoother extends StatelessWidget {
  final String debugName;
  final SmootherPlaceholder placeholder;
  final Widget child;

  const Smoother({
    Key? key,
    this.debugName = '',
    this.placeholder = const SmootherPlaceholder(),
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SmootherRaw(
      debugName: debugName,
      placeholder: placeholder,
      // NOTE use [LayoutBuilder], such that the [initState]/[didUpdateWidget] of the subtree is called inside
      // [_RenderSmootherRaw]'s [performLayout]
      child: LayoutBuilder(
        builder: (context, _) => child,
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

  @override
  String toString() => 'SmootherPlaceholder{size: $size, color: $color}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmootherPlaceholder && runtimeType == other.runtimeType && size == other.size && color == other.color;

  @override
  int get hashCode => size.hashCode ^ color.hashCode;
}

class _SmootherRaw extends SingleChildRenderObjectWidget {
  final String debugName;
  final SmootherPlaceholder placeholder;

  const _SmootherRaw({
    Key? key,
    required this.debugName,
    required this.placeholder,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  _RenderSmootherRaw createRenderObject(BuildContext context) {
    return _RenderSmootherRaw(
      debugName: debugName,
      placeholder: placeholder,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSmootherRaw renderObject) {
    // ignore: avoid_single_cascade_in_expression_statements
    renderObject //
      ..debugName = debugName
      ..placeholder = placeholder;
  }

  @override
  // ignore: unnecessary_overrides
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('placeholder', placeholder));
  }
}

class _RenderSmootherRaw extends RenderProxyBox {
  _RenderSmootherRaw({
    required SmootherPlaceholder placeholder,
    required this.debugName,
    RenderBox? child,
  })  : _placeholder = placeholder,
        super(child);

  String debugName;

  SmootherPlaceholder get placeholder => _placeholder;
  SmootherPlaceholder _placeholder;

  set placeholder(SmootherPlaceholder value) {
    if (_placeholder == value) {
      return;
    }

    if (_placeholder.size != value.size) {
      markNeedsLayout();
    }

    _placeholder = value;
  }

  @override
  void performLayout() {
    // final lastFrameStart = SmootherBindingInfo.instance.lastFrameStart ?? DateTime.now();
    // logger(
    //     '[$debugName] performLayout start elapsed=${DateTime.now().difference(lastFrameStart)} lastFrameStart=$lastFrameStart');

    if (SmootherScheduler.instance.shouldStartPieceOfWork()) {
      super.performLayout();
    } else {
      logger('[$debugName] performLayout skip');

      size = constraints.constrain(placeholder.size);

      // TODO redo the work in the next frame
    }

    // logger(
    //     '[$debugName] performLayout end elapsed=${DateTime.now().difference(lastFrameStart)} lastFrameStart=$lastFrameStart');
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
