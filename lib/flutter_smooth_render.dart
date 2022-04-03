import 'package:flutter/material.dart';

class Smoother extends StatelessWidget {
  final SmootherPlaceholder placeholder;
  final WidgetBuilder builder;

  const Smoother({
    Key? key,
    this.placeholder = const SmootherPlaceholder(),
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TODO;
  }
}

@immutable
class SmootherPlaceholder {
  final Size size;
  final Color color;

  const SmootherPlaceholder({
    this.size = const Size(20, 20),
    this.color = Colors.transparent,
  });
}
