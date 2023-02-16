import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'page/start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XL-TTS Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const StartPage(),
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
      },
    );
  }
}
