import 'package:flutter_smooth_render/src/binding.dart';
import 'package:flutter_smooth_render/src/misc.dart';
import 'package:flutter_smooth_render/src/rendering.dart';

class SmootherFacade {
  static final instance = SmootherFacade._();

  SmootherFacade._() {
    SmootherWidgetsFlutterBinding.ensureInitialized();
  }

  static void init() {
    final _ = instance; // ensure it is initialized
  }

  final scheduler = SmootherScheduler.raw();
  final workQueue = SmootherWorkQueue.raw();
  final bindingInfo = SmootherBindingInfo.raw();
  SmootherParentLastChildState? smootherParentLastChild;
}
