import 'package:flutter/material.dart';
import '../game/logic/play_card.dart';
import '../game/logic/suit.dart';
import '../game/logic/value.dart';
import '../services/size.dart';
import 'chip_painter.dart';
import 'chip_selection_painter.dart';

class ChipWidget extends StatefulWidget {
  final PlayCard card;
  ChipWidget({Key key, this.card}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChipWidgetState(card: card);
  }
}

class ChipWidgetState extends State<ChipWidget> {
  final PlayCard card;
  String _suit;
  String _value;

  ChipWidgetState({this.card}) {
    this._suit = suitCharacter(card.suit);
    this._value = valueCharacter(card.value);
  }

  @override
  Widget build(BuildContext context) {
    final diameter = chipSize(context); // ~80
    if (card.suit == Suit.Invalid || card.value == Value.Invalid) {
      return SizedBox(width: diameter, height: diameter);
    }

    final textColor =
        (_suit == 'C' || _suit == 'S') ? Colors.black : Colors.red;
    final fontSize = diameter * (_value == '*' ? 0.8 : 0.625); // ~64 / ~50
    final suitStyle =
        TextStyle(fontSize: fontSize, fontFamily: 'Cards', color: textColor);
    final valueStyle = TextStyle(
        fontSize: fontSize,
        fontFamily: 'Stint-Ultra-Condensed',
        fontWeight: FontWeight.w700,
        color: textColor);

    return SizedBox(
        width: diameter,
        height: diameter,
        child: CustomPaint(
            painter: ChipPainter(),
            foregroundPainter: ChipSelectionPainter(
                selected: card.selected, neighbor: card.neighbor),
            child: Center(
                child: _value == '*'
                    ? Text('J', style: suitStyle)
                    : RichText(
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        text: TextSpan(
                            text: _value,
                            style: valueStyle,
                            children: <TextSpan>[
                              TextSpan(text: _suit, style: suitStyle)
                            ])))));
  }
}
