import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MultiTimerApp());
}

class MultiTimerApp extends StatelessWidget {
  const MultiTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASTM F2781 Custom Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 209, 209, 209), // change this to your desired background color
      ),
      home: const HomeScreen(),
    );
  }
}