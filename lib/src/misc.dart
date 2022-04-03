import 'package:flutter_smooth_render/src/binding.dart';

var logger = _defaultLogger;

// ignore: avoid_print
void _defaultLogger(String message) => print('${DateTime.now().toIso8601String()}|$message');

class SmootherScheduler {
  static final instance = SmootherScheduler._();

  SmootherScheduler._();

  static var durationThreshold = const Duration(microseconds: 1000000 ~/ 60);

  bool shouldStartPieceOfWork() {
    final lastFrameStart = SmootherBindingInfo.instance.lastFrameStart;
    if (lastFrameStart == null) return true; // not sure what to do... so fallback to conservative

    final currentDuration = DateTime.now().difference(lastFrameStart);
    return currentDuration <= durationThreshold;
  }
}
