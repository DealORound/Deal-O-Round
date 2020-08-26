import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/size.dart';
import 'background_painter.dart';

class GameOverWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final radius = chipRadius(context);  // ~40
    final fontSize = radius * 1.5;  // ~60
    final textStyle = TextStyle(
        fontSize: fontSize,
        fontFamily: 'Musicals',
        color: Colors.white
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: fontSize),
        child: FloatingActionButton(
          onPressed: () => Get.back(),
          child: Icon(Icons.arrow_back, size: radius),
          backgroundColor: Colors.green,
        ),
      ),
      body: CustomPaint(
        painter: BackgroundPainter(),
        child: Center(
          child: Text("Game Over", style: textStyle)
        )
      )
    );
  }
}
