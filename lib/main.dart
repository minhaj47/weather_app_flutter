import 'package:flutter/material.dart';
import 'package:weather_flutter_app/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          brightness == Brightness.light ? ThemeData.light() : ThemeData.dark(),
      home: const WeatherScreen(),
    );
  }
}
