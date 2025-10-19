import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AwtrixApp());
}

class AwtrixApp extends StatelessWidget {
  const AwtrixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AWTRIX Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
