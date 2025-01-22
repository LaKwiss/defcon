import 'package:defcon/hex.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final hex = Hex(
      null,
      id: '1',
      q: 0,
      r: 0,
      s: 0,
      type: 'plain',
      connections: [],
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Center(
        child: InteractiveViewer(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Stack(
              children: [hex.toWidget(20)],
            ),
          ),
        ),
      ),
    );
  }
}
