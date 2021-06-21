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
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(children: [
          ChipWidget(card: PlayCard(Suit.Hearts, Value.Queen)),
          ChipWidget(card: PlayCard(Suit.Clubs, Value.Six)),
        ]),
        Row(children: [
          ChipWidget(card: PlayCard(Suit.Spades, Value.Queen)),
          ChipWidget(card: PlayCard(Suit.Hearts, Value.Ten)),
        ]),
        Row(children: [
          ChipWidget(card: PlayCard(Suit.Clubs, Value.Queen)),
          ChipWidget(card: PlayCard(Suit.Diamonds, Value.Six)),
        ]),
      ]),
    );
  }
}
