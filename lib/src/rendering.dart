import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smooth_render/src/facade.dart';
import 'package:flutter_smooth_render/src/misc.dart';

/// Put this as high as possible in the tree
class SmootherParent extends StatelessWidget {
  final Widget child;

  const SmootherParent({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        const SmootherParentLastChild(),
      ],
    );
  }
}

class SmootherParentLastChild extends StatefulWidget {
  const SmootherParentLastChild({Key? key}) : super(key: key);

  @override
  SmootherParentLastChildState createState() => SmootherParentLastChildState();
}

class SmootherParentLastChildState extends State<SmootherParentLastChild> {
  @override
  void initState() {
    super.initState();

    assert(SmootherFacade.instance.smootherParentLastChild == null);
    SmootherFacade.instance.smootherParentLastChild = this;
  }

  @override
  void dispose() {
    assert(SmootherFacade.instance.smootherParentLastChild == this);
    SmootherFacade.instance.smootherParentLastChild = null;

    super.dispose();
  }

  void markNeedsBuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, __) {
      // If this callback is called, then the whole subtree should have been [layout]ed successfully
      // Thus, we can deal with some old work
      logger('SmootherParentLastChild call workQueue.executeMany');
      SmootherFacade.instance.workQueue.executeMany();

      return const SizedBox.shrink();
    });
  }
}

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
    return SmootherRaw(
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

class SmootherRaw extends SingleChildRenderObjectWidget {
  final String debugName;
  final SmootherPlaceholder placeholder;

  const SmootherRaw({
    Key? key,
    required this.debugName,
    required this.placeholder,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  RenderSmootherRaw createRenderObject(BuildContext context) {
    return RenderSmootherRaw(
      debugName: debugName,
      placeholder: placeholder,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderSmootherRaw renderObject) {
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

class RenderSmootherRaw extends RenderProxyBox {
  RenderSmootherRaw({
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

  var disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  var _hasSkippedChildLayout = false;
  var _hasSucceededLayout = false;

  @override
  void performLayout() {
    // final lastFrameStart = SmootherBindingInfo.instance.lastFrameStart ?? DateTime.now();
    // logger(
    //     '[$debugName] performLayout start elapsed=${DateTime.now().difference(lastFrameStart)} lastFrameStart=$lastFrameStart');

    if (SmootherFacade.instance.scheduler.shouldExecute()) {
      logger('[$debugName] performLayout execute');

      super.performLayout();
      _hasSkippedChildLayout = false;
      _hasSucceededLayout = true;
    } else {
      logger('[$debugName] performLayout skip');

      size = constraints.constrain(placeholder.size);
      _hasSkippedChildLayout = true;
      SmootherFacade.instance.workQueue.add(_onWorkQueueExecute);

      // TODO redo the work in the next frame
    }

    // logger(
    //     '[$debugName] performLayout end elapsed=${DateTime.now().difference(lastFrameStart)} lastFrameStart=$lastFrameStart');
  }

  void _onWorkQueueExecute() {
    if (!disposed) {
      markNeedsLayout();
    }
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    // according to comments of [visitChildrenForSemantics], it should "skip all
    // children that are not semantically relevant (e.g. because they are invisible)".
    // Thus, when the child does not have up-to-date [layout], we should not visit it.
    if (!_hasSkippedChildLayout) super.visitChildrenForSemantics(visitor);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_hasSucceededLayout) {
      super.paint(context, offset);
    } else {
      context.canvas.drawRect(offset & size, Paint()..color = placeholder.color);
    }
  }

  @override
  // ignore: unnecessary_overrides
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // TODO some info
  }
}
