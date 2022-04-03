import 'package:flutter/material.dart';

class SimpleAnimatedBox extends StatefulWidget {
  const SimpleAnimatedBox({Key? key}) : super(key: key);

  @override
  _SimpleAnimatedBoxState createState() => _SimpleAnimatedBoxState();
}

class _SimpleAnimatedBoxState extends State<SimpleAnimatedBox> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this)
    ..repeat(reverse: false);

  late final _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
        ),
      ),
    );
  }
}
