import 'package:flutter/material.dart';

import '../game/logic/play_card.dart';
import '../game/logic/suit.dart';
import '../game/logic/value.dart';
import '../services/size.dart';
import 'chip_painter.dart';
import 'chip_selection_painter.dart';

class ChipWidget extends StatefulWidget {
  final PlayCard card;
  ChipWidget({Key? key, required this.card}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChipWidgetState(card);
}

class ChipWidgetState extends State<ChipWidget> {
  final PlayCard card;
  late String _suit;
  late String _value;

  ChipWidgetState(this.card) {
    this._suit = suitCharacter(card.suit);
    this._value = valueCharacter(card.value);
  }

  @override
  Widget build(BuildContext context) {
    final diameter = chipSize(context); // ~80
    if (card.suit == Suit.Invalid || card.value == Value.Invalid) {
      return SizedBox(width: diameter, height: diameter);
    }

    final textColor = (_suit == 'C' || _suit == 'S') ? Colors.black : Colors.red;
    final fontSize = diameter * (_value == '*' ? 1.0 : 0.625); // ~64 / ~50
    final suitStyle = TextStyle(fontSize: fontSize, fontFamily: 'Cards', color: textColor);
    final valueStyle = TextStyle(
      fontSize: fontSize,
      fontFamily: 'Stint-Ultra-Condensed',
      fontWeight: FontWeight.w700,
      color: textColor,
    );

    final textValue = _value == '*' ? "" : _value;
    final suitValue = _value == '*' ? "J" : _suit;
    return SizedBox(
      width: diameter,
      height: diameter,
      child: CustomPaint(
        painter: ChipPainter(),
        foregroundPainter: ChipSelectionPainter(card.selected, card.neighbor),
        child: Center(
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.visible,
            text: TextSpan(
              text: textValue,
              style: valueStyle,
              children: <TextSpan>[TextSpan(text: suitValue, style: suitStyle)],
            ),
          ),
        ),
      ),
    );
  }
}
