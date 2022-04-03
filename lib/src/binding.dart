import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_smooth_render/src/facade.dart';

class SmootherWidgetsFlutterBinding extends WidgetsFlutterBinding with SmootherServicesBinding {
  static WidgetsBinding ensureInitialized() {
    if (WidgetsBinding.instance == null) SmootherWidgetsFlutterBinding();

    // extra check compared with [WidgetsBinding.ensureInitialized]
    if (WidgetsBinding.instance is! SmootherWidgetsFlutterBinding) {
      throw Exception('Please ensure WidgetsBinding.instance is SmootherWidgetsFlutterBinding');
    }

    return WidgetsBinding.instance!;
  }
}

mixin SmootherServicesBinding on BindingBase, WidgetsBinding {
  @override
  void handleBeginFrame(Duration? rawTimeStamp) {
    SmootherFacade.instance.bindingInfo._lastFrameStart = DateTime.now();
    super.handleBeginFrame(rawTimeStamp);
  }
}

class SmootherBindingInfo {
  SmootherBindingInfo.raw();

  DateTime? get lastFrameStart => _lastFrameStart;
  DateTime? _lastFrameStart;
}
