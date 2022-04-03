import 'package:flutter_smooth_render/src/binding.dart';
import 'package:flutter_smooth_render/src/misc.dart';

class SmootherFacade {
  static final instance = SmootherFacade._();

  SmootherFacade._() {
    SmootherWidgetsFlutterBinding.ensureInitialized();
  }

  static void init() {
    final _ = instance; // ensure it is initialized
  }

  final scheduler = SmootherScheduler.raw();
  final bindingInfo = SmootherBindingInfo.raw();
}
