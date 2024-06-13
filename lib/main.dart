import 'package:flutter/material.dart';
import 'package:weather_flutter_app/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          // change anything you want
          ),
      home: const WeatherScreen(),
    );
  }
}
