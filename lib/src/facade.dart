import 'package:flutter_smooth_render/src/binding.dart';
import 'package:flutter_smooth_render/src/misc.dart';
import 'package:flutter_smooth_render/src/rendering.dart';
import 'package:meta/meta.dart';

class SmootherFacade {
  static final instance = SmootherFacade._();

  SmootherFacade._() {
    SmootherWidgetsFlutterBinding.ensureInitialized();

    addPostFrameCallbackForAllFrames((_) {
      hasSwapChildInCurrentFrame = false;
      hasExecuteWorkQueueInCurrentFrame = false;
    });
  }

  static void init() {
    final _ = instance; // ensure it is initialized
  }

  var debugDisableFunctionality = false;

  // TODO move this state variable
  // At least execute one, even if are already too late. Otherwise, on low-end devices,
  // it can happen that *no* work is executed on *each and every* frame, so the objects
  // are never rendered.
  @internal
  var hasSwapChildInCurrentFrame = false;
  @internal
  var hasExecuteWorkQueueInCurrentFrame = false;

  @internal
  final scheduler = SmootherScheduler.raw();
  @internal
  final workQueue = SmootherWorkQueue.raw();
  @internal
  final bindingInfo = SmootherBindingInfo.raw();
  @internal
  RenderSmootherParentLastChildRaw? smootherParentLastChild;
}
