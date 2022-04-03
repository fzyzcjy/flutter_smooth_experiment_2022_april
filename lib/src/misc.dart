import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_smooth_render/src/facade.dart';

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

typedef SmootherWorkJob = void Function();

class SmootherWorkQueue {
  final _queue = Queue<SmootherWorkJob>();

  SmootherWorkQueue.raw();

  void add(SmootherWorkJob item) {
    _queue.add(item);
    _addPostFrameCallback();
  }

  var _hasPostFrameCallback = false;

  void _addPostFrameCallback() {
    if (_hasPostFrameCallback) return;
    _hasPostFrameCallback = true;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // If, after the current frame is finished, there is still some work to be done,
      // Then we need to schedule a new frame
      if (_queue.isNotEmpty) {
        logger('SmootherParentLastChild.markNeedsBuild since SmootherWorkQueue.workQueue not empty');
        SmootherFacade.instance.smootherParentLastChild?.markNeedsBuild();
      }

      _hasPostFrameCallback = false;
    });
  }

  // void executeMany() {
  //   // At least execute one, even if are already too late. Otherwise, on low-end devices,
  //   // it can happen that *no* work is executed on *each and every* frame, so the objects
  //   // are never rendered.
  //   executeOne();
  //
  //   while (SmootherFacade.instance.scheduler.shouldExecute() && _queue.isNotEmpty) {
  //     executeOne();
  //   }
  // }

  void maybeExecuteOne({
    required String debugReason,
    required bool forceExecuteEvenAfterDeadline,
  }) {
    if (_queue.isEmpty) return;
   
    if (!forceExecuteEvenAfterDeadline && !SmootherFacade.instance.scheduler.shouldExecute()) {
      return;
    }

    final item = _queue.removeFirst();
    logger('SmootherWorkQueue executeOne run $item debugReason=$debugReason');
    item();
  }
}
