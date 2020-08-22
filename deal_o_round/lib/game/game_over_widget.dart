import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'background_painter.dart';

class GameOverWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
        fontSize: 64,
        fontFamily: 'Musicals',
        color: Colors.white
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: FloatingActionButton(
          onPressed: () => Get.back(),
          child: Icon(Icons.arrow_back, size: 40),
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
