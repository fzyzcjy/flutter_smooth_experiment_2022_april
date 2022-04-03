import 'package:flutter/material.dart';
import 'package:flutter_smooth_render_example/heavy_widget.dart';
import 'package:flutter_smooth_render_example/misc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Theme(
        data: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(
              builders: Map.fromEntries(TargetPlatform.values
                  .map((platform) => MapEntry(platform, const CupertinoPageTransitionsBuilder())))),
        ),
        child: const FirstPage(),
      ),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SimpleAnimatedBox(),
            TextButton(
              onPressed: () =>
                  Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(builder: (_) => const SecondPage())),
              child: const Text('Navigate'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  var heaviness = const Duration(milliseconds: 8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First')),
      body: Column(
        children: [
          Row(
            children: [
              const Text('Heaviness'),
              for (final targetHeaviness in const [
                Duration(milliseconds: 1),
                Duration(milliseconds: 4),
                Duration(milliseconds: 8),
                Duration(milliseconds: 16)
              ])
                Expanded(
                  child: TextButton(
                    onPressed: () => setState(() => heaviness = targetHeaviness),
                    child: Text(
                      '${targetHeaviness.inMilliseconds}ms',
                      style: TextStyle(color: targetHeaviness == heaviness ? Colors.blue : Colors.black87),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: SizedBox(
                  height: 32,
                  child: Row(
                    children: [
                      SizedBox(width: 48, child: Text('#$index')),
                      Expanded(child: HeavyBuildPhaseWidget(heaviness: heaviness)),
                      Expanded(child: HeavyLayoutPhaseWidget(heaviness: heaviness)),
                      Expanded(child: HeavyPaintPhaseWidget(heaviness: heaviness)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
