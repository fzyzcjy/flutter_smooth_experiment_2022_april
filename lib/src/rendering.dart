import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smooth_render/src/misc.dart';

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
      // TODO no need?
      // child: LayoutBuilder(
      //   builder: (context, _) => builder(context),
      // ),
      placeholder: placeholder,
      child: builder(context),
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
  const _SmootherRaw({
    Key? key,
    required this.placeholder,
    Widget? child,
  }) : super(key: key, child: child);

  final SmootherPlaceholder placeholder;

  @override
  _RenderSmootherRaw createRenderObject(BuildContext context) {
    return _RenderSmootherRaw(
      placeholder: placeholder,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSmootherRaw renderObject) {
    // ignore: avoid_single_cascade_in_expression_statements
    renderObject //
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
    RenderBox? child,
  })  : _placeholder = placeholder,
        super(child);

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
    logger('hi performLayout start');
    super.performLayout();
    logger('hi performLayout end');
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
