import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_smooth_render/src/facade.dart';
import 'package:flutter_smooth_render/src/rendering.dart';

var logger = _defaultLogger;

// ignore: avoid_print
void _defaultLogger(String message) => print('${DateTime.now().toIso8601String()}|$message');

class SmootherScheduler {
  SmootherScheduler.raw();

  static var durationThreshold = const Duration(microseconds: 1000000 ~/ 60);

  bool shouldExecute() {
    final lastFrameStart = SmootherFacade.instance.bindingInfo.lastFrameStart;
    if (lastFrameStart == null) return true; // not sure what to do... so fallback to conservative

    final currentDuration = DateTime.now().difference(lastFrameStart);
    assert(() {
      logger('shouldStartPieceOfWork currentDuration=${currentDuration.inMilliseconds}ms');
      return true;
    }());

    return currentDuration <= durationThreshold;
  }
}

class SmootherWorkQueue {
  final _queue = Queue<RenderSmootherRaw>();

  SmootherWorkQueue.raw();

  bool get isNotEmpty => _queue.isNotEmpty;

  void add(RenderSmootherRaw item) => _queue.add(item);

  void executeMany() {
    while (SmootherFacade.instance.scheduler.shouldExecute() && _queue.isNotEmpty) {
      final item = _queue.removeFirst();
      logger('SmootherWorkQueue executeUntilDeadline markNeedsLayout for ${describeIdentity(item)}');
      item.markNeedsLayout();
    }
  }
}
