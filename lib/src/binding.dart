import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class SmootherWidgetsFlutterBinding extends WidgetsFlutterBinding with SmootherServicesBinding {
  static WidgetsBinding ensureInitialized() {
    if (WidgetsBinding.instance == null) SmootherWidgetsFlutterBinding();
    return WidgetsBinding.instance!;
  }
}

mixin SmootherServicesBinding on BindingBase, WidgetsBinding {
  @override
  void handleBeginFrame(Duration? rawTimeStamp) {
    SmootherBindingInfo.instance._lastFrameStart = DateTime.now();
    super.handleBeginFrame(rawTimeStamp);
  }
}

class SmootherBindingInfo {
  static final instance = SmootherBindingInfo._();

  SmootherBindingInfo._();

  DateTime? get lastFrameStart => _lastFrameStart;
  DateTime? _lastFrameStart;
}
