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

class SimpleTickBox extends StatefulWidget {
  const SimpleTickBox({Key? key}) : super(key: key);

  @override
  _SimpleTickBoxState createState() => _SimpleTickBoxState();
}

class _SimpleTickBoxState extends State<SimpleTickBox> {
  var count = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        count++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48 + (count % 5) * 8,
      child: Center(
        child: Text(
          '$count',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
