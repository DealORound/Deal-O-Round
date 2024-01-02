import 'package:flutter/material.dart';

import '../game/logic/play_card.dart';
import '../game/logic/suit.dart';
import '../game/logic/value.dart';
import '../services/size.dart';
import 'chip_painter.dart';
import 'chip_selection_painter.dart';

class ChipWidget extends StatefulWidget {
  final PlayCard card;
  const ChipWidget({super.key, required this.card});

  @override
  State<StatefulWidget> createState() => ChipWidgetState();
}

class ChipWidgetState extends State<ChipWidget> {
  late String _suit;
  late String _value;

  @override
  void initState() {
    super.initState();
    setState(() {
      _suit = suitCharacter(widget.card.suit);
      _value = valueCharacter(widget.card.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final diameter = chipSize(context); // ~80
    if (widget.card.suit == Suit.invalid ||
        widget.card.value == Value.invalid) {
      return SizedBox(width: diameter, height: diameter);
    }

    final textColor =
        (_suit == 'c' || _suit == 's') ? Colors.black : Colors.red;
    final fontSize = diameter * (_value == '*' ? 1.0 : 0.625); // ~64 / ~50
    final suitStyle =
        TextStyle(fontSize: fontSize, fontFamily: 'Cards', color: textColor);
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
        foregroundPainter:
            ChipSelectionPainter(widget.card.selected, widget.card.neighbor),
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
