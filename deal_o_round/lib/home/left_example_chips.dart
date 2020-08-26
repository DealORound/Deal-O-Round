import 'package:flutter/material.dart';
import '../game/logic/play_card.dart';
import '../game/logic/suit.dart';
import '../game/logic/value.dart';
import '../game/chip_widget.dart';
import 'swipe_painter.dart';

class LeftExampleChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        foregroundPainter: SwipePainter(),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Row(children: <Widget>[
            ChipWidget(card: PlayCard(suit: Suit.Hearts, value: Value.Queen)),
            ChipWidget(card: PlayCard(suit: Suit.Clubs, value: Value.Six))
          ]),
          Row(children: <Widget>[
            ChipWidget(card: PlayCard(suit: Suit.Spades, value: Value.Queen)),
            ChipWidget(card: PlayCard(suit: Suit.Hearts, value: Value.Ten))
          ]),
          Row(children: <Widget>[
            ChipWidget(card: PlayCard(suit: Suit.Clubs, value: Value.Queen)),
            ChipWidget(card: PlayCard(suit: Suit.Diamonds, value: Value.Six))
          ]),
        ]));
  }
}
