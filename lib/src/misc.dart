import 'package:flutter_smooth_render/src/facade.dart';

var logger = _defaultLogger;

// ignore: avoid_print
void _defaultLogger(String message) => print('${DateTime.now().toIso8601String()}|$message');

class SmootherScheduler {
  SmootherScheduler.raw();

  static var durationThreshold = const Duration(microseconds: 1000000 ~/ 60);

  bool shouldStartPieceOfWork() {
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
