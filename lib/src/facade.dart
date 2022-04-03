import 'package:flutter_smooth_render/src/binding.dart';
import 'package:flutter_smooth_render/src/misc.dart';
import 'package:flutter_smooth_render/src/rendering.dart';
import 'package:meta/meta.dart';

class SmootherFacade {
  static final instance = SmootherFacade._();

  SmootherFacade._() {
    SmootherWidgetsFlutterBinding.ensureInitialized();
  }

  static void init() {
    final _ = instance; // ensure it is initialized
  }

  var debugDisableFunctionality = false;

  @internal
  final scheduler = SmootherScheduler.raw();
  @internal
  final workQueue = SmootherWorkQueue.raw();
  @internal
  final bindingInfo = SmootherBindingInfo.raw();
  @internal
  SmootherParentLastChildState? smootherParentLastChild;
}
