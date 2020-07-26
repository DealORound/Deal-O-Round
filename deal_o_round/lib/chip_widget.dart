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
      fontSize: 50,
      fontFamily: 'Cards',
      color: textColor
    );
    final valueStyle = TextStyle(
      fontSize: 50,
      fontFamily: 'Stint-Ultra-Condensed',
      fontWeight: FontWeight.w700,
      color: textColor
    );

    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(
        painter: ChipPainter(),
        child: Center(
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.visible,
            text: TextSpan(
              text: value,
              style: valueStyle,
              children: <TextSpan>[
                TextSpan(text: suit, style: suitStyle)
              ]
            )
          )
        )
      )
    );
  }
}
