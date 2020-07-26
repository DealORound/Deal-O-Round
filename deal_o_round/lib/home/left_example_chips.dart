import 'package:flutter/material.dart';
import '../game/chip_widget.dart';
import 'swipe_painter.dart';

class LeftExampleChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: SwipePainter(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              ChipWidget(suit: '3', value: 'Q'),
              ChipWidget(suit: 'C', value: '6')
            ]
          ),
          Row(
            children: <Widget>[
              ChipWidget(suit: 'S', value: 'Q'),
              ChipWidget(suit: '3', value: '10')
            ]
          ),
          Row(
            children: <Widget>[
              ChipWidget(suit: 'C', value: 'Q'),
              ChipWidget(suit: '4', value: '6')
            ]
          ),
        ]
      )
    );
  }
}
