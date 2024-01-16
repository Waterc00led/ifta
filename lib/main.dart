import 'package:flutter/material.dart';
import 'package:ifta/splash_Screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IFTA Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue[800],
      ),
      home: const SplashScreen(),
    );
  }
}
