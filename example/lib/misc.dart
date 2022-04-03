import 'dart:async';

import 'package:flutter/material.dart';

class SimpleAnimatedBox extends StatefulWidget {
  const SimpleAnimatedBox({Key? key}) : super(key: key);

  @override
  _SimpleAnimatedBoxState createState() => _SimpleAnimatedBoxState();
}

class _SimpleAnimatedBoxState extends State<SimpleAnimatedBox> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)
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

// everyone should share the *same* ticker to ensure they get the same input at same time
late final _ticker = () {
  final ticker = ValueNotifier(0);
  Timer.periodic(const Duration(seconds: 1), (_) => ticker.value++);
  return ticker;
}();

class SimpleTickBox extends StatefulWidget {
  const SimpleTickBox({Key? key}) : super(key: key);

  @override
  _SimpleTickBoxState createState() => _SimpleTickBoxState();
}

class _SimpleTickBoxState extends State<SimpleTickBox> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _ticker,
      builder: (_, count, __) => Container(
        width: 48 + (count % 5) * 8,
        color: Colors.indigo.shade200,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '$count',
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
