import 'package:flutter/material.dart';
import 'package:flutter_smooth_render/flutter_smooth_render.dart';

class HeavyBuildPhaseWidget extends StatefulWidget {
  final Duration heaviness;
  final Object? refreshTrigger;
  final Widget? child;

  const HeavyBuildPhaseWidget({
    Key? key,
    required this.heaviness,
    this.refreshTrigger,
    this.child,
  }) : super(key: key);

  @override
  State<HeavyBuildPhaseWidget> createState() => _HeavyBuildPhaseWidgetState();
}

class _HeavyBuildPhaseWidgetState extends State<HeavyBuildPhaseWidget> {
  @override
  void initState() {
    super.initState();
    _doHeavyWork();
  }

  @override
  void didUpdateWidget(covariant HeavyBuildPhaseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshTrigger != widget.refreshTrigger) _doHeavyWork();
  }

  void _doHeavyWork() => doHeavyWork(widget.heaviness, debugName: 'Build');

  @override
  Widget build(BuildContext context) => widget.child ?? _buildDefaultChild(color: Colors.lime);
}

class HeavyLayoutPhaseWidget extends StatelessWidget {
  final Duration heaviness;
  final Object? refreshTrigger;
  final Widget? child;

  const HeavyLayoutPhaseWidget({
    Key? key,
    required this.heaviness,
    this.refreshTrigger,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: _HeavySingleChildLayoutDelegate(
        heaviness: heaviness,
        refreshTrigger: refreshTrigger,
      ),
      child: child ?? _buildDefaultChild(color: Colors.green),
    );
  }
}

class _HeavySingleChildLayoutDelegate extends SingleChildLayoutDelegate {
  final Duration heaviness;
  final Object? refreshTrigger;

  _HeavySingleChildLayoutDelegate({
    required this.heaviness,
    this.refreshTrigger,
  });

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // This is run inside RenderObject's [layout] function
    doHeavyWork(heaviness, debugName: 'Layout');
    return Offset.zero;
  }

  @override
  bool shouldRelayout(covariant _HeavySingleChildLayoutDelegate oldDelegate) =>
      oldDelegate.refreshTrigger != refreshTrigger;
}

class HeavyPaintPhaseWidget extends StatelessWidget {
  final Duration heaviness;
  final Object? refreshTrigger;
  final Widget? child;

  const HeavyPaintPhaseWidget({
    Key? key,
    required this.heaviness,
    this.refreshTrigger,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HeavyCustomPainter(
        heaviness: heaviness,
        refreshTrigger: refreshTrigger,
      ),
      child: child ?? _buildDefaultChild(color: Colors.blue),
    );
  }
}

class _HeavyCustomPainter extends CustomPainter {
  final Duration heaviness;
  final Object? refreshTrigger;

  _HeavyCustomPainter({
    required this.heaviness,
    this.refreshTrigger,
  });

  @override
  void paint(Canvas canvas, Size size) {
    doHeavyWork(heaviness, debugName: 'Paint');
  }

  @override
  bool shouldRepaint(covariant _HeavyCustomPainter oldDelegate) => oldDelegate.refreshTrigger != refreshTrigger;
}

int doHeavyWork(Duration heaviness, {required String debugName}) {
  final startTime = DateTime.now();

  var dummy = 0;
  while (DateTime.now().difference(startTime) < heaviness) {
    // "heavy" computation
    for (var i = 0; i < 10000; ++i) {
      dummy ^= i;
    }
  }

  if (DateTime.now().difference(startTime) < heaviness) {
    throw Exception('doHeavyWork does not really execute that long');
  }

  // ignore: avoid_print
  logger('doHeavyWork[$debugName] end heaviness=${heaviness.inMilliseconds}ms');

  return dummy;
}

Widget _buildDefaultChild({required Color color}) => Container(
      width: 48,
      height: 48,
      color: color,
    );
