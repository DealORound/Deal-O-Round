import 'package:flutter/material.dart';
import 'background_painter.dart';
import 'home_page.dart';

class DealORoundApp extends StatelessWidget {
  RadialGradient _getBackgroundGradient() {
    return RadialGradient(
      center: const Alignment(0.5, 0.5),
      radius: 1.0,
      colors: [
        Colors.black,
        Colors.green,
        Colors.lightGreen,
        Colors.lightGreenAccent,
      ],
      stops: [0.0, 0.3, 0.7, 1.0],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deal-O-Round',
      theme: ThemeData(
        backgroundColor: Colors.black,
        primaryColor: Colors.white,
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Container(
        decoration: BoxDecoration(gradient: _getBackgroundGradient()),
        child: CustomPaint(
          painter: BackgroundPainter(),
          child: HomePage(),
        ),
      ),
    );
  }
}
