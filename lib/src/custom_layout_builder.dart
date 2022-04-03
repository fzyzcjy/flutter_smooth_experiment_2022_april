// ignore_for_file: annotate_overrides

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smooth_render/flutter_smooth_render.dart';
import 'package:flutter_smooth_render/src/misc.dart';

class CustomLayoutBuilder extends LayoutBuilder {
  const CustomLayoutBuilder({
    Key? key,
    required LayoutWidgetBuilder builder,
  }) : super(key: key, builder: builder);

  @override
  RenderObject createRenderObject(BuildContext context) => CustomRenderLayoutBuilder();
}

mixin CustomRenderConstrainedLayoutBuilder<ConstraintType extends Constraints, ChildType extends RenderObject>
    on RenderObjectWithChildMixin<ChildType>
// NOTE MODIFIED add this "implements" to be compatible
    implements
        RenderConstrainedLayoutBuilder<ConstraintType, ChildType> {
  LayoutCallback<ConstraintType>? _callback;

  /// Change the layout callback.
  void updateCallback(LayoutCallback<ConstraintType>? value) {
    if (value == _callback) return;
    _callback = value;
    markNeedsLayout();
  }

  // ignore: unused_field
  bool _needsBuild = true;

  /// Marks this layout builder as needing to rebuild.
  ///
  /// The layout build rebuilds automatically when layout constraints change.
  /// However, we must also rebuild when the widget updates, e.g. after
  /// [State.setState], or [State.didChangeDependencies], even when the layout
  /// constraints remain unchanged.
  ///
  /// See also:
  ///
  ///  * [ConstrainedLayoutBuilder.builder], which is called during the rebuild.
  void markNeedsBuild() {
    // Do not call the callback directly. It must be called during the layout
    // phase, when parent constraints are available. Calling `markNeedsLayout`
    // will cause it to be called at the right time.
    _needsBuild = true;
    markNeedsLayout();
  }

  // The constraints that were passed to this class last time it was laid out.
  // These constraints are compared to the new constraints to determine whether
  // [ConstrainedLayoutBuilder.builder] needs to be called.
  // ignore: unused_field
  Constraints? _previousConstraints;

  /// Invoke the callback supplied via [updateCallback].
  ///
  /// Typically this results in [ConstrainedLayoutBuilder.builder] being called
  /// during layout.
  void rebuildIfNecessary() {
    assert(_callback != null);

    // TODO improve it - sometimes really not need to rebuild!
    // NOTE XXX MODIFIED originally "rebuildIfNecessary", and only rebuild if
    //      `_needsBuild || constraints != _previousConstraints`. However, in our case,
    //      we want it to rebuild even if constraints are not changed, as long as the
    //      parent [SmootherRaw] markNeedsLayout and want to rebuild whole subtree.
    // if (_needsBuild || constraints != _previousConstraints) {
    if (true) {
      _previousConstraints = constraints;
      _needsBuild = false;
      invokeLayoutCallback(_callback!);
    }
  }
}

/// NOTE MODIFIED copy and modified from Flutter's `_RenderLayoutBuilder`
class CustomRenderLayoutBuilder extends RenderBox
    with
        RenderObjectWithChildMixin<RenderBox>,
        CustomRenderConstrainedLayoutBuilder<BoxConstraints, RenderBox>,
        // NOTE MODIFIED add this mixin
        DisposeStatusRenderBoxMixin {
  @override
  double computeMinIntrinsicWidth(double height) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(debugCannotComputeDryLayout(
      reason: 'Calculating the dry layout would require running the layout callback '
          'speculatively, which might mutate the live render object tree.',
    ));
    return Size.zero;
  }

  @override
  void performLayout() {
    logger('CustomRenderLayoutBuilder performLayout start');

    final BoxConstraints constraints = this.constraints;
    rebuildIfNecessary();
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
    } else {
      size = constraints.biggest;
    }
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    if (child != null) return child!.getDistanceToActualBaseline(baseline);
    return super.computeDistanceToActualBaseline(baseline);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return child?.hitTest(result, position: position) ?? false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) context.paintChild(child!, offset);
  }

  bool _debugThrowIfNotCheckingIntrinsics() {
    assert(() {
      if (!RenderObject.debugCheckingIntrinsics) {
        throw FlutterError(
          'LayoutBuilder does not support returning intrinsic dimensions.\n'
          'Calculating the intrinsic dimensions would require running the layout '
          'callback speculatively, which might mutate the live render object tree.',
        );
      }
      return true;
    }());

    return true;
  }
}
