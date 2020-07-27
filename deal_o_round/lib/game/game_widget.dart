import 'package:flutter/material.dart';
import 'background_painter.dart';
import 'game_board.dart';
import 'left_display.dart';
import 'right_display.dart';

class GameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomPaint(
        painter: BackgroundPainter(),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              LeftDisplay(),
              GameBoard(),
              RightDisplay()
            ]
          )
        )
      )
    );
  }
}
