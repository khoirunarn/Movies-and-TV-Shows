import 'package:flutter/material.dart';
import 'package:praktikum8/pages/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.purple),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
