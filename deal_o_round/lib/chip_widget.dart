import 'package:flutter/material.dart';
import 'chip_painter.dart';

class ChipWidget extends StatelessWidget {
  ChipWidget({
    this.suit,
    this.value
  });

  final String suit;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textColor = (this.suit == 'C' || this.suit == 'S') ?
      Colors.black : Colors.red;
    final suitStyle = TextStyle(
      fontSize: 45,
      fontFamily: 'Cards',
      color: textColor
    );
    final valueStyle = TextStyle(
      fontSize: 45,
      fontFamily: 'Noto-Serif',
      fontWeight: FontWeight.w700,
      color: textColor
    );

    final text = value.length > 1 ?
      <Widget>[
        Text('I', style: valueStyle),
        Text(value[1], style: valueStyle),
        Text(suit, style: suitStyle),
      ] :
      <Widget>[
        Text(value, style: valueStyle),
        Text(suit, style: suitStyle),
      ];

    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(
        painter: ChipPainter(),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: text
          )
        )
      )
    );
  }
}
